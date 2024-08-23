
// src/datasource-generator.ts

import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig, Table } from './interfaces';

export class DataSourceGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    const parsedSchema = JSON.parse(schemaJson);
    this.schema = parsedSchema.schema;
    this.config = config;
  }

  generateDataSourceFile() {
    const outputDir = path.join(this.config.outputDir, 'src/app/config');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const dataSourceFileContent = this.generateDataSourceFileContent();
    const filePath = path.join(outputDir, 'datasource.service.ts');
    fs.writeFileSync(filePath, dataSourceFileContent);

    console.log(`DataSource file has been generated in ${outputDir}`);
  }

  private generateDataSourceFileContent(): string {
    const entityImports = this.schema
      .map((table) => {
        const entityName = this.toPascalCase(table.tableName);
        return `import { ${entityName}Entity } from "@app/entities/${entityName.toLowerCase()}";`;
      })
      .join('\n');

    const entitiesArray = this.schema
      .map((table) => {
        const entityName = this.toPascalCase(table.tableName);
        return `${entityName}Entity`;
      })
      .join(', ');

    return `import "reflect-metadata";
import { DataSource } from "typeorm";
import { Injectable } from "@nestjs/common";
import { EnvironmentService } from "./environment.service";
${entityImports}

export const cacheDuration = 31536000000;

@Injectable()
export class DataSourceService {
  private dataSource: DataSource;

  constructor(private env: EnvironmentService) {
    this.dataSource = new DataSource({
      type: "postgres",
      host: env.getEnv().get<string>("DATABASE_HOST"),
      port: env.getEnv().get<number>("DATABASE_PORT"),
      database: env.getEnv().get<string>("DATABASE_NAME"),
      username: env.getEnv().get<string>("DATABASE_USER"),
      password: env.getEnv().get<string>("DATABASE_PASSWORD"),
      entities: [${entitiesArray}],
      synchronize: false,
      logging: true,
      ssl: {
        rejectUnauthorized: false,
      }
    });
  }

  getDataSource(): DataSource {
    return this.dataSource;
  }
}
`;
  }

  private toPascalCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
  }
}