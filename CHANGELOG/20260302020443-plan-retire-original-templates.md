# Implementação: Aposentadoria dos Templates Originais

## Data/Hora
2026-03-02T02:10:00Z

## Arquivos Alterados

### Excluídos (12 templates originais)
- gen/templates/controller.template.ts
- gen/templates/module.template.ts
- gen/templates/dto.template.ts
- gen/templates/main.template.ts
- gen/templates/interface.template.ts
- gen/templates/entity.template.ts
- gen/templates/service.ejs
- gen/templates/relation.template.ts
- gen/templates/readme.template.ts
- gen/templates/datasource.template.ts
- gen/templates/app-module.template.ts
- gen/templates/column.template.ts

### Excluídos (13 generators originais - código morto)
- gen/src/app-module-generator.ts
- gen/src/controller-generator.ts
- gen/src/datasource-generator.ts
- gen/src/dto-generator.ts
- gen/src/interface-generator.ts
- gen/src/main-generator.ts
- gen/src/module-generator.ts
- gen/src/package-json-generator.ts
- gen/src/readme-generator.ts
- gen/src/service-generator.ts
- gen/src/typeorm-entity-generator.ts
- gen/src/env-generator.ts
- gen/src/static-templates.ts

### Excluído (diretório arquivos estáticos)
- gen/static/ (completo)

### Alterados
- gen/src/main.ts - atualizado para usar apenas componentes api-*
- test/e2e-generator/e2e.json - componentes atualizados para api-*

### Mantidos
- gen/templates/api-*.ejs (12 arquivos)
- gen/templates/mfe-*.ejs (8 arquivos)
- gen/templates/app-shell-*.ejs (4 arquivos)
- gen/static-api/ (arquivos estáticos API)
- gen/static-mfe/ (arquivos estáticos MFE)

## Regras/Requisitos Atendidos
- [x] Templates originais aposentados (12 arquivos)
- [x] Templates api-* mantidos (12 arquivos)
- [x] Templates MFE mantidos (8 arquivos)
- [x] Templates app-shell mantidos (4 arquivos)
- [x] E2E configurado para usar api-* components
- [x] Build do generator funciona (npm run build)
- [x] Docker compose services OK (5 serviços)
- [x] E2E docker compose services OK (4 serviços)
- [x] Projects docker compose OK

## Verificações Realizadas
1. `ls gen/templates/ | wc -l` → 24 arquivos ✓
2. Build: `cd gen && npm run build` → OK ✓
3. Docker compose config → todos os serviços OK ✓

## Pendências
- Executar E2E para validar geração completa (recomendado: make e2e-todo)
