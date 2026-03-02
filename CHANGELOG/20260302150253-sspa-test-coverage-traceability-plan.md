<!-- CHANGELOG/20260302150253-sspa-test-coverage-traceability-plan.md -->
# Plano 2026-03-02 15:02:53 UTC - Cobertura SSPA, Segurança e Rastreabilidade

## 1. Arquivos existentes relevantes para o escopo
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/playwright.config.ts`
- `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml`
- `/root/w/node-gen/.docker/Dockerfile.sspa`
- `/root/w/node-gen/CHANGELOG/20260302094414-sspa-comprehensive-playwright-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302094414-sspa-comprehensive-playwright-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302094414-sspa-comprehensive-playwright-impl.md`

## 2. Arquivos que serão alterados
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/gen/templates/api-controller.template.ejs`
- `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-impl.md`

## 3. Requisitos combinados da mudança específica e globais
- Ampliar cobertura dos testes do SSPA para cenários prováveis de acesso, autenticação, autorização, inclusão, alteração, exclusão e segurança, com verificação de códigos HTTP.
- Persistir resultados de matriz HTTP mesmo em caso de falha, para permitir análise forense do ciclo.
- Registrar evidências de rastro entre camadas de orquestração/micro-frontends (`sspa`), APIs (`apis`) e banco (`postgres-shared`).
- Manter execução por Playwright e Makefile existentes, sem adicionar dependências nem novos serviços.
- Registrar plano, auditoria e implementação em `CHANGELOG/` com referências cruzadas.

## 4. Requisitos atualmente não atendidos que o plano busca resolver
- Falha antecipada na suíte impede materialização consistente da matriz HTTP e dos pontos de anomalia.
- Validação de CRUD provável está concentrada em uma única entidade por projeto, reduzindo abrangência de risco.
- Evidências não incluem snapshot explícito de `projects.json` e health checks por portas para correlação rápida com logs de containers.
- Endpoint de escrita `accounts/account` retorna `500` em cenários prováveis de acesso sem credencial/token inválido, inviabilizando classificação HTTP adequada para erro de entrada.

## 5. Regras combinadas da mudança específica e regras globais do projeto
- Escopo mínimo e objetivo, alterando apenas arquivos estritamente necessários.
- Sem refatoração estrutural ou alteração arquitetural fora do tema de testes/rastreabilidade.
- Sem novas dependências, sem scripts shell adicionais, mantendo targets existentes do Makefile.
- Preservar convenções de comentários de caminho e governança em `CHANGELOG/`.

## 6. Regras atualmente não atendidas que motivam os ajustes
- Cobertura insuficiente para o risco operacional de orquestração de múltiplos projetos distribuídos.
- Rastro inter-container parcial quando há quebra prematura de asserções em testes críticos.

## 7. Plano de auditoria (verificações manuais e automáticas)
- Executar `make playwright-clean`.
- Executar `make playwright-test`.
- Verificar artefatos obrigatórios e de correlação:
  - `playwright-results/playwright-run.log`
  - `playwright-results/results.json`
  - `playwright-results/http-matrix.json`
  - `playwright-results/http-matrix-anomalies.json`
  - `playwright-results/containers-sspa.log`
  - `playwright-results/containers-apis.log`
  - `playwright-results/containers-postgres.log`
  - `playwright-results/containers-ps.log`
  - `playwright-results/sspa-projects.json`
  - `playwright-results/apis-health.log`
- Confirmar que falhas de segurança/autorização retornam códigos esperados (sem aceitar `5xx` como resultado válido de regra de acesso).

## 8. Checklists aplicáveis
- `docs/checklists/` não encontrado no estado atual do repositório.
- Checklist obrigatório aplicado neste ciclo: governança em `CHANGELOG`, execução automatizada Playwright, rastreabilidade multi-container e validação de segurança para o orquestrador.

## Referências cruzadas
- Auditoria: `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-audit.md`
- Implementação: `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-impl.md`
- Plano anterior relacionado: `/root/w/node-gen/CHANGELOG/20260302094414-sspa-comprehensive-playwright-plan.md`
