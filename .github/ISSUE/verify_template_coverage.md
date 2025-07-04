---
name: "Verificar cobertura dos templates em src/main.ts"
about: "Confirma se todos os arquivos de templates s\u00e3o utilizados para gerar o c\u00f3digo"
labels: documentation
assignees: 'Malnati'
---

## Summary
O diret\u00f3rio `templates/` cont\u00e9m os arquivos base para gera\u00e7\u00e3o de c\u00f3digo. Este checklist garante que cada template possui um gerador invocado em `src/main.ts`.

## Checklist
- [ ] `app-module.template.ts`
- [ ] `column.template.ts`
- [ ] `controller.template.ts`
- [ ] `datasource.template.ts`
- [ ] `dto.template.ts`
- [ ] `entity.template.ts`
- [ ] `interface.template.ts`
- [ ] `main.template.ts`
- [ ] `module.template.ts`
- [ ] `readme.template.ts`
- [ ] `relation.template.ts`
- [ ] `service.ejs`

## Action
Caso algum item fique pendente, atualize `src/main.ts` para incluir o gerador correspondente ou ajuste os componentes suportados.
