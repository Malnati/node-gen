<!-- CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md -->
# Implementação 2026-03-02 03:48:51 UTC - Remediação SSPA + Playwright

## Arquivos alterados
- `/root/w/node-gen/.docker/Dockerfile.sspa`
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/playwright.config.ts`
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md`

## Mudanças implementadas
- `Makefile`
  - `playwright-up` atualizado para `up -d --build --no-deps sspa` (rebuild apenas do orquestrador).
  - `playwright-test` agora depende de `playwright-install` e `playwright-up`.
  - execução Playwright com `tee` para log persistido em `playwright-results/playwright-run.log`.
  - removido override `--reporter` para respeitar `playwright.config.ts` e gerar `playwright-results/results.json`.
- `playwright.config.ts`
  - removido `webServer` para evitar concorrência com a orquestração via Makefile.
- `.docker/Dockerfile.sspa`
  - geração de `/usr/share/nginx/html/data/projects.json` a partir de `output/*/postgres/db.reader.postgres.json`.
  - estrutura de projetos/entidades usada pelo dashboard para menu/cards.
- `test/sspa.spec.ts`
  - suíte reduzida e determinística para fluxo real do SSPA:
    - dashboard com menu e cards
    - expansão via menu
    - navegação card -> entidade
    - assertiva de ausência de `404` no orquestrador durante fluxo principal

## Comandos executados
- `git status --short`
- `date -u +%Y%m%d%H%M%S`
- `make playwright-test` (execução inicial; falhou por parse de Dockerfile)
- `make playwright-test` (execução final; passou)
- `curl -sS http://localhost:9000 | sed -n '1,120p'`
- `curl -sS http://localhost:9000/data/projects.json | jq 'keys | length'`

## Resultado resumido
- `make playwright-test`: **PASSOU** (4 passed, 0 failed, 11.1s na execução final).
- endpoint raiz `http://localhost:9000`: **PASSOU** (renderizando HTML do dashboard planejado).
- `projects.json`: **PASSOU** (26 projetos gerados no ambiente verificado).

## Evidências objetivas
- Playwright: `4 passed (11.1s)` na rodada final.
- Logs dos testes gerados em execução: `playwright-results/playwright-run.log`.
- Resultado JSON gerado em execução: `playwright-results/results.json`.

## Definição de pronto (item a item)
- [x] Executar Playwright via Makefile contra o orquestrador SSPA.
- [x] Obter logs dos testes em disco.
- [x] Corrigir problemas encontrados na execução.
- [x] Cobrir dashboard/menu/cards e fluxo principal no Playwright.
- [x] Eliminar regressão observada de página inicial fora do planejado (dashboard agora entregue pela imagem atual do SSPA).
- [x] Registrar plano em disco e manter rastreabilidade com auditoria e implementação.

## Observações
- O alvo `playwright-install` executa `npx playwright install --with-deps chromium`, que imprime avisos de shell local (`.bashrc`) sem impactar o resultado dos testes.

## Referências cruzadas
- Plano: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-plan.md`
- Auditoria: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md`
