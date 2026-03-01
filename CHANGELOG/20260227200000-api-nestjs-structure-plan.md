<!-- CHANGELOG/20260227200000-api-nestjs-structure-plan.md -->
# Plano: Correção da Estrutura API para Padrão NestJS

## Data/Hora: 2026-02-27T20:00:00Z

## Escopo do Plano
Corrigir a estrutura de geração API para seguir o padrão NestJS conforme especificado.

## Arquivos Existentes Relevantes
- `gen/src/api-*.generator.ts` (10 geradores)
- `gen/static-api/src/` (arquivos estáticos)
- `gen/templates/api-*.ejs` (templates)
- `test/e2e-generator/e2e.json` (configuração E2E)

## Arquivos a Criar
1. `gen/static-api/nest-cli.json` - Configuração CLI do NestJS
2. `gen/static-api/src/app.controller.ts` - Controller principal
3. `gen/static-api/src/app.service.ts` - Service principal
4. `gen/static-api/src/common/interceptors/logging.interceptor.ts` - Interceptor de logs
5. `gen/static-api/src/constants/shared.ts` - Constantes compartilhadas
6. `gen/static-api/entrypoint.sh` - Script de entrada

## Arquivos a Modificar
1. `gen/src/api-entity-generator.ts` - Gerar entities em `modules/<entity>/<entity>.entity.ts`
2. `gen/src/api-service-generator.ts` - Gerar services em `modules/<entity>/<entity>.service.ts`
3. `gen/src/api-controller-generator.ts` - Gerar controllers em `modules/<entity>/<entity>.controller.ts`
4. `gen/src/api-dto-generator.ts` - Gerar DTOs em `modules/<entity>/<entity>.dto.ts`
5. `gen/src/api-module-generator.ts` - Gerar modules em `modules/<entity>/<entity>.module.ts`
6. `gen/src/api-interface-generator.ts` - Gerar interfaces em `modules/<entity>/<entity>.interface.ts`
7. `gen/templates/api-app-module.template.ejs` - Correção imports para nova estrutura
8. `gen/templates/api-main.template.ejs` - Correção imports

## Estrutura Alvo (Padrão NestJS)
```
api/
├── Dockerfile
├── README.md
├── docker-compose.yml
├── entrypoint.sh
├── nest-cli.json
├── package-lock.json
├── package.json
├── tsconfig.json
└── src/
    ├── app.controller.ts
    ├── app.module.ts
    ├── app.service.ts
    ├── main.ts
    ├── common/
    │   └── interceptors/
    │       └── logging.interceptor.ts
    ├── constants/
    │   └── shared.ts
    ├── middleware/
    │   └── jwt-auth.guard.ts
    ├── modules/
    │   ├── config/
    │   ├── health/
    │   ├── version/
    │   └── user/
    │       ├── user.controller.ts
    │       ├── user.entity.ts
    │       ├── user.module.ts
    │       └── user.service.ts
    └── validators/
```

## Requisitos da Mudança
- Remover prefixo "app-" dos nomes de módulos gerados
- Entities devem ficar em `modules/<entity>/<entity>.entity.ts`
- Todos os arquivos de uma entidade (controller, service, module, entity, dto) devem estar na mesma pasta
- Adicionar arquivos padrão NestJS faltantes (app.controller, app.service, nest-cli.json, etc)

## Requisitos Não Atendidos
- Estrutura atual não segue padrão NestJS
- Faltam arquivos essenciais (app.controller, app.service, nest-cli.json, etc)
- Entities estão em pasta separada

## Regras do Projeto
- Cada template tem seu próprio gerador com prefixo api-
- Arquivos estáticos ficam em gen/static-api/
- main.ts orquestra todos os geradores

## Plano de Auditoria
1. Verificar se todos os arquivos estáticos foram criados
2. Verificar se geradores output na estrutura correta
3. Testar geração com projeto E2E users
4. Validar que build compila sem erros
5. Validar estrutura de arquivos gerados
