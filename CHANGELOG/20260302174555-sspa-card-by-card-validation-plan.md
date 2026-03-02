<!-- CHANGELOG/20260302174555-sspa-card-by-card-validation-plan.md -->
# Plano 2026-03-02 17:45:55 UTC - Validação Card-a-Card do SSPA e Correção de Disponibilidade

## 1. Arquivos existentes relevantes para o escopo
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/.docker/entrypoint.projects.postgres.sh`
- `/root/w/node-gen/playwright-results/sspa-projects.json`
- `/root/w/node-gen/playwright-results/apis-health.log`
- `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-impl.md`

## 2. Arquivos que serão alterados
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/.docker/entrypoint.projects.postgres.sh`
- `/root/w/node-gen/gen/templates/api-main.template.ejs`
- `/root/w/node-gen/gen/templates/api-controller.template.ejs`
- `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-impl.md`

## 3. Requisitos combinados da mudança específica e globais
- Validar de forma objetiva se o SSPA funciona para todos os cards e funcionalidades prováveis de cada card.
- Garantir disponibilidade operacional das APIs distribuídas para possibilitar validação real card-a-card.
- Corrigir problemas encontrados durante a validação, sem expandir escopo além de disponibilidade e fluxo principal de uso.
- Preservar rastreabilidade via artefatos Playwright e logs multi-container.
- Registrar plano, auditoria, implementação, comandos e resultados em `CHANGELOG/`.

## 4. Requisitos atualmente não atendidos que o plano busca resolver
- Apenas parte dos cards está realmente validada quando múltiplas APIs estão indisponíveis.
- Snapshot operacional indica indisponibilidade recorrente de portas `3002-3026`.
- Não há prova de cobertura card-a-card completa na suíte atual.

## 5. Regras combinadas da mudança específica e regras globais do projeto
- Alterar somente o necessário para viabilizar e comprovar a validação card-a-card.
- Não introduzir novas dependências, novos serviços, novos scripts shell, nem refatoração abrangente.
- Manter execução pelo fluxo existente (`make playwright-test`) e preservar padrões de `CHANGELOG`.
- Tratar falhas com correção direta e objetiva, sem alternativas paralelas.

## 6. Regras atualmente não atendidas que motivam os ajustes
- Critério de validação “todos os cards” ainda não comprovado por execução real.
- Disponibilidade parcial da malha de APIs impede conclusão funcional completa por card.

## 7. Plano de auditoria (verificações manuais e automáticas)
- Executar `make playwright-test`.
- Confirmar no `playwright-results/apis-health.log` status de health por portas.
- Confirmar artefato específico de validação card-a-card com resultado por projeto/card.
- Inspecionar logs de container `apis` para erro de bootstrap multiporta.
- Reexecutar `make playwright-test` após correções até obter validação consistente.

## 8. Checklists aplicáveis
- `docs/checklists/` não encontrado no estado atual do repositório.
- Checklist obrigatório aplicado: governança em `CHANGELOG`, validação automatizada, rastreabilidade operacional e correção objetiva de falhas.

## Referências cruzadas
- Auditoria: `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-audit.md`
- Implementação: `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-impl.md`
- Ciclo relacionado: `/root/w/node-gen/CHANGELOG/20260302150253-sspa-test-coverage-traceability-impl.md`
