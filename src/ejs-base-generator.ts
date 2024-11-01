// src/base-generator.ts

import * as fs from 'fs';
import * as path from 'path';
import { IGeneratorConfig } from "./interfaces";
import { ITable, IColumn, IRelation, IDbReaderConfig } from './interfaces';

export abstract class EJSBaseGenerator {

    protected generatorConfig: IGeneratorConfig;
	protected schema: ITable[];

    constructor(_templateName: string, _config: IGeneratorConfig) {
        this.generatorConfig = _config;
		this.schema = this.loadMetadata(this.generatorConfig.schemaPath);
    }

    abstract generate(): void;

    protected writeFileSync(relativePath: string, content: string) {
        const filePath = path.join(this.generatorConfig.outputDir, relativePath);

        try {
            // Criar o diretório se não existir
            fs.mkdirSync(path.dirname(filePath), { recursive: true });

            // Escrever o conteúdo no arquivo
            fs.writeFileSync(filePath, content);
            console.log(`${path.basename(filePath)} generated at ${filePath}`);
        } catch (error) {
            console.error(`Error writing file at ${filePath}: ${error}`);
        }
    }

    protected loadMetadata(_schemaPath: string): any {
        try {
			const schemaJson = fs.readFileSync(_schemaPath, 'utf-8');
			const parsedSchema = JSON.parse(schemaJson);
			return parsedSchema.schema;
        } catch (error) {
            console.error("Failed to load metadata:", error);
        }
    }

	protected generateResponseType(metadata: any): string {
		if (metadata && metadata.response && metadata.response.data) {
			const keys = Object.keys(metadata.response.data);
			if (keys.length > 0) {
				return `{ ${keys.map(key => `${key}: any`).join(', ')} }`;
			}
		}
		return "any";
	}

	public static toPascalCase(str: string): string {
		str = this.removeTbPrefix(str);
		return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
	}

	public static removeTbPrefix(str: string): string {
		return str.startsWith('tb_') ? str.substring(3) : str;
	}
}
