<!-- .repo/README.md -->
# Setup Scripts

Este diretorio contem scripts de bootstrap para ferramentas auxiliares de agentes.

## Arquivos
- `playwright.sh`: instala `@playwright/cli@latest` e executa `playwright-cli install --skills` para os alvos selecionados.
- `context7.sh`: configura o MCP `context7` para `codex`, `opencode` e `cursor`.
- `env.sh`: carrega variaveis de ambiente do arquivo `.repo.env`.
- `.repo.env`: arquivo de chaves/configuracoes usadas pelos scripts de setup.

## Pré-requisitos
- Node.js 18+
- `npm`

## Uso
- `source .repo/env.sh` (opcional; os instaladores ja carregam automaticamente)
- `bash .repo/playwright.sh` ou `bash .repo/playwright.sh all`
- `bash .repo/playwright.sh codex`
- `bash .repo/playwright.sh opencode`
- `bash .repo/context7.sh` ou `bash .repo/context7.sh all`
- `bash .repo/context7.sh codex`
- `bash .repo/context7.sh opencode`
- `bash .repo/context7.sh cursor`

## Comportamento
- Valida versão mínima do Node.js.
- Tenta instalação global do `playwright-cli`.
- Se instalação global falhar, usa prefixo local em `~/.local`.
- Instala skills por sessão (`PLAYWRIGHT_CLI_SESSION`) para `codex` e/ou `opencode`.
- Configura Context7 no Codex via `codex mcp add`.
- Ajusta `startup_timeout_sec` no `~/.codex/config.toml` para `mcp_servers.context7` (padrao `30`, configuravel por `CODEX_CONTEXT7_STARTUP_TIMEOUT_SEC`).
- Configura Context7 no `opencode.json`.
- Configura Context7 no arquivo `.cursor/mcp.json`.
- Usa `CONTEXT7_API_KEY` quando a variavel estiver definida.
- Usa variaveis de `.repo.env` durante a execucao dos instaladores em `.repo/*`.
