---
name: "Improve interface.template.ts"
about: "Enhance the interface template with best practices"
labels: enhancement
assignees: ''
---

## Summary
The `templates/interface.template.ts` file currently outputs placeholders for query and persist DTOs without any documentation. This lacks context and can cause confusion for consumers of the generated interfaces.

## Proposed Enhancements
- **Add file level documentation**
  - Include a JSDoc header describing the generated Query and Persist DTO interfaces, referencing the entity name.
- **Document each interface**
  - Provide JSDoc comments for the Query DTO and Persist DTO to describe their purpose and fields.
- **Ensure formatting consistency**
  - Maintain Prettier formatting and a final newline in the template.
- **Maintain consistency with other templates**
  - Keep naming conventions and imports in sync with the DTO templates to reduce confusion.

By following these improvements, the generated interfaces will be easier to understand and align with the project's style.

