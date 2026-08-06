# Scripts

Scripts de automação de ambiente, pensados para rodar via hooks do Claude
Code (não são plugins nem skills — vivem fora do mecanismo de marketplace).

## `sync-any-project.sh`

Hook de `SessionStart`: detecta o repositório git mais próximo do diretório
atual (sobe a árvore até achar um `.git`) e roda o mecanismo de sync que esse
projeto já tiver — na ordem: `scripts/sync-all-auto.sh`,
`scripts/sync-memories.sh`, `sync-all.sh`, ou (se houver um marcador
`.sync-config`/`.sync`) um `git fetch && git pull --ff-only` genérico com
`git submodule update --remote --merge`. Se nada bater, não faz nada — é
seguro rodar em qualquer diretório, mesmo fora de um projeto conhecido.

Instalação (`~/.claude/settings.json`, escopo global):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/scripts/sync-any-project.sh",
            "timeout": 30,
            "statusMessage": "Sincronizando repositório e memórias...",
            "async": true
          }
        ]
      }
    ]
  }
}
```

Copie o script para `~/scripts/sync-any-project.sh` (ou ajuste o `command`
acima para o caminho onde você o deixar).

## `verificar-api-anthropic-oficial.sh`

Detecta e (opcionalmente) remove qualquer configuração do Claude Code
apontando para uma API de terceiro/proxy não-oficial (ex: `ANTHROPIC_BASE_URL`
customizada, chave que não tem o prefixo `sk-ant-` da Anthropic), garantindo
que o CLI está falando com `api.anthropic.com` de verdade.

Checa: variáveis de ambiente da sessão, `~/.bashrc`/`~/.zshrc`/`~/.profile`,
`~/.claude/settings.json`, `~/.claude/config.json`, arquivos `.env`, e
diretórios de configuração de VSCode/Cursor.

```bash
# só diagnostica, não altera nada
bash verificar-api-anthropic-oficial.sh

# diagnostica e corrige o que for seguro automatizar (faz backup .bak-<timestamp> antes)
bash verificar-api-anthropic-oficial.sh --fix
```

Configuração de extensão de IDE (Kilo Code, Cursor, etc.) é só reportada —
esta parte precisa ser removida manualmente, o script não edita config de
extensão de terceiros automaticamente.
