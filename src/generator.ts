#!/usr/bin/env node

const fs = require('fs');
const ejs = require('ejs');
const path = require('path');
import * as readline from "readline";
import { DbReader } from "./db.metadata.generator";
import { ConfigUtil } from "./utils/ConfigUtil";
import fsextra from 'fs-extra';
import { DiagramGenerator } from "./diagram-generator";
import { exec } from "child_process";
import * as prettier from "prettier";
import { ITable } from "./interfaces";

const dbConfig = ConfigUtil.getConfig();

console.log("Main...");
console.log(`App: ${dbConfig.app}`);
console.log(`Host: ${dbConfig.host}`);
console.log(`Port: ${dbConfig.port}`);
console.log(`Database: ${dbConfig.database}`);
console.log(`User: ${dbConfig.user}`);
console.log("Password: [HIDDEN]");
console.log(`Output Directory: ${dbConfig.outputDir}`);
console.log(`Components: ${dbConfig.components}`);
console.log(`Database Type: ${dbConfig.dbType}`);


function askQuestion(query: string): Promise<string> {
	const rl = readline.createInterface({
		input: process.stdin,
		output: process.stdout,
	});

	return new Promise((resolve) =>
		rl.question(query, (ans) => {
			rl.close();
			resolve(ans);
		})
	);
}

async function copyStaticFiles(destDir: string) {
	try {
		const staticPath = path.resolve(__dirname, '../static');
		await fsextra.copy(staticPath, destDir, {
			overwrite: true,
		});
		console.log('Arquivos estáticos copiados com sucesso.');
	} catch (err) {
		console.error('Erro ao copiar arquivos estáticos:', err);
	}
}

async function getAllFiles(dirPath: string, arrayOfFiles: string[] = []): Promise<string[]> {
	const files = await fsextra.promises.readdir(dirPath);

	for (const file of files) {
		const fullPath = path.join(dirPath, file);
		const stat = await fsextra.promises.stat(fullPath);

		if (stat.isDirectory()) {
			arrayOfFiles = await getAllFiles(fullPath, arrayOfFiles);
		} else if (/\.(js|ts|json|css|html|md)$/.test(file)) {
			arrayOfFiles.push(fullPath);
		}
	}

	return arrayOfFiles;
}

