# claude-code-toolkit

Coleção pessoal de plugins, skills, prompts e comandos customizados para o
[Claude Code](https://claude.com/product/claude-code), organizados para reuso
e compartilhamento.

## Instalação rápida

```
/plugin marketplace add lupontes/claude-code-toolkit
/plugin install <nome-do-plugin>@claude-code-toolkit
```

Exemplo:

```
/plugin install handoff@claude-code-toolkit
```

## Conteúdo

### Plugins

Os três primeiros plugins são **cópias vendoradas** de projetos de terceiros,
redistribuídos aqui sob suas licenças originais (cada pasta mantém seu
`LICENSE`/`NOTICE` e um `VENDORED.md` com o link para o upstream canônico). O
`hyperframes` é **referenciado por fonte GitHub** (não vendorado) — por ser um
monorepo grande que já é o próprio marketplace, ele é instalado direto do
upstream, sempre na versão mais recente.

| Plugin | Descrição | Upstream | Fonte | Licença |
|---|---|---|---|---|
| `claude-mem` | Sistema de compressão de memória — persiste contexto entre sessões do Claude Code. | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | vendorado | Apache-2.0 |
| `handoff` | Cria documentos de handoff (tarefa, progresso e arquivos modificados) para retomar o trabalho em qualquer agente de IA. | [willseltzer/claude-handoff](https://github.com/willseltzer/claude-handoff) | vendorado | MIT |
| `headroom` | Startup hooks para Claude Code e GitHub Copilot CLI. | [chopratejas/headroom](https://github.com/chopratejas/headroom) | vendorado | Apache-2.0 |
| `hyperframes` | HyperFrames da HeyGen: escreva HTML, renderize vídeo — composições, animações GSAP, legendas, narrações e captura de sites. | [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) | referência GitHub | Apache-2.0 |

### Skills

| Skill | Descrição |
|---|---|
| [`graphify`](skills/graphify) | Transforma qualquer entrada (código, docs, papers, imagens, vídeos) em um grafo de conhecimento persistente, com god nodes, detecção de comunidades e ferramentas de query/path/explain. |

### Commands

Nenhum slash command próprio ainda — ver [`commands/`](commands).

### Prompts

| Prompt | Descrição |
|---|---|
| [`observability-logging-audit`](prompts/observability-logging-audit.md) | Revisa a arquitetura de observabilidade: logs estruturados (JSON), falhas silenciosas, contexto (userId/action/requestId), logger profissional (Winston/Pino), data masking e níveis de log. |

## Uso manual (sem marketplace)

Caso prefira copiar os arquivos manualmente em vez de instalar via plugin:

```bash
git clone https://github.com/lupontes/claude-code-toolkit.git
cp -r claude-code-toolkit/skills/* ~/.claude/skills/
# (quando houver commands/prompts próprios)
# cp claude-code-toolkit/commands/*.md ~/.claude/commands/
```

## Licença

O conteúdo **original** deste repositório (configuração de marketplace,
documentação e as skills/commands/prompts de autoria própria) é MIT — ver
[`LICENSE`](LICENSE).

Cada plugin vendorado em `plugins/` mantém a licença e o copyright do autor
original. Este repositório não é a fonte canônica desses plugins; para a versão
mais recente, issues e contribuições, use os repositórios upstream linkados
acima.
