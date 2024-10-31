// src/ejs-typeorm-entity-generator.ts

import { IGenerator, IGeneratorConfig, ITable } from './interfaces';
import { EJSBaseGenerator } from './ejs-base-generator';
import { entityTemplate, columnTemplate, relationTemplate, typeMapping, jsTypeMapping, toPascalCase, removeTbPrefix } from './static-templates';

import * as fs from 'fs';
import * as path from 'path';
import ejs from "ejs";

export class EJSTypesGenerator extends EJSBaseGenerator implements IGenerator {

	public templateName: string;
	public targetDir: string;

    constructor(_templateName: string, _targetDir: string = 'src/app/entities', _generatorConfig: IGeneratorConfig) {
		super(_templateName, _generatorConfig);
		this.templateName = _templateName;
		this.targetDir = _targetDir;
        this.generatorConfig = _generatorConfig;
    }

    generate() {

		const outputDir = path.join(this.generatorConfig.outputDir, this.targetDir);
		// Verifica se o diretório de saída existe, se não, cria
		if (!fs.existsSync(outputDir)) {
		  fs.mkdirSync(outputDir, { recursive: true });
		}

		this.schema.forEach(table => {
		  const entityContent = this.generateEntityContent(table);
		  const filePath = path.join(outputDir, `${removeTbPrefix(table.tableName)}.ts`);
		  fs.writeFileSync(filePath, entityContent);
		});

		console.log(`Entities have been generated in ${outputDir}`);

        const filePath = path.join(__dirname, this.generatorConfig.templatesPath, this.templateName);

        ejs.renderFile(filePath, {}, (err: any, typesContent: string) => {
            if (err) {
                console.error(err);
                return;
            }
            this.writeFileSync(`components/${this.generatorConfig.outputDir}/types.ts`, typesContent);
        });
    }

	generateEntityContent(table: ITable): string {
		// Identifica colunas de chave primária (exemplo simplificado)
		const primaryKeys = table.columns.filter(col => col.columnName.includes('id'));

		const columns = table.columns
		  .filter(col => !this.isRelationColumn(col.columnName, table.relations))
		  .map(col => this.generateColumnDefinition(col, primaryKeys.includes(col)))
		  .join('\n  ');

		const relations = table.relations.map(rel => this.generateRelationDefinition(rel)).join('\n  ');
		const imports = this.generateImports(table);
		const customMethods = this.generateCustomMethods(table);

		return entityTemplate(table.tableName, columns, relations, imports, customMethods);
	  }
}
