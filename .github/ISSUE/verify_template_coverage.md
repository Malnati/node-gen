---
name: "Verificar cobertura dos templates em src/main.ts"
about: "Confirma se todos os arquivos de templates s\u00e3o utilizados para gerar o c\u00f3digo"
labels: documentation
assignees: 'Malnati'
---

## Summary
O diret\u00f3rio `templates/` cont\u00e9m os arquivos base para gera\u00e7\u00e3o de c\u00f3digo. Este checklist garante que cada template possui um gerador invocado em `src/main.ts`.

## Checklist
Verifique se cada template possui um gerador correspondente e se o mesmo está
invocado em `src/main.ts`.

- [ ] `app-module.template.ts` – gerado por `AppModuleGenerator` (caso
  `app-module`)
- [ ] `column.template.ts` – usado em `TypeORMEntityGenerator` (caso
  `entities`)
- [ ] `controller.template.ts` – gerado por `ControllerGenerator` (caso
  `controllers`)
- [ ] `datasource.template.ts` – gerado por `DataSourceGenerator` (caso
  `datasource`)
- [ ] `dto.template.ts` – gerado por `DTOGenerator` (caso `dtos`)
- [ ] `entity.template.ts` – gerado por `TypeORMEntityGenerator` (caso
  `entities`)
- [ ] `interface.template.ts` – gerado por `InterfaceGenerator` (caso
  `interfaces`)
- [ ] `main.template.ts` – gerado por `MainFileGenerator` (caso `main`)
- [ ] `module.template.ts` – gerado por `ModuleGenerator` (caso `modules`)
- [ ] `readme.template.ts` – gerado por `ReadmeGenerator` (caso `readme`)
- [ ] `relation.template.ts` – usado em `TypeORMEntityGenerator` (caso
  `entities`)
- [ ] `service.ejs` – gerado por `ServiceGenerator` (caso `services`)

## Action
Caso algum item fique pendente, atualize `src/main.ts` para incluir o gerador correspondente ou ajuste os componentes suportados.
