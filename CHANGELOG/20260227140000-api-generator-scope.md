<!-- CHANGELOG/20260227140000-api-generator-scope.md -->
# Entrega: Novo Escopo de Geração API

## Data/Hora: 2026-02-27T14:00:00Z

## Resumo
Implementado novo escopo de geração de API com estrutura `<output>/<project>/<database>/api/src/modules/<entity>` utilizando templates com prefixo `api-`.

## Arquivos Criados

### Geradores API (gen/src/)
- `api-entity-generator.ts` - Gera entidades TypeORM
- `api-service-generator.ts` - Gera services
- `api-controller-generator.ts` - Gera controllers
- `api-dto-generator.ts` - Gera DTOs
- `api-module-generator.ts` - Gera modules
- `api-app-module-generator.ts` - Gera app.module.ts
- `api-main-generator.ts` - Gera main.ts
- `api-datasource-generator.ts` - Gera datasource.service.ts
- `api-interface-generator.ts` - Gera interfaces
- `api-readme-generator.ts` - Gera README

### Arquivos Estáticos (gen/static-api/)
- Estrutura completa com middleware, modules (config, health, version) e validators
- `package.json`, `tsconfig.json`, `Dockerfile`, etc.

### Templates Ajustados
- `api-column.template.ejs` - Correção de indentação
- `api-app-module.template.ejs` - Correção de caminhos de importação
- `api-main.template.ejs` - Correção de caminhos de importação
- `api-module.template.ejs` - Correção de caminhos para middleware
- `api-controller.template.ejs` - Correção de caminhos para middleware
- `api-interface.template.ejs` - Suporte a queryDto e persistDto
- `tsconfig.json` - Correção do path mapping `@app/*`

## Arquivos Modificados

### gen/src/main.ts
- Adicionados imports dos novos geradores API
- Adicionada função `copyStaticApiFiles()`
- Adicionados cases para componentes api-*

### gen/src/interfaces.ts
- Adicionados tipos de componentes API

## Componentes API Suportados
- `api-entities` - Entidades TypeORM
- `api-services` - Services
- `api-interfaces`
- `api - Interfaces TypeScript-controllers` - Controllers NestJS
- `api-dtos` - DTOs com class-validator
- `api-modules` - Modules NestJS
- `api-app-module` - AppModule principal
- `api-main` - Arquivo main.ts
- `api-datasource` - DataSource configurado
- `api-readme` - README.md

## Resultado do Teste
- Geração executada com sucesso para projeto "accounts"
- Build do projeto gerado compilou sem erros
- Estrutura de arquivos gerada corretamente em `<output>/api/src/`

## Pendências
- Testes E2E para a nova funcionalidade (a implementar)
