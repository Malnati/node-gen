<!-- CHANGELOG/20260302190041-sspa-skip-auth-regression-fix.md -->
# Implementação 2026-03-02 19:00:41 UTC - Correção de Regressão de Auth no SSPA

## Referências cruzadas (10 planos mais recentes revisados)
- `CHANGELOG/20260302174555-sspa-card-by-card-validation-plan.md`
- `CHANGELOG/20260302150253-sspa-test-coverage-traceability-plan.md`
- `CHANGELOG/20260302110445-sspa-disable-auth-plan.md`
- `CHANGELOG/20260302094414-sspa-comprehensive-playwright-plan.md`
- `CHANGELOG/20260302034851-sspa-playwright-remediation-plan.md`
- `CHANGELOG/20260302030713-playwright-sspa-plan.md`
- `CHANGELOG/20260302030248-sspa-dashboard-plan.md`
- `CHANGELOG/20260302023157-sspa-orchestrator-plan.md`
- `CHANGELOG/20260302013014-e2e-parallel-plan.md`
- `CHANGELOG/20260302020443-plan-retire-original-templates.md`

## Arquivos alterados
- `.docker/Dockerfile.sspa`
- `.docker/docker-compose.projects.postgres.yml`
- `AGENTS.md`
- `opencode.json`

## Regras e requisitos atendidos
- Correção funcional direta sem expansão de escopo: frontend do SSPA passa a respeitar flag de bypass.
- Cadeia de configuração do orquestrador atualizada: `SSPA_SKIP_AUTH` exposta no serviço `sspa`.
- Governança preventiva registrada: regra explícita adicionada em `AGENTS.md` e em `opencode.json` para evitar sobreescrita.
- Rastreabilidade registrada em novo arquivo de changelog do ciclo.

## Comandos executados
- `rg -n "Autenticacao necessaria|Defina SSPA_AUTH_TOKEN|SSPA_AUTH_TOKEN" gen test .docker Makefile opencode.json AGENTS.md .github -S`
- `sed -n '1,280p' .docker/Dockerfile.sspa`
- `sed -n '1,260p' .docker/docker-compose.projects.postgres.yml`
- `sed -n '1,260p' .docker/entrypoint.projects.postgres.sh`
- `ls -1t CHANGELOG/*plan*.md | head -n 10`
- `node -e "JSON.parse(require('fs').readFileSync('opencode.json','utf8')); console.log('opencode.json OK')"`
- `git diff -- .docker/Dockerfile.sspa .docker/docker-compose.projects.postgres.yml AGENTS.md opencode.json`

## Resultado resumido
- **PASSOU (validação estática/configuração):**
  - SSPA não exige `SSPA_AUTH_TOKEN` quando `SSPA_SKIP_AUTH=true`.
  - Compose do `sspa` agora expõe `SSPA_SKIP_AUTH` com default ativo.
  - Políticas preventivas registradas em `AGENTS.md` e `opencode.json`.
- **Não executado neste ciclo:** `make projects-up`/Playwright end-to-end.

## Definição de pronto
- [x] Flag de bypass JWT aplicada para o cenário do orquestrador SSPA.
- [x] Regressão de exigência indevida de token tratada no frontend do SSPA.
- [x] Regra documentada em `AGENTS.md`.
- [x] Regra documentada em `opencode.json`.
- [x] Changelog do ciclo criado com rastreabilidade.
