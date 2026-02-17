<!-- docs/issues/plan-issues-sub-3.md -->

# [SUB] 3 Revisar geradores de domínio e persistência TypeORM

## Contexto
- Origem no plano: ordem de revisão itens 10 a 13 (`datasource-generator.ts`, `dto-generator.ts`, `service-generator.ts`, `typeorm-entity-generator.ts`).
- Motivação: validar camada crítica de runtime persistente e contratos de domínio.

## Objetivo
Concluir revisão técnica da geração de persistência e domínio, assegurando consistência de entidades, DTOs, serviços e datasource para bancos suportados.

## Escopo
### Entra
- Revisão dos geradores:
  - `src/datasource-generator.ts`
  - `src/dto-generator.ts`
  - `src/service-generator.ts`
  - `src/typeorm-entity-generator.ts`
- Verificação de mapeamento SQL→TypeScript/TypeORM, relacionamentos e contratos Query/Persist.

### Não entra
- Correção de inconformidades no código-fonte dos geradores.
- Validação transversal final da orquestração completa e matriz de cenários consolidada.

## Tarefas técnicas
- [ ] Validar imports/registro de entidades e inicialização do datasource por banco suportado.
- [ ] Auditar validações `class-validator` e contratos DTO (incluindo nullable e relacionamentos).
- [ ] Revisar serviços CRUD, tratamento de relacionamento, erros e serialização.
- [ ] Auditar entidades TypeORM: tipos, PK/FK, cardinalidades, decorators e compilação.
- [ ] Registrar classificação final por gerador com evidências de revalidação.

## Critérios de aceite
- [ ] Quatro geradores de persistência/domínio revisados integralmente.
- [ ] Inconformidades mapeadas com causa raiz e impacto operacional.
- [ ] Evidências de compilação do output persistente registradas.
- [ ] Rastreabilidade total dos itens 10–13 do plano.

## Riscos e dependências
- Dependência: conclusão de `[SUB] 2` (e baseline de `[SUB] 1`).
- Risco: falhas estruturais de entity/datasource bloquearem validação fim a fim na etapa final.

## Evidências esperadas
- Matriz de revisão dos geradores 10–13 com status final.
- Evidências de validação por cenário de mapeamento e relacionamento.
- Lista consolidada de pendências para tratamento posterior.

## Definição de pronto
- [ ] Itens 10–13 do plano cobertos integralmente.
- [ ] Status por gerador publicado.
- [ ] Evidências auditáveis registradas.
- [ ] Dependências para `[SUB] 4` liberadas.
