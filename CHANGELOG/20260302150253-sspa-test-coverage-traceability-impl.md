<!-- CHANGELOG/20260302150253-sspa-test-coverage-traceability-impl.md -->
# Implementação 2026-03-02 15:02:53 UTC - Cobertura SSPA, Segurança e Rastreabilidade

## Arquivos alterados
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/gen/templates/api-controller.template.ejs`
- `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-impl.md`

## Mudanças implementadas
- Novo ciclo de governança registrado em `CHANGELOG` com plano, auditoria e implementação.
- `test/sspa.spec.ts` ampliado para cobertura mais abrangente em matriz HTTP:
  - seleção de amostra provável de múltiplas entidades por projeto (`ENTITY_SAMPLE_SIZE=3`, com priorização para não-eventos);
  - cobertura de cenários adicionais de autenticação/autorização (`get_malformed_token`, `post_invalid_token`);
  - persistência obrigatória de artefatos de matriz em bloco `finally`, mesmo quando houver falha de asserção;
  - geração de `playwright-results/http-matrix-anomalies.json` para registrar respostas `5xx` por projeto/entidade/operação;
  - manutenção de falha explícita quando existir `5xx` na matriz, preservando segurança e diagnóstico.
- `Makefile` (`playwright-test`) atualizado para reforçar rastreabilidade entre camadas:
  - snapshot de `projects.json` do SSPA em `playwright-results/sspa-projects.json`;
  - snapshot de health checks (`/health`) para portas `3001-3026` em `playwright-results/apis-health.log`;
  - coleta de logs de containers com `--timestamps` para correlação temporal entre `sspa`, `apis` e `postgres-shared`;
  - inclusão dos novos artefatos no resumo final do target.
- `gen/templates/api-controller.template.ejs` corrigido para classificação HTTP de erros esperados de escrita em controladores gerados:
  - duplicidade continua tratada e agora responde `409 Conflict`;
  - erros previsíveis de payload/constraint (`23502`, `22P02`, `23514`, `23503`) passam a responder `400 Bad Request`;
  - `500` permanece apenas para falhas não mapeadas.

## Comandos executados
- `date -u +%Y%m%d%H%M%S`
- `git status --short`
- `ls -la CHANGELOG/20260302150253-sspa-test-coverage-traceability-*.md`
- `sed -n '1,260p' CHANGELOG/20260302150253-sspa-test-coverage-traceability-plan.md`
- `sed -n '1,220p' CHANGELOG/20260302150253-sspa-test-coverage-traceability-audit.md`
- `make playwright-test` (2 execuções)
- `npm run build` (em `/root/w/node-gen/output/accounts/postgres`, para validar hotfix local antes de persistir em template)
- `make playwright-test` (execução final após correção funcional)
- `ls -la playwright-results`
- `sed -n '1,200p' playwright-results/http-matrix-anomalies.json`
- `sed -n '1,120p' playwright-results/apis-health.log`

## Resultado resumido
- Implementação iniciada e aplicada em código e Makefile: **PASSOU**.
- Execução Playwright inicial (`make playwright-test`): **FALHOU** por motivo objetivo de comportamento HTTP inesperado:
  - `POST` sem auth em `accounts/account` retornou `500`.
  - `POST` com token inválido em `accounts/account` retornou `500`.
- Execução Playwright final (`make playwright-test` após ajuste no controller): **PASSOU** (`4 passed`).
- Cobertura e rastreabilidade executaram com geração dos artefatos previstos:
  - `playwright-results/http-matrix.json`
  - `playwright-results/http-matrix-anomalies.json`
  - `playwright-results/sspa-projects.json`
  - `playwright-results/apis-health.log`
  - `playwright-results/containers-sspa.log`
  - `playwright-results/containers-apis.log`
  - `playwright-results/containers-postgres.log`
  - `playwright-results/containers-ps.log`
  - `playwright-results/playwright-run.log`
  - `playwright-results/results.json`
- Evidência de anomalias após correção: `playwright-results/http-matrix-anomalies.json` contém `[]`.

## Definição de pronto (parcial desta etapa)
- [x] Novo plano registrado em disco.
- [x] Nova auditoria irmã registrada em disco.
- [x] Implementação iniciada em arquivos funcionais de teste/rastreabilidade.
- [x] Execução de auditoria (`make playwright-test`) realizada com consolidação do resultado final no mesmo changelog.
- [x] Correção funcional do backend para eliminar respostas `500` nos cenários de auth/authorization em `POST /account`.

## Referências cruzadas
- Plano: `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-plan.md`
- Auditoria: `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-audit.md`
