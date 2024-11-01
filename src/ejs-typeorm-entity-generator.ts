// src/ejs-typeorm-entity-generator.ts

import { IGenerator, IGeneratorConfig, ITable } from './interfaces';
import { EJSBaseGenerator } from './ejs-base-generator';
import { removeTbPrefix } from './static-templates';

import * as fs from 'fs';
import * as path from 'path';
import ejs from "ejs";

export class EJSTypesGenerator extends EJSBaseGenerator implements IGenerator {

	public templateFileName: string;
	public targetDir: string;

    constructor(_templateName: string, _targetDir: string = 'src/app/entities', _generatorConfig: IGeneratorConfig) {
		super(_templateName, _generatorConfig);
		this.templateFileName = _templateName;
		this.targetDir = _targetDir;
        this.generatorConfig = _generatorConfig;
    }

    generate() {
		// Verifica se o diretório de saída existe, se não, cria
		const outputDir = path.join(this.generatorConfig.outputDir, this.targetDir);
		if (!fs.existsSync(outputDir)) {
		  fs.mkdirSync(outputDir, { recursive: true });
		}
		const templateFilePath = path.join(__dirname, this.generatorConfig.templatesPath, this.templateFileName);
		this.schema.forEach(table => {
		  const targetFilePath = path.join(outputDir, `${removeTbPrefix(table.tableName)}.ts`);
		  ejs.renderFile(templateFilePath, this.schema, (err: any, typesContent: string) => {
			  if (err) {
				  console.error(err);
				  return;
			  }
			  this.writeFileSync(targetFilePath, typesContent);
		  });
		});
		console.log(`Entities have been generated in ${outputDir}`);
    }

}
