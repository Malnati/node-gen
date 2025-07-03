#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig } from './interfaces';
import { loadTemplate } from './utils/template-loader';

export class MainFileGenerator {
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.config = config;
  }

generateMainFile() {
    const outputDir = path.join(this.config.outputDir, 'src/app');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const mainFileContent = this.generateMainFileContent();
    const filePath = path.join(outputDir, 'main.ts');
    fs.writeFileSync(filePath, mainFileContent);

    console.log(`Main file has been generated in ${outputDir}`);
  }

  private generateMainFileContent(): string {
    return loadTemplate('main.template.ts', {});
  }
}
