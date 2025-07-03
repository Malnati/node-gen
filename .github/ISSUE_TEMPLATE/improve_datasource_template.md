---
name: "Improve datasource.template.ts"
about: "Enhance datasource template with best practices"
labels: enhancement
assignees: ''
---

## Context
The `templates/datasource.template.ts` file generates the TypeORM DataSource service without comments or cache configuration. The version under `static/src/app/config/datasource.service.ts` contains documentation and optional settings that should be mirrored.

## Proposed Enhancements
- Add a header comment pointing to the generated file path.
- Document the `cacheDuration` constant.
- Mark `env` and `dataSource` as `private readonly`.
- Configure TypeORM cache using `cacheDuration` with explanatory comments.
- Optional SSL configuration controlled by environment variable, commented accordingly.
- Provide JSDoc comments for the class and `getDataSource` method.

Implementing these changes will make the generated service clearer and consistent with the static example.
