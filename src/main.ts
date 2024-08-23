#!/usr/bin/env node

import path from "path";
import * as readline from "readline";
import { DbReader } from "./db.reader.postgres";
import { ConfigUtil } from "./utils/ConfigUtil";
import { TypeORMEntityGenerator } from "./typeorm-entity-generator";
import { ServiceGenerator } from "./service-generator";
import { InterfaceGenerator } from "./interface-generator";
import { ControllerGenerator } from "./controller-generator";
import { DTOGenerator } from "./dto-generator";
import { ModuleGenerator } from "./module-generator";
import { AppModuleGenerator } from "./app-module-generator";
import { MainFileGenerator } from "./main-generator";
import { EnvGenerator } from "./env-generator";
import { PackageJsonGenerator } from "./package-json-generator";
import { ReadmeGenerator } from "./readme-generator";
import { DataSourceGenerator } from "./datasource-generator";
import fs from 'fs-extra';
import { DiagramGenerator } from "./diagram-generator";
import { exec } from "child_process";


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
        await fs.copy(staticPath, destDir, {
            overwrite: true,
        });
        console.log('Arquivos estáticos copiados com sucesso.');
    } catch (err) {
        console.error('Erro ao copiar arquivos estáticos:', err);
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

async function main() {
    await copyStaticFiles(dbConfig.outputDir);

    const schemaPath = path.join(dbConfig.outputDir, "db.reader.postgres.json");
    console.log(`Executando comando para ${schemaPath}`);
    const dbReader = new DbReader(schemaPath, dbConfig);
    await dbReader.getSchemaInfo();

    let components: string[];
    if (dbConfig.components && Array.isArray(dbConfig.components)) {
        components = dbConfig.components;
    } else {
        const response = await askQuestion(
            "Especifique quais componentes gerar \n" + 
            "(entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource): "
        );
        components = response.replace("\"", "")
        .split(",")
        .map((c) => c.trim().toLowerCase());
    }

    const promises = components.map(async (component) => {
        if (component) {
            console.log(`Executando comando para ${component}`);
            switch (component) {
                case "entities": {
                    const entityGenerator = new TypeORMEntityGenerator(schemaPath, dbConfig);
                    return entityGenerator.generateEntities();
                }
    
                case "services": {
                    const serviceGenerator = new ServiceGenerator(schemaPath, dbConfig);
                    return serviceGenerator.generateServices();
                }
    
                case "interfaces": {
                    const interfaceGenerator = new InterfaceGenerator(schemaPath, dbConfig);
                    return interfaceGenerator.generateInterfaces();
                }
    
                case "controllers": {
                    const controllersGenerator = new ControllerGenerator(schemaPath, dbConfig);
                    return controllersGenerator.generateControllers();
                }
    
                case "dtos": {
                    const dtosGenerator = new DTOGenerator(schemaPath, dbConfig);
                    return dtosGenerator.generateDTOs();
                }
    
                case "modules": {
                    const modulesGenerator = new ModuleGenerator(schemaPath, dbConfig);
                    return modulesGenerator.generateModules();
                }
    
                case "app-module": {
                    const appModuleGenerator = new AppModuleGenerator(schemaPath, dbConfig);
                    return appModuleGenerator.generateAppModule();
                }
    
                case "main": {
                    const mainGenerator = new MainFileGenerator(schemaPath, dbConfig);
                    return mainGenerator.generateMainFile();
                }
    
                case "env": {
                    const envGenerator = new EnvGenerator(schemaPath, dbConfig);
                    return envGenerator.generateEnvFile();
                }
    
                case "package.json": {
                    const packageJsonGenerator = new PackageJsonGenerator(schemaPath, dbConfig);
                    return packageJsonGenerator.generatePackageJsonFile();
                }
    
                case "readme": {
                    const readmeGenerator = new ReadmeGenerator(schemaPath, dbConfig);
                    return readmeGenerator.generateReadme();
                }
    
                case "datasource": {
                    const dsGenerator = new DataSourceGenerator(schemaPath, dbConfig);
                    return dsGenerator.generateDataSourceFile();
                }
    
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
    
    await Promise.all(promises);

    await runNpmInstall(dbConfig.outputDir);
}

main();
