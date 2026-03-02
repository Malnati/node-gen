<!-- CHANGELOG/20260302193539-sspa-all-cards-functional-plan.md -->
# 2026-03-02 19:35:39 UTC - Plano SSPA all cards functional

## 1. Arquivos existentes relevantes para o escopo
- `Makefile`
- `.docker/Dockerfile.sspa`
- `.docker/docker-compose.projects.postgres.yml`
- `test/sspa.spec.ts`
- `playwright-results/card-validation.json`
- `playwright-results/http-matrix.json`
- `playwright-results/sspa-projects.json`
- `CHANGELOG/20260302174555-sspa-card-by-card-validation-plan.md`
- `CHANGELOG/20260302174555-sspa-card-by-card-validation-impl.md`
- `CHANGELOG/20260302174555-sspa-card-by-card-validation-audit.md`

## 2. Arquivos que serão alterados
- `.docker/Dockerfile.sspa`
- `test/sspa.spec.ts`
- `CHANGELOG/20260302193539-sspa-all-cards-functional-plan.md`
- `CHANGELOG/20260302193539-sspa-all-cards-functional-impl.md`
- `CHANGELOG/20260302193539-sspa-all-cards-functional-audit.md`

## 3. Lista combinada de requisitos da mudança específica e globais do projeto
- Reproduzir falhas e validar via `Makefile`, nunca por execução manual isolada.
- Cobrir todos os cards e todas as funcionalidades (entidades) no teste automatizado.
- Corrigir defeitos encontrados sem criar novos arquivos fora de `CHANGELOG/`.
- Garantir acessibilidade funcional dos endpoints listados no dashboard para todos os cards.
- Registrar governança com rastreabilidade de comandos, evidências e resultados.

## 4. Requisitos atualmente não atendidos que o plano busca resolver
- `projects.json` do SSPA está mapeando endpoints com `_` em entidades cujo backend expõe rotas em `-`, causando `404`.
- Suite Playwright atual aceita `404` em endpoints principais e mascara regressões funcionais.
- Validação card-a-card atual só valida entidade amostral por projeto, não todas as funcionalidades.
- Matriz HTTP atual só valida subconjunto de entidades por projeto.

## 5. Lista combinada de regras da mudança específica e regras globais do projeto
- Alteração cirúrgica, sem refactor abrangente e sem dependências novas.
- Executar diagnóstico e validação final somente por alvos do `Makefile`.
- Não excluir arquivos existentes.
- Registrar evidências objetivas no ciclo de governança em `CHANGELOG/`.
- Manter `E2E_SKIP_JWT=true` e `SSPA_SKIP_AUTH=true` no fluxo de teste.

## 6. Regras atualmente não atendidas que motivam os ajustes
- Cobertura funcional integral de cards/funcionalidades não está sendo exercida.
- Critério de aceitação está frouxo ao permitir `404` em endpoints de listagem.
- Resultado de teste atual não é confiável para detectar falhas reais de acessibilidade funcional.

## 7. Plano de auditoria (verificações manuais e automáticas)
- Executar `make playwright-test` antes da correção para evidenciar baseline.
- Confirmar em `playwright-results/card-validation.json` e `playwright-results/http-matrix.json` a presença de `404` mascarados.
- Aplicar correção do mapeamento de endpoint no SSPA e endurecer critérios de teste.
- Reexecutar `make playwright-test`.
- Confirmar ausência de `404` em endpoints de listagem nas matrizes de saída.
- Registrar comandos, arquivos e status final em `*-impl.md` e `*-audit.md`.

## 8. Checklists aplicáveis (`docs/checklists/`)
- Não há arquivos em `docs/checklists/` no estado atual do repositório.
- Checklist obrigatório aplicado neste ciclo: validação por `Makefile`, rastreabilidade completa em `CHANGELOG/`, e confirmação de cobertura integral de cards/funcionalidades.
