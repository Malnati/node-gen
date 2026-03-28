<!-- .repo/README.md -->
# Setup Scripts

Este diretorio contem scripts de bootstrap para ferramentas auxiliares de agentes.

## Arquivos
- `playwright.sh`: instala `@playwright/cli@latest` e executa `playwright-cli install --skills` para os alvos selecionados.
- `context7.sh`: configura o MCP `context7` para `codex`, `opencode` e `cursor`.
- `figma.sh`: configura o MCP remoto `figma` para `codex`, `opencode` e `cursor`.
- `microsoft-learn.sh`: configura o MCP remoto `microsoft-learn` para `codex`, `opencode` e `cursor`.
- `microsoft-sentinel-data-exploration.sh`: configura o MCP remoto `microsoft-sentinel-data-exploration` para `codex`, `opencode` e `cursor`.
- `sonarq.sh`: configura o MCP local `sonarqube` para `codex`, `opencode` e `cursor` via `docker run`.
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
- `bash .repo/figma.sh` ou `bash .repo/figma.sh all`
- `bash .repo/figma.sh codex`
- `bash .repo/figma.sh opencode`
- `bash .repo/figma.sh cursor`
- `bash .repo/sonarq.sh` ou `bash .repo/sonarq.sh all`
- `bash .repo/sonarq.sh codex`
- `bash .repo/sonarq.sh opencode`
- `bash .repo/sonarq.sh cursor`
- `bash .repo/microsoft-learn.sh` ou `bash .repo/microsoft-learn.sh all`
- `bash .repo/microsoft-learn.sh codex`
- `bash .repo/microsoft-learn.sh opencode`
- `bash .repo/microsoft-learn.sh cursor`
- `bash .repo/microsoft-sentinel-data-exploration.sh` ou `bash .repo/microsoft-sentinel-data-exploration.sh all`
- `bash .repo/microsoft-sentinel-data-exploration.sh codex`
- `bash .repo/microsoft-sentinel-data-exploration.sh opencode`
- `bash .repo/microsoft-sentinel-data-exploration.sh cursor`

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
- Configura Figma MCP no Codex com `codex mcp add "figma" --url "https://mcp.figma.com/mcp"`.
- Configura Figma MCP no `opencode.json`.
- Configura Figma MCP no arquivo `.cursor/mcp.json`.
- Configura SonarQube MCP no Codex com `codex mcp add "sonarqube"` usando `docker run --init --pull=always -i --rm ... mcp/sonarqube`.
- Configura SonarQube MCP no `opencode.json` como servidor local (`type: "local"`).
- Configura SonarQube MCP no arquivo `.cursor/mcp.json` com `command: "docker"` e `args`.
- Suporta modo Cloud (com `SONARQUBE_ORG`) e modo Server (com `SONARQUBE_URL` sem `SONARQUBE_ORG`).
- Usa placeholders seguros para `SONARQUBE_TOKEN`, `SONARQUBE_ORG` e `SONARQUBE_URL` quando variaveis nao estiverem definidas.
- Configura Microsoft Learn MCP no Codex com `codex mcp add "microsoft-learn" --url "https://learn.microsoft.com/api/mcp"`.
- Configura Microsoft Learn MCP no `opencode.json`.
- Configura Microsoft Learn MCP no arquivo `.cursor/mcp.json`.
- Configura Microsoft Sentinel Data Exploration MCP no Codex com `codex mcp add "microsoft-sentinel-data-exploration" --url "https://sentinel.microsoft.com/mcp/data-exploration"`.
- Configura Microsoft Sentinel Data Exploration MCP no `opencode.json`.
- Configura Microsoft Sentinel Data Exploration MCP no arquivo `.cursor/mcp.json`.
- Usa variaveis de `.repo.env` durante a execucao dos instaladores em `.repo/*`.
