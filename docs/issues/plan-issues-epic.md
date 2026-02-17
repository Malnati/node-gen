<!-- docs/issues/plan-issues-epic.md -->

# [EPIC] Revisão completa dos geradores TypeScript e validação fim a fim

## Contexto
- Origem: `docs/template-review-plan.md`.
- Motivação: transformar o plano de revisão em execução rastreável por issues, cobrindo os 13 geradores TypeScript e as análises transversais obrigatórias.

## Objetivo
Executar a revisão técnica completa do pipeline de geração TypeScript com trilhas sequenciais, garantindo classificação final por gerador (`Aprovado`, `Aprovado com ressalvas`, `Reprovado`) e validação fim a fim do output.

## Escopo
### Entra
- Coordenação da execução das SUBs na ordem de dependência.
- Consolidação dos achados por gerador e por análise transversal.
- Consolidação do critério de pronto do plano.

### Não entra
- Implementação de correções nos geradores.
- Expansão de escopo para componentes não citados no plano.

## Tarefas técnicas
- [ ] Abrir e vincular as SUBs `[SUB] 1` a `[SUB] 4`.
- [ ] Executar SUBs na ordem definida (base → intermediários → domínio/composição → orquestração e E2E).
- [ ] Consolidar status por gerador conforme critério de pronto do plano.
- [ ] Consolidar inconformidades com causa raiz, impacto, proposta de correção e evidência.
- [ ] Consolidar decisão final de revisão do stack completo para cenários críticos.

## Critérios de aceite
- [ ] 100% dos itens acionáveis do plano mapeados nas SUBs sem duplicidade.
- [ ] Ordem de dependência técnica respeitada durante a execução.
- [ ] Todos os 13 geradores revisados e classificados.
- [ ] Análises transversais obrigatórias concluídas com evidências objetivas.
- [ ] Resultado fim a fim documentado para a matriz mínima de cenários.

## Riscos e dependências
- Dependências:
  - `[SUB] 1` é pré-requisito de `[SUB] 2`.
  - `[SUB] 2` é pré-requisito parcial de `[SUB] 3`.
  - `[SUB] 3` é pré-requisito de `[SUB] 4`.
- Riscos:
  - Efeito cascata de nomenclatura/contratos impactando etapas posteriores.
  - Falta de evidência padronizada comprometer rastreabilidade final.

## Evidências esperadas
- Arquivos de registro de execução por SUB com checklist completo.
- Comandos executados com resultado objetivo (sucesso/falha).
- Consolidação final com status dos 13 geradores e das análises transversais.

## Definição de pronto
- [ ] SUBs abertas e vinculadas ao EPIC.
- [ ] Execução concluída na sequência técnica definida.
- [ ] Cobertura integral do plano confirmada.
- [ ] Evidências consolidadas e auditáveis.
- [ ] Critério de pronto do plano atendido integralmente.
