# Auditoria de observabilidade e logging

Prompt para revisar a arquitetura de observabilidade de uma aplicação e propor
um logging estruturado, seguro e com níveis bem definidos.

## Prompt

Atue como um engenheiro de software Senior e revise toda a arquitetura de
observabilidade da aplicação. Identifique:

1. Falta de logs estruturados (JSON) em blocos `try/catch` críticos.
2. Pontos onde a aplicação falha silenciosamente.
3. Ausência de contexto nos logs (`userId`, `action`, `requestId`).

Sugira a implementação de um logger profissional (do tipo Winston ou Pino) e
garanta a sanitização rigorosa (data masking) para que senhas, tokens e dados
pessoais nunca sejam gravados no log. O sistema deve separar níveis de log
(`info`, `warn`, `error`, `fatal`).
