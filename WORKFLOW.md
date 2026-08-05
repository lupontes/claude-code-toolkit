# Fluxo de trabalho

Como as peças deste toolkit se encaixam, e como reconstituir esse ambiente
inteiro numa estação de trabalho nova a partir deste repositório.

## As camadas

| Camada | Papel | Onde está |
|---|---|---|
| **Produtividade** | Prompts, comandos e skills que melhoram a execução diária do agente. | [`superpowers`](#superpowers-não-vendorado) (marketplace oficial, não vendorado aqui) |
| **Documentação** | Documentação e exemplos atualizados de bibliotecas/frameworks durante a implementação. | [`mcp-configs/context7`](mcp-configs/context7) |
| **Execução** | Escreve, altera e refatora código. | Claude Code em si |
| **Orquestração** | Decide o que fazer em seguida, mantém o agente trabalhando até o backlog acabar. | primitivas nativas do Claude Code — ver [abaixo](#orquestração-sem-plugin-de-terceiro) |
| **Memória** | Persistência de contexto entre sessões, handoff entre agentes. | [`plugins/claude-mem`](plugins/claude-mem), [`plugins/handoff`](plugins/handoff) |
| **Segurança** | — | vazio por enquanto |
| **Testes** | — | vazio por enquanto |

Sem orquestração, o ciclo é manual — você diz "faça a próxima", "corrija os
testes", "documenta", "commita", um de cada vez. Com orquestração, você define
o objetivo (um PRD, uma lista de issues, um plano) uma vez, e o agente decide
os próximos passos sozinho, testando e commitando a cada etapa, até o
trabalho acabar.

```
Você define o objetivo
        ↓
Orquestração cria/segue o backlog
        ↓
Claude Code + skills de produtividade executam
        ↓
Context7 fornece documentação durante a implementação
        ↓
Testes
        ↓
Commit
        ↓
Próxima tarefa automaticamente
```

## Orquestração sem plugin de terceiro

A pesquisa inicial para este toolkit cogitava instalar um plugin de
"Ralph Loop" (a técnica do Geoffrey Huntley — um loop que chama o agente
repetidamente até o backlog zerar). Investigando as opções disponíveis no
GitHub, a mais alinhada ao padrão de plugin deste repositório
(`MarioGiancini/ralph-loop-setup`) está **deprecada desde 2026-06-20 pelo
próprio autor**, com a nota explícita: *"retired in favor of native Claude
Code loop primitives (`/goal`, `/loop`, `/schedule`, workflows). Do not
install in new projects."*

Ou seja: o papel que o "Ralph Loop" cumpriria já é nativo. Nenhuma instalação
necessária — só saber usar:

- **`/loop`** — roda um prompt ou slash command repetidamente num intervalo
  fixo (`/loop 5m /minha-tarefa`), ou deixa o próprio modelo decidir o ritmo
  (modo dinâmico, sem intervalo). É o mais parecido com o "mantém o agente
  trabalhando até completar o backlog".
- **`schedule`** — cria/lista/roda agentes agendados via cron, pra rotinas
  recorrentes (ex: checar PRs todo dia às 9h).
- **Ferramenta `Workflow`** — orquestração multi-agente determinística:
  fases, pipeline, paralelismo, revisão adversarial entre agentes. É a peça
  mais sofisticada — decompõe um objetivo grande em subagentes especializados
  (encontrar → implementar → revisar → corrigir) com barreiras de sincronização
  só onde realmente precisam.

Nenhuma dessas depende de instalar nada deste repositório — já vêm com o
Claude Code. A camada de orquestração deste toolkit é, portanto, **saber
combinar `/loop`/`schedule`/`Workflow` com o objetivo que você está
perseguindo**, não um plugin a mais pra manter atualizado.

## Reconfigurar uma estação de trabalho nova

Passo a passo pra sair de uma máquina zerada até este ambiente completo.

### 1. Instalar o Claude Code

Siga https://claude.com/product/claude-code — fora do escopo deste repo.

### 2. Adicionar este marketplace e instalar os plugins vendorados

```
/plugin marketplace add lupontes/claude-code-toolkit
/plugin install claude-mem@claude-code-toolkit
/plugin install handoff@claude-code-toolkit
/plugin install headroom@claude-code-toolkit
/plugin install hyperframes@claude-code-toolkit
```

### 3. Instalar o Superpowers (marketplace oficial, não vendorado aqui)

```
/plugin marketplace add claude-plugins-official
/plugin install superpowers@claude-plugins-official
```

Motivo de não vendorar: é um plugin oficial grande, atualizado com frequência
— vendorar significaria sempre ficar uma versão atrás. Mesma lógica já
aplicada ao `hyperframes` (referenciado, não vendorado).

### 4. Configurar o Context7 (MCP)

Copie [`mcp-configs/context7/context7.example.json`](mcp-configs/context7/context7.example.json)
pra dentro de `mcpServers` em `~/.claude/settings.json`. Funciona sem API key
(limite menor); veja o [README do context7](mcp-configs/context7/README.md)
pra configurar uma key e subir o limite.

### 5. (Opcional) Hook de sync automático por sessão

Copie [`scripts/sync-any-project.sh`](scripts/sync-any-project.sh) para
`~/scripts/` e siga [`scripts/README.md`](scripts/README.md) pra registrar o
hook de `SessionStart` no `~/.claude/settings.json`.

### 6. Confirmar

```
claude plugin list
claude mcp list
```

Deve aparecer `claude-mem`, `handoff`, `headroom`, `hyperframes@claude-code-toolkit`
e `superpowers@claude-plugins-official` habilitados, e `context7` (e demais
MCPs pessoais) na lista de servidores — este último só assume depois de uma
sessão nova ser aberta (mudança em `settings.json` não recarrega a quente).

## Escopo: global, não por projeto

Tudo aqui é instalado uma vez em `~/.claude/` (escopo `user`) e vale
automaticamente pra qualquer projeto que você abrir depois — não é preciso
repetir a instalação projeto a projeto.
