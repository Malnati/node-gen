<!-- CHANGELOG/20260227120000-api-generator-scope-plan.md -->
# Plano: Novo Escopo de Geração API

## Data/Hora: 2026-02-27T12:00:00Z

## Escopo do Plano
Adicionar novo escopo de geração de API com estrutura `<output>/<project>/<database>/api/src/modules/<entity>` utilizando templates `api-*`.

## Arquivos Existentes Relevantes
- `gen/templates/api-*.ejs` (12 templates)
- `gen/src/main.ts`
- `gen/src/interfaces.ts`
- `gen/static/` (estrutura base)
- `test/e2e-generator/run.js`, `e2e.js`, `e2e.json`

## Arquivos a Criar
1. `gen/static-api/` - diretório completo com arquivos estáticos
2. `gen/src/api-entity-generator.ts`
3. `gen/src/api-service-generator.ts`
4. `gen/src/api-controller-generator.ts`
5. `gen/src/api-dto-generator.ts`
6. `gen/src/api-module-generator.ts`
7. `gen/src/api-app-module-generator.ts`
8. `gen/src/api-main-generator.ts`
9. `gen/src/api-datasource-generator.ts`
10. `gen/src/api-interface-generator.ts`
11. `gen/src/api-readme-generator.ts`
12. `gen/src/api-relation-generator.ts`
13. `gen/src/api-column-generator.ts`

## Arquivos a Modificar
1. `gen/src/main.ts` - adicionar imports e cases para componentes api-*
2. `gen/src/interfaces.ts` - adicionar tipos de componentes api-*

## Requisitos da Mudada
- Novo escopo deve gerar em `<output>/<project>/<database>/api/`
- Templates API utilizam caminhos: `../config/`, `../middleware/`, `src/`
- Estrutura: `gen/static-api/src/{middleware,modules,validators}/`
- Geradores devem ser instanciados via main.ts como os atuais

## Requisitos Não Atendidos
- Falta estrutura static-api para API
- Falta geradores com prefixo api-
- main.ts não suporta componentes api-*
- interfaces.ts não tem tipos para api-*

## Regras do Projeto
- Cada template tem seu próprio gerador com prefixo api-
- Arquivos estáticos ficam em gen/static-api/
- main.ts orchestra todos os geradores
- Output: `<output>/<project>/<database>/api/src/modules/<entity>`

## Plano de Auditoria
1. Verificar se todos os 12 geradores foram criados
2. Verificar se main.ts instancia os novos geradores
3. Testar geração com projeto E2E (accounts ou products)
4. Validar que arquivos são gerados na estrutura correta
5. Verificar se código compila e estrutura é válida
