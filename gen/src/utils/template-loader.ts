// /src/utils/template-loader.ts
import * as fs from 'fs';
import * as path from 'path';

export function loadTemplate(templateName: string, variables: Record<string, string>): string {
  const templatePath = path.resolve(__dirname, '..', '..', 'templates', templateName);
  let content = fs.readFileSync(templatePath, 'utf-8');
  for (const [key, value] of Object.entries(variables)) {
    const regex = new RegExp(`{{\\s*${key}\\s*}}`, 'g');
    content = content.replace(regex, value);
  }
  return content;
}
