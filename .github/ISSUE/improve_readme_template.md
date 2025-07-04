---
name: "Improve readme.template.ts"
about: "Enhance the README template with best practices"
labels: enhancement
assignees: ""
uuid: 
---

## Summary

`templates/readme.template.ts` currently focuses on database documentation but lacks comments, badges and a usage section.

## Proposed Enhancements

- **Add EJS comments**
  - Explain each placeholder like `{{appName}}` and `{{sections}}` so users know how to customize.
- **Include project badges**
  - Add Node version, license and build status badges right after the main title.
- **Create a \"Como usar\" section**
  - Document ways to run the project via CLI, Docker and API endpoint/Swagger.
- **Ensure Markdown consistency**
  - Keep headings and lists properly formatted for readability.

These improvements will make the generated README more complete and easier to understand.
