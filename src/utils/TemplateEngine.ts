// /src/utils/TemplateEngine.ts
import * as fs from 'fs';
import * as path from 'path';
import ejs from 'ejs';

export function renderTemplate(templateFile: string, data: Record<string, any>): string {
  const fullPath = path.resolve(__dirname, '..', '..', 'templates', templateFile);
  const template = fs.readFileSync(fullPath, 'utf-8');
  return ejs.render(template, data, { rmWhitespace: false });
}
