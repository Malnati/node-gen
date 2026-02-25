// gen/src/microfrontend-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig, Column } from './interfaces';
import { toKebabCase, toPascalCase } from './utils/string';
import { renderTemplate } from './utils/TemplateEngine';

export interface MFEConfig {
  name: string;
  kebabName: string;
  pascalName: string;
  camelName: string;
  port: number;
  route: string;
  idType: string;
  idParam: string;
  columns: Column[];
  tableName: string;
}

export class MicrofrontendGenerator {
  private schema: Table[];
  private config: DbReaderConfig;
  private staticMfePath: string;
  private mfeConfigs: MFEConfig[] = [];
  private basePort = 7100;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
    this.staticMfePath = path.resolve(__dirname, '..', 'static-mfe');
  }

  async generate(): Promise<MFEConfig[]> {
    const outputDir = path.join(this.config.outputDir, 'frontend');
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    this.schema.forEach((table, index) => {
      const mfeConfig = this.generateMFE(table, outputDir, index);
      this.mfeConfigs.push(mfeConfig);
    });

    console.log(`MicroFrontends have been generated in ${outputDir}`);
    console.log(`Generated ${this.mfeConfigs.length} MFEs`);

    return this.mfeConfigs;
  }

  private generateMFE(table: Table, outputDir: string, index: number): MFEConfig {
    const kebabName = toKebabCase(table.tableName);
    const pascalName = toPascalCase(table.tableName);
    const camelName = this.toCamelCase(pascalName);
    const mfeDir = path.join(outputDir, `${kebabName}-mfe`);
    const port = this.basePort + index;
    const route = `/${kebabName}`;

    if (!fs.existsSync(mfeDir)) {
      fs.mkdirSync(mfeDir, { recursive: true });
    }

    const idInfo = this.getIdInfo(table);

    const mfeConfig: MFEConfig = {
      name: `@mfe/${kebabName}`,
      kebabName,
      pascalName,
      camelName,
      port,
      route,
      idType: idInfo.idType,
      idParam: idInfo.idParam,
      columns: table.columns.filter(c => !c.isPrimaryKey && c.columnName !== 'created_at' && c.columnName !== 'updated_at' && c.columnName !== 'deleted_at'),
      tableName: table.tableName,
    };

    this.copyStaticMFE(mfeDir);
    this.generateListPage(mfeDir, mfeConfig);
    this.generateDetailsPage(mfeDir, mfeConfig);
    this.generateViteConfig(mfeDir, mfeConfig);
    this.generateTest(mfeDir, mfeConfig);
    this.generateAppTsx(mfeDir, mfeConfig);
    this.updatePackageJson(mfeDir, mfeConfig);
    this.updateIndexHtml(mfeDir, mfeConfig);

    return mfeConfig;
  }

  private copyStaticMFE(destDir: string): void {
    fs.cpSync(this.staticMfePath, destDir, { recursive: true });
    console.log(`Copied static MFE to ${destDir}`);
  }

  private generateListPage(dir: string, config: MFEConfig): void {
    const pagesDir = path.join(dir, 'src', 'pages');
    if (!fs.existsSync(pagesDir)) {
      fs.mkdirSync(pagesDir, { recursive: true });
    }

    const columns = config.columns.map(c => ({
      columnName: c.columnName,
      displayName: this.getDisplayName(c.columnName),
      typescriptType: this.getTypeScriptType(c),
    }));

    const content = renderTemplate('mfe-list-page.ejs', {
      camelName: config.camelName,
      pascalName: config.pascalName,
      idType: config.idType,
      route: config.route,
      columns,
    });
    fs.writeFileSync(path.join(pagesDir, `${config.kebabName}-list-page.tsx`), content);
  }

  private generateDetailsPage(dir: string, config: MFEConfig): void {
    const pagesDir = path.join(dir, 'src', 'pages');

    const formFields = config.columns.map(c => ({
      name: c.columnName,
      label: this.getDisplayName(c.columnName),
      inputType: this.getInputType(c),
      isNumeric: ['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double'].includes(c.dataType.toLowerCase()),
      required: !c.isNullable,
      defaultValue: this.getDefaultValue(c),
    }));

    const content = renderTemplate('mfe-details-page.ejs', {
      camelName: config.camelName,
      pascalName: config.pascalName,
      idType: config.idType,
      route: config.route,
      formFields,
    });
    fs.writeFileSync(path.join(pagesDir, `${config.kebabName}-details-page.tsx`), content);
  }

  private generateViteConfig(dir: string, config: MFEConfig): void {
    const content = renderTemplate('mfe-vite-config.ejs', {
      name: config.name,
      port: config.port,
    });
    fs.writeFileSync(path.join(dir, 'vite.config.ts'), content);
  }

  private generateTest(dir: string, config: MFEConfig): void {
    const testDir = path.join(dir, '..', '..', 'test', 'e2e-mfe');
    if (!fs.existsSync(testDir)) {
      fs.mkdirSync(testDir, { recursive: true });
    }

    const firstField = config.columns[0]?.columnName || 'id';
    const content = renderTemplate('mfe-test-playwright.ejs', {
      pascalName: config.pascalName,
      route: config.route.replace(/^\//, ''),
      firstField,
    });
    fs.writeFileSync(path.join(testDir, `${config.kebabName}.spec.ts`), content);
  }

  private generateAppTsx(dir: string, config: MFEConfig): void {
    const appTsxPath = path.join(dir, 'src', 'App.tsx');
    const content = renderTemplate('mfe-app.ejs', {
      pascalName: config.pascalName,
      kebabName: config.kebabName,
      route: config.route,
    });
    fs.writeFileSync(appTsxPath, content);
  }

  private updatePackageJson(dir: string, config: MFEConfig): void {
    const pkgPath = path.join(dir, 'package.json');
    const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf-8'));
    pkg.name = `${config.kebabName}-mfe`;
    pkg.scripts = {
      ...pkg.scripts,
      'serve:mfe': `npx serve dist -l ${config.port}`,
    };
    fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2));
  }

  private updateIndexHtml(dir: string, config: MFEConfig): void {
    const htmlPath = path.join(dir, 'index.html');
    let content = fs.readFileSync(htmlPath, 'utf-8');
    content = content.replace(/<%= appName %>/g, config.pascalName);
    content = content.replace(/<%- importMap %>/g, '{}');
    fs.writeFileSync(htmlPath, content);
  }

  private getIdInfo(table: Table): { idType: string; idParam: string } {
    const hasExternalId = table.columns.some(c => c.columnName === 'external_id');
    if (hasExternalId) {
      return { idType: 'string', idParam: 'external_id' };
    }
    const pkColumn = table.columns.find(c => c.isPrimaryKey);
    if (pkColumn) {
      const isNumeric = ['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double'].includes(pkColumn.dataType.toLowerCase());
      return { idType: isNumeric ? 'number' : 'string', idParam: 'id' };
    }
    return { idType: 'number', idParam: 'id' };
  }

  private toCamelCase(str: string): string {
    return str.charAt(0).toLowerCase() + str.slice(1);
  }

  private getDisplayName(columnName: string): string {
    return columnName
      .replace(/_/g, ' ')
      .replace(/([A-Z])/g, ' $1')
      .replace(/^./, s => s.toUpperCase())
      .trim();
  }

  private getTypeScriptType(column: Column): string {
    const dt = column.dataType.toLowerCase();
    if (['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double', 'real'].includes(dt)) {
      return 'number';
    }
    if (['date', 'datetime', 'timestamp', 'timestamptz'].includes(dt)) {
      return 'string';
    }
    if (['boolean', 'bool'].includes(dt)) {
      return 'boolean';
    }
    return 'string';
  }

  private getInputType(column: Column): string {
    const dt = column.dataType.toLowerCase();
    if (['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double', 'real'].includes(dt)) {
      return 'number';
    }
    if (['date', 'datetime', 'timestamp', 'timestamptz'].includes(dt)) {
      return 'date';
    }
    return 'text';
  }

  private getDefaultValue(column: Column): string {
    const dt = column.dataType.toLowerCase();
    if (['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double', 'real'].includes(dt)) {
      return '0';
    }
    if (['boolean', 'bool'].includes(dt)) {
      return 'false';
    }
    return "''";
  }
}
