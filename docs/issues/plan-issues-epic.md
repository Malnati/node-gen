<!-- docs/issues/plan-issues-epic.md -->

# [EPIC] Revisão completa dos geradores TypeScript e validação fim a fim

## Contexto
- Origem: `docs/template-review-plan.md`.
- Motivação: transformar o plano de revisão em execução rastreável por artefatos Markdown e/ou tracker externo, cobrindo os 13 geradores TypeScript e as análises transversais obrigatórias.

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
- [ ] Registrar e vincular as SUBs `[SUB] 1` a `[SUB] 4` no repositório (e no tracker externo quando aplicável).
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

## Vinculação das SUBs (registro no repositório)
| SUB | Artefato | Descrição |
|-----|----------|-----------|
| [SUB] 1 | [plan-issues-sub-1.md](plan-issues-sub-1.md) | Revisar geradores base (env, package-json, diagram, interface) |
| [SUB] 2 | [plan-issues-sub-2.md](plan-issues-sub-2.md) | Revisar geradores intermediários (controller a readme) |
| [SUB] 3 | [plan-issues-sub-3.md](plan-issues-sub-3.md) | Revisar geradores de domínio e persistência TypeORM |
| [SUB] 4 | [plan-issues-sub-4.md](plan-issues-sub-4.md) | Análises transversais, matriz de cenários e fechamento |

Registro de execução por SUB: [execution-sub-1.md](execution-sub-1.md), [execution-sub-2.md](execution-sub-2.md), [execution-sub-3.md](execution-sub-3.md), [execution-sub-4.md](execution-sub-4.md). Consolidação: [plan-issues-execution.md](plan-issues-execution.md).

## Definição de pronto
- [ ] SUBs registradas e vinculadas ao EPIC.
- [ ] Execução concluída na sequência técnica definida.
- [ ] Cobertura integral do plano confirmada.
- [ ] Evidências consolidadas e auditáveis.
- [ ] Critério de pronto do plano atendido integralmente.
