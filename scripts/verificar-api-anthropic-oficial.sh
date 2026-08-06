#!/bin/bash
# Verifica e remove qualquer configuração do Claude Code apontando para uma
# API de terceiro (proxy não-oficial), restaurando o uso da API oficial da
# Anthropic (api.anthropic.com).
#
# Uso:
#   bash verificar-api-anthropic-oficial.sh          # só diagnostica, não altera nada
#   bash verificar-api-anthropic-oficial.sh --fix    # diagnostica E corrige (faz backup antes)
#
# Seguro de rodar em qualquer máquina: só olha para arquivos/variáveis já
# existentes, nunca cria uma API key nova nem se conecta a nenhum servidor.

set -uo pipefail

FIX=false
if [ "${1:-}" = "--fix" ]; then
  FIX=true
fi

FOUND_ISSUES=0
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Domínios conhecidos de proxies não-oficiais e formatos de chave que NÃO
# são da Anthropic (chaves reais da Anthropic começam com "sk-ant-").
THIRD_PARTY_PATTERN='kpalabz\.com|sk-kpa-'
OFFICIAL_DOMAIN="api.anthropic.com"

say() { printf '%s\n' "$1"; }
warn() { printf '\033[33m⚠ %s\033[0m\n' "$1"; }
ok() { printf '\033[32m✓ %s\033[0m\n' "$1"; }
bad() { printf '\033[31m✗ %s\033[0m\n' "$1"; FOUND_ISSUES=$((FOUND_ISSUES + 1)); }

backup_file() {
  local f="$1"
  cp "$f" "${f}.bak-${TIMESTAMP}"
  say "  (backup salvo em ${f}.bak-${TIMESTAMP})"
}

say "== 1. Variáveis de ambiente na sessão atual =="
if [ -n "${ANTHROPIC_BASE_URL:-}" ]; then
  if echo "$ANTHROPIC_BASE_URL" | grep -qiE "$THIRD_PARTY_PATTERN"; then
    bad "ANTHROPIC_BASE_URL está setada para um proxy conhecido de terceiro: $ANTHROPIC_BASE_URL"
  elif [ "$ANTHROPIC_BASE_URL" != "https://$OFFICIAL_DOMAIN" ] && [ -n "$ANTHROPIC_BASE_URL" ]; then
    warn "ANTHROPIC_BASE_URL está setada pra algo não-oficial: $ANTHROPIC_BASE_URL (revise manualmente se não reconhecer)"
    FOUND_ISSUES=$((FOUND_ISSUES + 1))
  else
    ok "ANTHROPIC_BASE_URL aponta para a API oficial"
  fi
else
  ok "ANTHROPIC_BASE_URL não está setada (usa o padrão oficial automaticamente)"
fi

if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
  if echo "$ANTHROPIC_API_KEY" | grep -qE '^sk-kpa-'; then
    bad "ANTHROPIC_API_KEY é uma chave do proxy de terceiro (prefixo sk-kpa-), não da Anthropic"
  elif ! echo "$ANTHROPIC_API_KEY" | grep -qE '^sk-ant-'; then
    warn "ANTHROPIC_API_KEY não tem o formato oficial da Anthropic (deveria começar com sk-ant-)"
    FOUND_ISSUES=$((FOUND_ISSUES + 1))
  else
    ok "ANTHROPIC_API_KEY tem o formato oficial da Anthropic"
  fi
fi
say ""

say "== 2. Arquivos de shell rc (~/.bashrc, ~/.zshrc, ~/.profile, ~/.bash_profile) =="
for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile" "$HOME/.bash_profile"; do
  [ -f "$rc" ] || continue
  if grep -qE "ANTHROPIC_(BASE_URL|API_KEY)" "$rc"; then
    if grep -qiE "$THIRD_PARTY_PATTERN" "$rc"; then
      bad "$rc contém referência ao proxy de terceiro"
      grep -nE "ANTHROPIC_(BASE_URL|API_KEY)" "$rc" | sed -E 's/(API_KEY[^=]*=).*/\1***OCULTADO***/'
      if $FIX; then
        backup_file "$rc"
        sed -i.tmp -E '/ANTHROPIC_BASE_URL.*kpalabz/d; /ANTHROPIC_API_KEY.*sk-kpa-/d' "$rc"
        rm -f "${rc}.tmp"
        ok "  Linhas removidas de $rc"
      fi
    else
      warn "$rc define ANTHROPIC_BASE_URL/ANTHROPIC_API_KEY — confira manualmente se é intencional:"
      grep -nE "ANTHROPIC_(BASE_URL|API_KEY)" "$rc" | sed -E 's/(API_KEY[^=]*=).*/\1***OCULTADO***/'
      FOUND_ISSUES=$((FOUND_ISSUES + 1))
    fi
  fi
