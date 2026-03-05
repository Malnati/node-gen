<!-- CHANGELOG/20260305132918-demo-pg-e2e-ui-db-parity.md -->
# 2026-03-05 13:29:18 UTC - Plano implementado: demo-pg + discovery + Playwright UI x DB

## Arquivos alterados
- `Makefile`
- `test/sspa.spec.ts`
- `gen/static-mfe-app/src/spa.ts`
- `CHANGELOG/20260305132918-demo-pg-e2e-ui-db-parity.md`

## Regras e requisitos atendidos
- Execução operacional preservada via `Makefile` (alvos novos para fluxo completo e validação de discovery).
- Publicação dinâmica validada via `service-discovery` (`/api/discovery/applications`) com conferência de rotas por projeto.
- Playwright estendido para validação UI x Postgres sem uso de registros estáticos.
- Comparação implementada para o recorte exibido na UI (`top 20` por entidade, configurável por `PLAYWRIGHT_DB_LIMIT`).
- Evidências de execução Playwright incluem novos artefatos `ui-db-validation`.
- Fluxo demo isolado do fluxo legado `projects-up`, usando alvo dedicado `playwright-demo-test`.

## Comandos executados
- `git status --short`
- `sed -n '1,120p' Makefile`
- `sed -n '1,220p' test/sspa.spec.ts`
- `sed -n '220,520p' test/sspa.spec.ts`
- `sed -n '520,760p' Makefile`
- `date -u +%Y%m%d%H%M%S`
- `make -n demo-pg-e2e DEMO_PROJECTS="addresses contacts orders"`
- `make -n demo-pg-verify-discovery DEMO_PROJECTS="addresses contacts orders"`
- `make -n playwright-demo-test`
- `git diff --check`
- `make demo-pg-e2e DEMO_PROJECTS="addresses contacts orders" PLAYWRIGHT_DB_ASSERT=true PLAYWRIGHT_DB_LIMIT=20`
- `make demo-pg-apis-up DEMO_PROJECTS="addresses contacts orders"`
- `make projects-logs`
- `docker exec nodegen-apis sh -lc 'tail -n 80 /tmp/addresses.log; echo "---"; tail -n 80 /tmp/contacts.log; echo "---"; tail -n 80 /tmp/orders.log'`
- `make demo-pg-down`

## Resultado resumido
- Implementação de código: **PASSOU**.
- Execução fim-a-fim `make demo-pg-e2e`: **FALHOU**.
  - Falha inicial corrigida no ciclo: build de MFE com erro `Could not resolve entry module "src/spa.ts"`; correção aplicada com novo arquivo estático `gen/static-mfe-app/src/spa.ts`.
  - Falha atual bloqueadora: API `addresses` não fica saudável em `3002` por erro de datasource `The server does not support SSL connections` (observado em `/tmp/addresses.log` no container `nodegen-apis`).
- Teste Playwright runtime: **NÃO EXECUTADO** devido bloqueio anterior no healthcheck das APIs de escopo.

## Definição de pronto (item a item)
- [x] Criar fluxo Makefile para gerar + publicar + validar.
- [x] Garantir validação de discovery dinâmico antes do Playwright.
- [x] Adicionar validação Playwright com comparação Browser x Postgres.
- [x] Persistir artefatos de validação UI x DB em `playwright-results/`.
- [x] Manter escopo inicial com foco em `addresses contacts orders` via `DEMO_PROJECTS`.
- [ ] Executar e anexar evidência de `make demo-pg-e2e DEMO_PROJECTS="addresses contacts orders"` com resultado 100% verde (pendente por erro SSL no `addresses`).

## Pendências relevantes
- Ajustar configuração de conexão Postgres do projeto `addresses` para ambiente sem SSL no fluxo demo (erro atual: `The server does not support SSL connections`).
- Após correção do item acima, rodar `make demo-pg-e2e DEMO_PROJECTS="addresses contacts orders"` para consolidar evidências runtime + Playwright.
