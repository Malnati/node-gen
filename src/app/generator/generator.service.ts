// src/app/generator/generator.service.ts

import { Injectable } from '@nestjs/common';
import * as path from 'path';
import fsextra from 'fs-extra';
import { exec } from 'child_process';
import * as prettier from 'prettier';
import { DbReader } from './db.metadata.generator';
import { DiagramGenerator } from './diagram-generator';
import { IDbReaderConfig } from './interfaces';
import { zipDirectory } from '../utils/ZipUtil';

@Injectable()
export class GeneratorService {
	
  async generate(dbConfig: IDbReaderConfig): Promise<string> {
    console.log('Iniciando geração de código...');

    await this.copyStaticFiles(dbConfig.outputDir);
    await this.removeNodeModules(dbConfig.outputDir);
    await this.formatFiles(dbConfig.outputDir);

    const schemaPath = path.join(dbConfig.outputDir, 'db.metadata.json');
    const dbReader = new DbReader(schemaPath, dbConfig, dbConfig.dbType);
    await dbReader.getSchemaInfo();

    const components = dbConfig.components || ['entities', 'services', 'interfaces', 'controllers'];
    const promises = components.map((component) => this.executeComponentGeneration(component, schemaPath, dbConfig));

    await Promise.all(promises);
    await this.runNpmInstall(dbConfig.outputDir);
    await this.runPrettier(dbConfig.outputDir);

    const zipPath = path.join(dbConfig.outputDir, 'generated_code.zip');
    await zipDirectory(dbConfig.outputDir, zipPath);
    return zipPath;
  }

  private async executeComponentGeneration(component: string, schemaPath: string, dbConfig: IDbReaderConfig) {
    console.log(`Executando geração para componente: ${component}`);
    switch (component) {
      case 'diagram':
        const diagramGenerator = new DiagramGenerator(schemaPath, dbConfig);
        await diagramGenerator.generateDiagram();
        break;
      default:
        console.log(`Componente ${component} não reconhecido.`);
        break;
    }
  }

  private async copyStaticFiles(outputDir: string) {
    try {
      const staticPath = path.resolve(__dirname, '../static');
      await fsextra.copy(staticPath, outputDir, { overwrite: true });
      console.log('Arquivos estáticos copiados com sucesso.');
    } catch (err) {
      console.error('Erro ao copiar arquivos estáticos:', err);
    }
  }

  private async removeNodeModules(outputDir: string) {
    const nodeModulesPath = path.join(outputDir, 'node_modules');
    try {
      if (fsextra.existsSync(nodeModulesPath)) {
        await fsextra.promises.rm(nodeModulesPath, { recursive: true, force: true });
        console.log('Diretório node_modules removido com sucesso.');
      } else {
        console.log('Nenhum diretório node_modules encontrado para remover.');
      }
    } catch (err) {
      console.error('Erro ao remover o diretório node_modules:', err);
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
      console.log('Arquivos gerados formatados com sucesso.');
    } catch (err) {
      console.error('Erro ao formatar arquivos gerados:', err);
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
          console.error(`Erro ao executar npm install: ${error.message}`);
          reject(error);
        }
        if (stderr) console.error(`stderr: ${stderr}`);
        console.log(`stdout: ${stdout}`);
        console.log('Dependências instaladas com sucesso.');
        resolve();
      });
    });
  }

  private async runPrettier(outputDir: string): Promise<void> {
    return new Promise((resolve, reject) => {
      exec('npx prettier --write "src/app/**/*.ts"', { cwd: outputDir }, (error, stdout, stderr) => {
        if (error) {
          console.error(`Erro ao executar prettier: ${error.message}`);
          reject(error);
        }
        if (stderr) console.error(`stderr: ${stderr}`);
        console.log(`stdout: ${stdout}`);
        console.log('Prettier executado com sucesso.');
        resolve();
      });
    });
  }
}