done
ok "Verificação de shell rc concluída"
say ""

say "== 3. ~/.claude/settings.json =="
SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
  if grep -qiE "$THIRD_PARTY_PATTERN" "$SETTINGS"; then
    bad "$SETTINGS contém configuração do proxy de terceiro"
    if $FIX; then
      backup_file "$SETTINGS"
      # Remove só a chave "env" se ela contiver o padrão de terceiro; não mexe no resto do settings.json.
      python3 - "$SETTINGS" <<'PYEOF'
import json, sys, re
path = sys.argv[1]
with open(path) as f:
    data = json.load(f)
env = data.get("env", {})
pattern = re.compile(r"kpalabz\.com|sk-kpa-", re.IGNORECASE)
removed = [k for k, v in list(env.items()) if isinstance(v, str) and pattern.search(v)]
for k in removed:
    del env[k]
if removed:
    if env:
        data["env"] = env
    else:
        data.pop("env", None)
    with open(path, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"  Removido de env: {removed}")
else:
    print("  Nada para remover (padrão não encontrado na chave 'env')")
PYEOF
    fi
  else
    ok "$SETTINGS não contém referência ao proxy de terceiro"
  fi
else
  ok "$SETTINGS não existe (nada a verificar)"
fi
say ""

say "== 4. ~/.claude/config.json (não deveria existir / não deveria ter sido usado pra isso) =="
CONFIG_JSON="$HOME/.claude/config.json"
if [ -f "$CONFIG_JSON" ]; then
  warn "$CONFIG_JSON existe. O Claude Code moderno não usa esse arquivo para credenciais — confira o conteúdo manualmente antes de mexer:"
  say "  $(head -c 200 "$CONFIG_JSON")..."
  FOUND_ISSUES=$((FOUND_ISSUES + 1))
else
  ok "$CONFIG_JSON não existe"
fi
say ""

say "== 5. Arquivos .env no diretório atual e no HOME =="
for envfile in "$HOME/.env" ./.env; do
  [ -f "$envfile" ] || continue
  if grep -qiE "$THIRD_PARTY_PATTERN" "$envfile" 2>/dev/null; then
    bad "$envfile contém referência ao proxy de terceiro"
    if $FIX; then
      backup_file "$envfile"
      sed -i.tmp -E '/ANTHROPIC_BASE_URL.*kpalabz/d; /ANTHROPIC_API_KEY.*sk-kpa-/d' "$envfile"
      rm -f "${envfile}.tmp"
      ok "  Linhas removidas de $envfile"
    fi
  fi
done
ok "Verificação de .env concluída"
say ""

say "== 6. Configuração de extensões de IDE (VSCode / Cursor / Kilo Code) =="
for dir in "$HOME/.config/Code/User" "$HOME/.config/Code - Insiders/User" "$HOME/.config/Cursor/User"; do
  [ -d "$dir" ] || continue
  if grep -rlqiE "$THIRD_PARTY_PATTERN" "$dir" 2>/dev/null; then
    bad "Encontrado no diretório de configuração do editor ($dir):"
    grep -rlE "$THIRD_PARTY_PATTERN" "$dir" 2>/dev/null | while read -r f; do say "  - $f"; done
    say "  (edite manualmente — este script não altera configuração de extensão de IDE automaticamente)"
  else
    ok "Nada encontrado em $dir"
  fi
done
say ""

say "== Resumo =="
if [ "$FOUND_ISSUES" -eq 0 ]; then
  ok "Nenhum indício de configuração de API de terceiro. Claude Code está usando a API oficial da Anthropic."
else
  bad "$FOUND_ISSUES ponto(s) de atenção encontrado(s) acima."
  if $FIX; then
    say ""
    say "Correções aplicadas onde foi seguro automatizar. Abra um terminal NOVO"
    say "(pra recarregar as variáveis de ambiente) e rode este script de novo sem --fix"
    say "pra confirmar que ficou limpo."
  else
    say ""
    say "Rode novamente com --fix para tentar corrigir automaticamente o que for seguro"
    say "(shell rc, settings.json, .env). Configuração de extensão de IDE precisa ser"
    say "removida manualmente."
  fi
fi

say ""
say "IMPORTANTE: se você chegou a usar a chave sk-kpa-... de verdade em alguma"
say "máquina, considere-a comprometida e pare de usá-la — ela nunca foi uma"
say "credencial da Anthropic, era controlada por um terceiro desconhecido."
