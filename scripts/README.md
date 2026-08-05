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
