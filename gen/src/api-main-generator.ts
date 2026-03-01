// gen/src/api-main-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig } from './interfaces';
import { loadTemplate } from './utils/template-loader';

export class ApiMainGenerator {
  private config: DbReaderConfig;

  constructor(config: DbReaderConfig) {
    this.config = config;
  }

  generateMainFile() {
    // Nova estrutura: <output>/api/src/
    const outputDir = path.join(this.config.outputDir, 'api', 'src');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const mainContent = this.generateMainContent();
    const filePath = path.join(outputDir, 'main.ts');
    fs.writeFileSync(filePath, mainContent);

    console.log(`API Main file has been generated in ${outputDir}`);
  }

  private generateMainContent(): string {
    return loadTemplate('api-main.template.ejs', {});
  }
}
