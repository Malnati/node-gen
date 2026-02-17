<!-- docs/issues/plan-issues-sub-2.md -->

# [SUB] 2 Revisar geradores intermediários de API e composição modular

## Contexto
- Origem no plano: ordem de revisão itens 5 a 9 (`controller-generator.ts`, `module-generator.ts`, `main-generator.ts`, `app-module-generator.ts`, `readme-generator.ts`).
- Motivação: validar camada intermediária que depende de convenções geradas na base e prepara a composição funcional.

## Objetivo
Garantir consistência entre rotas, módulos, bootstrap e documentação gerada, preservando compilação e previsibilidade estrutural.

## Escopo
### Entra
- Revisão dos geradores:
  - `src/controller-generator.ts`
  - `src/module-generator.ts`
  - `src/main-generator.ts`
  - `src/app-module-generator.ts`
  - `src/readme-generator.ts`
- Verificação de decorators, imports, vinculação entre módulos e aderência de instruções documentadas no README gerado.

### Não entra
- Revisão dos geradores de persistência/domínio (`datasource`, `dto`, `service`, `typeorm-entity`).
- Revisão transversal de orquestração completa.

## Tarefas técnicas
- [ ] Auditar rotas, injeção de dependência e assinaturas de métodos nos controllers.
- [ ] Validar coesão de módulos por recurso e exports/imports.
- [ ] Verificar bootstrap e ausência de hardcode inválido no `main` gerado.
- [ ] Confirmar agregação de módulos sem duplicações/omissões no `app.module`.
- [ ] Validar coerência entre README gerado, scripts e estrutura real de saída.

## Critérios de aceite
- [ ] Cinco geradores intermediários revisados com checklist completo.
- [ ] Compatibilidade estrutural confirmada entre controllers/modules/bootstrap.
- [ ] Evidências de compilação e consistência de imports coletadas.
- [ ] Rastreabilidade total dos itens 5–9 do plano.

## Riscos e dependências
- Dependência: conclusão da `[SUB] 1`.
- Risco: inconsistências de imports/paths podem mascarar falhas de persistência que só emergem na SUB seguinte.

## Evidências esperadas
- Registro de revisão por gerador 5–9 com status final.
- Comandos de validação de build/start aplicáveis ao output.
- Lista de inconformidades com impacto no fluxo de geração.

## Definição de pronto
- [ ] Itens 5–9 do plano cobertos integralmente.
- [ ] Achados classificados por severidade de impacto.
- [ ] Evidências objetivas anexadas.
- [ ] Dependências para `[SUB] 3` liberadas.
