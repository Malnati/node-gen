---
name: "Improve templates/service.template.ts"
about: "Enhance the service template with best practices"
labels: enhancement
assignees: 'Malnati'
---

## Summary
The `templates/service.template.ts` file generates NestJS services but lacks comments and proper error handling. CRUD methods repeat repository lookups and do not consistently manage errors.

## Proposed Enhancements
- **Add comments and documentation**
  - Document the class and each method with JSDoc, describing parameters, return types and thrown exceptions.
- **Refactor repository usage**
  - Store the repository in a private property initialized in the constructor to avoid repeating `getDataSource().getRepository()`.
- **Standardize error handling**
  - Use `try/catch` around database operations to log failures and rethrow meaningful exceptions.
- **Improve readability**
  - Add short comments for non-obvious logic (e.g., relation checks) and remove duplicate code.
- **Consider transactions**
  - Wrap create and update operations in a TypeORM transaction for consistency.

These improvements will make generated services more maintainable and aligned with NestJS development best practices.
