// gen/src/api-app-module-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig } from './interfaces';
import { toKebabCase, toPascalCase } from './utils/string';
import { loadTemplate } from './utils/template-loader';

const RESERVED_MODULE_NAMES = new Set([
  'ConfigModule', 'Module', 'ServeStaticModule', 'ProxyModule',
  'HealthModule', 'VersionModule', 'JwtAuthGuardModule', 'AppModule',
]);

export class ApiAppModuleGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateAppModule() {
    // Estrutura padrão: <output>/src/
    const outputDir = path.join(this.config.outputDir, 'src');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const moduleImports = this.schema.map(table => {
      const entityName = toPascalCase(table.tableName);
      const kebabCaseName = toKebabCase(table.tableName);
      const moduleName = `${entityName}Module`;
      if (RESERVED_MODULE_NAMES.has(moduleName)) {
        return `import { ${moduleName} as App${moduleName} } from './modules/${kebabCaseName}/${kebabCaseName}.module';`;
      }
      return `import { ${moduleName} } from './modules/${kebabCaseName}/${kebabCaseName}.module';`;
    }).join('\n');

    const moduleList = this.schema.map(table => {
      const entityName = toPascalCase(table.tableName);
      const moduleName = `${entityName}Module`;
      return RESERVED_MODULE_NAMES.has(moduleName) ? `App${moduleName}` : moduleName;
    }).join(',\n    ');

    const appModuleContent = this.generateAppModuleContent(moduleImports, moduleList);
    const filePath = path.join(outputDir, 'app.module.ts');
    fs.writeFileSync(filePath, appModuleContent);

    console.log(`API AppModule has been generated in ${outputDir}`);
  }

  private generateAppModuleContent(moduleImports: string, moduleList: string): string {
    return loadTemplate('api-app-module.template.ejs', {
      moduleImports,
      moduleList,
    });
  }
}
