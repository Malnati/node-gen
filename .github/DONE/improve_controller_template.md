---
name: "Improve controller.template.ts"
about: "Enhance the controller template with best practices"
labels: enhancement
assignees: ''
---

## Summary
The `templates/controller.template.ts` file generates NestJS controllers but contains repeated guard declarations and lacks validation, comments and logging.

## Proposed Enhancements
- **Apply authentication guard at the controller level**
  - Decorate the controller class with `@UseGuards(JwtAuthGuard)` to remove duplication in each method.
- **Validate UUID parameters**
  - Use `@Param('external_id', ParseUUIDPipe)` to ensure that `external_id` is a valid UUID.
- **Replace literal status codes**
  - Leverage `HttpStatus` constants and `@HttpCode` to improve readability and avoid magic numbers.
- **Add documentation comments**
  - Include JSDoc blocks on the controller and its methods describing the purpose, parameters and return values.
- **Introduce NestJS Logger**
  - Utilize `Logger` to log significant actions and errors for easier troubleshooting.

These improvements will ensure that generated controllers follow NestJS best practices and are easier to maintain.
