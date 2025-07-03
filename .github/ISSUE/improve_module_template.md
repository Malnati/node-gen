---
name: "Improve module.template.ts"
about: "Add best practices and comments to the module template"
labels: enhancement
assignees: ''
---

## Summary
The `templates/module.template.ts` file lacks the standardized comments found in other templates, such as `static/src/app/config/environment.module.ts`. Adding descriptive comments will make generated modules easier to understand.

## Proposed Enhancements
- **Add a header comment**
  - Include `// src/app/<module>/<module>.module.ts` at the top of the template.
- **Document the module class**
  - Provide a short JSDoc above `{{entityName}}Module` explaining its role.
- **Clarify imports**
  - Add brief Portuguese comments for each important import so developers know why it is required.
- **Ensure newline at end of file**
  - The template should end with a blank line.
- **Follow Portuguese comment style**
  - Keep comments consistent with other modules in the repository.

These changes will align the module template with best practices and improve code readability.
