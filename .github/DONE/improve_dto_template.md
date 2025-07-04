---
name: "Improve dto.template.ts"
about: "Enhance the DTO template with best practices"
labels: enhancement
assignees: ''
---

## Summary
The `templates/dto.template.ts` file generates DTO classes but imports every decorator from `class-validator` and lacks clear documentation.

## Proposed Enhancements
- **Dynamic imports**
  - Include only the decorators actually used in each generated DTO.
- **Add comments and documentation**
  - Document each DTO class (Query/Persist) with JSDoc, explaining parameters and purpose.
- **Standardize formatting**
  - Follow `.prettierrc` and `.editorconfig` for consistent style.
- **Update README examples**
  - Show the improved DTO structure in the documentation.

These changes will make generated DTOs cleaner and more maintainable, alinhadas às boas práticas do NestJS.
