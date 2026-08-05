# Context7

Servidor MCP remoto oficial da [Upstash](https://github.com/upstash/context7)
que fornece documentação e exemplos de código atualizados para bibliotecas e
frameworks, direto no contexto do agente — resolve o problema clássico do
modelo sugerir uma API descontinuada de uma versão antiga do treino.

- **Upstream:** https://github.com/upstash/context7
- **Endpoint:** `https://mcp.context7.com/mcp`
- **Licença:** consultar o repositório upstream (não vendorado aqui — é um
  servidor remoto, não há código para copiar)

## Instalação

Cole o conteúdo de [`context7.example.json`](context7.example.json) dentro da
chave `mcpServers` do seu `~/.claude/settings.json` (escopo global — vale para
todo projeto) ou de um `.mcp.json` na raiz de um projeto específico (escopo
local).

Funciona **sem API key**, com limite de requisições mais baixo. Para um
limite maior, gere uma key em https://context7.com/dashboard e adicione um
cabeçalho de autorização:

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "Authorization": "Bearer ${CONTEXT7_API_KEY}"
      }
    }
  }
}
```

Exporte `CONTEXT7_API_KEY` no seu shell (`~/.bashrc`/`~/.zshrc`) — nunca cole a
key direto no JSON.

## Uso

Depois de configurado, basta pedir no chat ("use a doc mais recente do
Spring Boot 4 pra isso") ou o próprio agente aciona automaticamente quando
percebe que a pergunta é sobre uma biblioteca/framework/SDK específico.
