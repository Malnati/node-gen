// src/app/generator/generator.service.ts

import { Injectable, Logger } from '@nestjs/common';
import * as path from 'path';
import fsextra from 'fs-extra';
import { exec } from 'child_process';
import * as prettier from 'prettier';
import { DbReader } from './db.metadata.generator';
import { DiagramGenerator } from './diagram-generator';
import { IDbReaderConfig } from './interfaces';
import { zipDirectory } from '../utils/ZipUtil';
import { validateDatabaseConnection } from '../utils/PostgresUtil';

@Injectable()
export class GeneratorService {
	private readonly logger = new Logger(GeneratorService.name);

	async generate(dbConfig: IDbReaderConfig): Promise<string> {
		const startTime = Date.now();
		this.logger.log('Iniciando geração de código...');

		try {
			validateDatabaseConnection(dbConfig, this.logger);
			this.logger.log('Conexão ao banco validada.');

			const copyStart = Date.now();
			await this.copyStaticFiles(dbConfig.outputDir);
			this.logger.log(`Tempo para copiar arquivos estáticos: ${Date.now() - copyStart} ms.`);

			const removeStart = Date.now();
			await this.removeNodeModules(dbConfig.outputDir);
			this.logger.log(`Tempo para remover node_modules: ${Date.now() - removeStart} ms.`);

			const formatStart = Date.now();
			await this.formatFiles(dbConfig.outputDir);
			this.logger.log(`Tempo para formatar arquivos: ${Date.now() - formatStart} ms.`);

			const schemaPath = path.join(dbConfig.outputDir, 'db.metadata.json');
			const dbReader = new DbReader(schemaPath, dbConfig, dbConfig.dbType);
			await dbReader.getSchemaInfo();
			this.logger.log('Esquema do banco de dados carregado.');

			const generateComponentsStart = Date.now();
			const components = dbConfig.components || ['entities', 'services', 'interfaces', 'controllers'];
			const promises = components.map((component) => this.executeComponentGeneration(component, schemaPath, dbConfig));
			await Promise.all(promises);
			this.logger.log(`Tempo para geração dos componentes: ${Date.now() - generateComponentsStart} ms.`);

			const zipStart = Date.now();
			const zipPath = path.join(dbConfig.outputDir, 'generated_code.zip');
			const absoluteZipPath = await zipDirectory(dbConfig.outputDir, zipPath);
			if (absoluteZipPath) {
				this.logger.log(`Geração de código concluída com sucesso em: ${absoluteZipPath}. Tempo para compactar: ${Date.now() - zipStart} ms.`);
			} else {
				this.logger.error('Erro ao gerar arquivo zip.');
			}

			this.logger.log(`Tempo total de geração: ${Date.now() - startTime} ms.`);
			return absoluteZipPath;
		} catch (error) {
      this.logger.error(`Erro ao gerar código: ${(error as Error).message}`);
			throw error;
		}
	}

  private async executeComponentGeneration(component: string, schemaPath: string, dbConfig: IDbReaderConfig) {
    this.logger.log(`Executando geração para componente: ${component}`);
    switch (component) {
      case 'diagram':
        const diagramGenerator = new DiagramGenerator(schemaPath, dbConfig);
        await diagramGenerator.generateDiagram();
        break;
      default:
        this.logger.log(`Componente ${component} não reconhecido.`);
        break;
    }
  }

  private async copyStaticFiles(outputDir: string) {
    try {
      const staticPath = path.resolve('./static');
      await fsextra.copy(staticPath, outputDir, { overwrite: true });
      this.logger.log('Arquivos estáticos copiados com sucesso.');
    } catch (err) {
      this.logger.error('Erro ao copiar arquivos estáticos:', err);
    }
  }

  private async removeNodeModules(outputDir: string) {
    const nodeModulesPath = path.join(outputDir, 'node_modules');
    try {
      if (fsextra.existsSync(nodeModulesPath)) {
        await fsextra.promises.rm(nodeModulesPath, { recursive: true, force: true });
        this.logger.log('Diretório node_modules removido com sucesso.');
      } else {
        this.logger.log('Nenhum diretório node_modules encontrado para remover.');
      }
    } catch (err) {
      this.logger.error('Erro ao remover o diretório node_modules:', err);
    }
  }

  private async formatFiles(outputDir: string) {
    try {
      const configFile = await prettier.resolveConfigFile(outputDir);
      const options = { config: configFile, ignorePath: path.join(outputDir, '.prettierignore'), editorconfig: true };
      const files = await this.getAllFiles(outputDir);

      for (const filePath of files) {
        const content = await fsextra.promises.readFile(filePath, 'utf8');
        const formatted = await prettier.format(content, { ...options, filepath: filePath });
        await fsextra.promises.writeFile(filePath, formatted);
      }
      this.logger.log('Arquivos gerados formatados com sucesso.');
    } catch (err) {
      this.logger.error('Erro ao formatar arquivos gerados:', err);
    }
  }

  private async getAllFiles(dirPath: string, arrayOfFiles: string[] = []): Promise<string[]> {
    const files = await fsextra.promises.readdir(dirPath);
    for (const file of files) {
      const fullPath = path.join(dirPath, file);
      const stat = await fsextra.promises.stat(fullPath);
      if (stat.isDirectory()) {
        arrayOfFiles = await this.getAllFiles(fullPath, arrayOfFiles);
      } else if (/\.(js|ts|json|css|html|md)$/.test(file)) {
        arrayOfFiles.push(fullPath);
      }
    }
    return arrayOfFiles;
  }

  private async runNpmInstall(outputDir: string): Promise<void> {
    return new Promise((resolve, reject) => {
      exec('npm install', { cwd: outputDir }, (error, stdout, stderr) => {
        if (error) {
          this.logger.error(`Erro ao executar npm install: ${error.message}`);
          reject(error);
        }
        if (stderr) this.logger.error(`stderr: ${stderr}`);
        this.logger.log(`stdout: ${stdout}`);
        this.logger.log('Dependências instaladas com sucesso.');
        resolve();
      });
    });
  }

  private async runPrettier(outputDir: string): Promise<void> {
    return new Promise((resolve, reject) => {
      exec('npx prettier --write "src/app/**/*.ts"', { cwd: outputDir }, (error, stdout, stderr) => {
        if (error) {
          this.logger.error(`Erro ao executar prettier: ${error.message}`);
          reject(error);
        }
        if (stderr) this.logger.error(`stderr: ${stderr}`);
        this.logger.log(`stdout: ${stdout}`);
        this.logger.log('Prettier executado com sucesso.');
        resolve();
      });
    });
  }
}