async function removeNodeModules(dirPath: string) {
	const nodeModulesPath = path.join(dirPath, 'node_modules');
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

async function formatFiles(destDir: string) {
	try {
		const configFile = await prettier.resolveConfigFile(destDir);

		const options = {
			config: configFile,
			ignorePath: path.join(destDir, '.prettierignore'),
			editorconfig: true,
		};

		const files = await getAllFiles(destDir);

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

async function runNpmInstall(directory: string): Promise<void> {
	console.log('Instalando dependências via npm install...');
	return new Promise((resolve, reject) => {
		exec('npm install', { cwd: directory }, (error, stdout, stderr) => {
			if (error) {
				console.error(`Erro ao executar npm install: ${error.message}`);
				reject(error);
			}
			if (stderr) {
				console.error(`stderr: ${stderr}`);
			}
			console.log(`stdout: ${stdout}`);
			console.log('Dependências instaladas com sucesso.');
			resolve();
		});
	});
}
async function runPrettier(directory: string): Promise<void> {
	console.log('Rodando prettier...');
	return new Promise((resolve, reject) => {
		exec('npx prettier --write "src/app/**/*.ts"', { cwd: directory }, (error, stdout, stderr) => {
			if (error) {
				console.error(`Erro ao executar prettier: ${error.message}`);
				reject(error);
			}
			if (stderr) {
				console.error(`stderr: ${stderr}`);
			}
			console.log(`stdout: ${stdout}`);
			console.log('prettier executado com sucesso.');
			resolve();
		});
	});
}

async function main() {
	await copyStaticFiles(dbConfig.outputDir);
	await removeNodeModules(dbConfig.outputDir);
	await formatFiles(dbConfig.outputDir);
	let schemaPath = path.join(dbConfig.outputDir, "db.metadata.json");

	const dbReader = new DbReader(schemaPath, dbConfig, dbConfig.dbType);
	await dbReader.getSchemaInfo();

	await dbReader.getSchemaInfo();

	let components: string[];
	if (dbConfig.components && Array.isArray(dbConfig.components)) {
		components = dbConfig.components;
	} else {
		const response = await askQuestion(
			"Especifique quais componentes gerar \n" +
			"(entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource, diagram): "
		);
		components = response.replace("\"", "")
			.split(",")
			.map((c) => c.trim().toLowerCase());
	}

	const promises = components.map(async (component) => {
		if (component) {
			console.log(`Executando comando para ${component}`);
			switch (component) {

				case "diagram": {
					const diagramGenerator = new DiagramGenerator(schemaPath, dbConfig);
					return diagramGenerator.generateDiagram();
				}

				default: {
					console.log(`Componente ${component} não reconhecido.`);
					return Promise.resolve();
				}
			}
		}
	});


	// Carrega o JSON com os metadados do banco de dados
	const metadataPath = path.join(dbConfig.outputDir, 'db.metadata.json');
	const metadataJSONContent = JSON.parse(fs.readFileSync(metadataPath, 'utf-8'));

	// Carrega o template EJS para entidades
	const entitiesTemplatePath = path.join(__dirname, 'templates/entities.ejs');
	const entitiesTemplateContent = fs.readFileSync(entitiesTemplatePath, 'utf-8');
	// Caminho para salvar os arquivos de saída
	const entitiesOutputDir = path.join(dbConfig.outputDir, 'src/app/entities');
	// Cria o diretório de saída, se não existir
	if (!fs.existsSync(entitiesOutputDir)) {
		fs.mkdirSync(entitiesOutputDir, { recursive: true });
	}
	// Carrega o template EJS para serviços
	const servicesTemplatePath = path.join(__dirname, 'templates/services.ejs');
	const servicesTemplateContent = fs.readFileSync(servicesTemplatePath, 'utf-8');
	// Carrega o template EJS para controllers
	const controllersTemplatePath = path.join(__dirname, 'templates/controllers.ejs');
	const controllersTemplateContent = fs.readFileSync(controllersTemplatePath, 'utf-8');
	// Carrega o template EJS para dtos
	const dtosTemplatePath = path.join(__dirname, 'templates/dtos.ejs');
	const dtosTemplateContent = fs.readFileSync(dtosTemplatePath, 'utf-8');
	// Carrega o template EJS para interfaces
	const interfacesTemplatePath = path.join(__dirname, 'templates/interfaces.ejs');
	const interfacesTemplateContent = fs.readFileSync(interfacesTemplatePath, 'utf-8');
	// Carrega o template EJS para module
	const moduleTemplatePath = path.join(__dirname, 'templates/module.ejs');
	const moduleTemplateContent = fs.readFileSync(moduleTemplatePath, 'utf-8');

	// Carrega o template EJS para 'README.md'
	const readmeTemplatePath = path.join(__dirname, 'templates/readme.ejs');
	const readmeTemplateContent = fs.readFileSync(readmeTemplatePath, 'utf-8');
	const readmeContentOutput = ejs.render(readmeTemplateContent, metadataJSONContent);
	// Define o nome do arquivo com base no nome da 'README.md'
	const readmeOutputPath = path.join(dbConfig.outputDir, 'README.md');
	// Salva o arquivo para a 'README.md' específica
	fs.writeFileSync(readmeOutputPath, readmeContentOutput);
	console.log(`README.md gerada com sucesso em ${readmeOutputPath}`);

	// Carrega o template EJS para package.json
	const packageTemplatePath = path.join(__dirname, 'templates/package.ejs');
	const packageTemplateContent = fs.readFileSync(packageTemplatePath, 'utf-8');
	const packageContentOutput = ejs.render(packageTemplateContent, metadataJSONContent);
	// Define o nome do arquivo com base no nome da package.json
	const packageOutputPath = path.join(dbConfig.outputDir, 'package.json');
	// Salva o arquivo para a package.json específica
	fs.writeFileSync(packageOutputPath, packageContentOutput);
	console.log(`package.json gerada com sucesso em ${packageOutputPath}`);

	// Carrega o template EJS para .env
	const envTemplatePath = path.join(__dirname, 'templates/env.ejs');
	const envTemplateContent = fs.readFileSync(envTemplatePath, 'utf-8');
	const envContentOutput = ejs.render(envTemplateContent, metadataJSONContent);
	// Define o nome do arquivo com base no nome da env.json
	const envOutputPath = path.join(dbConfig.outputDir, '.env');
	// Salva o arquivo para a env.json específica
	fs.writeFileSync(envOutputPath, envContentOutput);
	console.log(`.env gerada com sucesso em ${envOutputPath}`);

	// Carrega o template EJS para main.ts
	const mainTemplatePath = path.join(__dirname, 'templates/main.ejs');
	const mainTemplateContent = fs.readFileSync(mainTemplatePath, 'utf-8');
	const mainContentOutput = ejs.render(mainTemplateContent, metadataJSONContent);
	// Define o nome do arquivo com base no nome da main.json
	const mainOutputPath = path.join(dbConfig.outputDir, 'src/app/main.ts');
	// Salva o arquivo para a main.ts específica
	fs.writeFileSync(mainOutputPath, mainContentOutput);
	console.log(`main.ts gerada com sucesso em ${mainOutputPath}`);

	// Carrega o template EJS para DataSource.ts
	const dsTemplatePath = path.join(__dirname, 'templates/datasource.ejs');
	const dsTemplateContent = fs.readFileSync(dsTemplatePath, 'utf-8');
	const dsContentOutput = ejs.render(dsTemplateContent, metadataJSONContent);
	// Define o nome do arquivo com base no nome da DataSource.ts
	const dsOutputPath = path.join(dbConfig.outputDir, 'src/app/config/DataSource.ts');
	// Salva o arquivo para a DataSource.ts específica
	fs.writeFileSync(dsOutputPath, dsContentOutput);
	console.log(`DataSource.ts gerada com sucesso em ${dsOutputPath}`);

	// Carrega o template EJS para AppModule.ts
	const appModuleTemplatePath = path.join(__dirname, 'templates/app-module.ejs');
	const appModuleTemplateContent = fs.readFileSync(appModuleTemplatePath, 'utf-8');
	const appModuleContentOutput = ejs.render(appModuleTemplateContent, metadataJSONContent);
	// Define o nome do arquivo com base no nome da AppModule.ts
	const appModuleOutputPath = path.join(dbConfig.outputDir, 'src/app/AppModule.ts');
	// Salva o arquivo para a AppModule.ts específica
	fs.writeFileSync(appModuleOutputPath, appModuleContentOutput);
	console.log(`AppModule.ts gerada com sucesso em ${appModuleOutputPath}`);


	// Gera um arquivo separado para cada entidade
	metadataJSONContent.schema.forEach((table: ITable) => {
		const entitiesContentOutput = ejs.render(entitiesTemplateContent, { table });
		// Define o nome do arquivo com base no nome da entidade
		const entitiesOutputPath = path.join(entitiesOutputDir, `${table.entityName}.ts`);
		// Salva o arquivo para a entidade específica
		fs.writeFileSync(entitiesOutputPath, entitiesContentOutput);
		console.log(`Entidade ${table.entityName} gerada com sucesso em ${entitiesOutputPath}`);


		// Caminho para salvar os arquivos de saída
		const moduleOutputDir = path.join(dbConfig.outputDir, `src/app/${table.slugName}`);
		// Cria o diretório de saída, se não existir
		if (!fs.existsSync(moduleOutputDir)) {
			fs.mkdirSync(moduleOutputDir, { recursive: true });
		}

		// Gera um arquivo separado para cada serviço
		const servicesContentOutput = ejs.render(servicesTemplateContent, { table });
		// Define o nome do arquivo com base no nome do serviço
		const serviceOutputPath = path.join(moduleOutputDir, `${table.entityName}Service.ts`);
		// Salva o arquivo para o serviço específico
		fs.writeFileSync(serviceOutputPath, servicesContentOutput);
		console.log(`Serviço ${table.entityName}Service.ts gerada com sucesso em ${serviceOutputPath}`);

		// Gera um arquivo separado para cada Controller
		const controllersContentOutput = ejs.render(controllersTemplateContent, { table });
		// Define o nome do arquivo com base no nome do Controller
		const controllersOutputPath = path.join(moduleOutputDir, `${table.entityName}Controller.ts`);
		// Salva o arquivo para o Controller específico
		fs.writeFileSync(controllersOutputPath, controllersContentOutput);
		console.log(`Controller ${table.entityName}Controller.ts gerada com sucesso em ${controllersOutputPath}`);

		// Gera um arquivo separado para cada DTOs
		const dtosContentOutput = ejs.render(dtosTemplateContent, { table });
		// Define o nome do arquivo com base no nome do DTOs
		const dtosOutputPath = path.join(moduleOutputDir, `${table.entityName}DTOs.ts`);
		// Salva o arquivo para o DTOs específico
		fs.writeFileSync(dtosOutputPath, dtosContentOutput);
		console.log(`DTOs ${table.entityName}DTOs.ts gerada com sucesso em ${dtosOutputPath}`);

		// Gera um arquivo separado para cada interfaces
		const interfacesContentOutput = ejs.render(interfacesTemplateContent, { table });
		// Define o nome do arquivo com base no nome do interfaces
		const interfacesOutputPath = path.join(moduleOutputDir, `${table.entityName}Interfaces.ts`);
		// Salva o arquivo para o interfaces específico
		fs.writeFileSync(interfacesOutputPath, interfacesContentOutput);
		console.log(`Interfaces ${table.entityName}Interfaces.ts gerada com sucesso em ${interfacesOutputPath}`);

		// Gera um arquivo separado para cada module
		const moduleContentOutput = ejs.render(moduleTemplateContent, { table });
		// Define o nome do arquivo com base no nome do module
		const moduleOutputPath = path.join(moduleOutputDir, `${table.entityName}Module.ts`);
		// Salva o arquivo para o module específico
		fs.writeFileSync(moduleOutputPath, moduleContentOutput);
		console.log(`module ${table.entityName}Module.ts gerada com sucesso em ${moduleOutputPath}`);
	});

	await Promise.all(promises);

	await runNpmInstall(dbConfig.outputDir);
	await runPrettier(dbConfig.outputDir);
}

main();
