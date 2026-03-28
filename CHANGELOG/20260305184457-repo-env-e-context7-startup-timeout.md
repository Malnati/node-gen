<!-- CHANGELOG/20260305184457-repo-env-e-context7-startup-timeout.md -->
# 2026-03-05 18:44:57 UTC - .repo.env + loader + timeout MCP context7

## Arquivos modificados
- `.repo.env`
- `.repo/env.sh`
- `.repo/playwright.sh`
- `.repo/context7.sh`
- `.repo/README.md`
- `.gitignore`
- `CHANGELOG/20260305184457-repo-env-e-context7-startup-timeout.md`

## Referencias cruzadas
- Politicas aplicadas: `AGENTS.md`, `.github/copilot-instructions.md`, `opencode.json`
- Ciclo anterior relacionado: `CHANGELOG/20260305154454-context7-mcp-setup-codex-opencode-cursor.md`

## Requisitos atendidos
- Criado arquivo `.repo.env` para centralizar chaves/configuracoes dos instaladores.
- Criado `.repo/env.sh` para carregar/exportar variaveis do `.repo.env`.
- Integrado carregamento do launcher de ambiente nos scripts `.repo/playwright.sh` e `.repo/context7.sh`.
- Ajustada instalacao do Context7 para configurar `startup_timeout_sec` em `~/.codex/config.toml` na secao `[mcp_servers.context7]`.
- Atualizada documentacao em `.repo/README.md`.

## Comandos executados
- `ls -la .repo`
- `sed -n '1,260p' .repo/playwright.sh`
- `sed -n '1,320p' .repo/context7.sh`
- `sed -n '1,260p' .repo/README.md`
- `sed -n '1,120p' .gitignore`
- `date -u +%Y%m%d%H%M%S`
- `bash -n .repo/env.sh`
- `bash -n .repo/playwright.sh`
- `bash -n .repo/context7.sh`
- `CONTEXT7_API_KEY='***' CODEX_CONTEXT7_STARTUP_TIMEOUT_SEC=60 bash .repo/context7.sh codex`

## Resultado resumido
- `PASSOU`: launcher de variaveis em `.repo/env.sh` e fonte `.repo.env` adicionados.
- `PASSOU`: instaladores `.repo/*` agora usam as variaveis carregadas automaticamente.
- `PASSOU`: setup do Context7 passou a configurar `startup_timeout_sec` do MCP no Codex.
- `PASSOU`: aplicacao executada no ambiente com `startup_timeout_sec = 60` para `mcp_servers.context7`.

## Definicao de pronto (item a item)
- [x] Existe `.repo.env` para variaveis de chave.
- [x] Existe `.repo/env.sh` para ler e exportar variaveis.
- [x] Scripts em `.repo/*` usam o launcher durante setup/instalacao.
- [x] Instalacao do Context7 ajusta timeout de startup no Codex.
- [x] Escopo limitado ao solicitado.

## Pendencias relevantes
- Preencher valores reais em `.repo.env` no ambiente de execucao (sem commitar segredos).
