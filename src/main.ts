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

const dbConfig = ConfigUtil.getConfig(); // Obtém as configurações do banco de dados

// Log para confirmar os valores capturados
console.log("Main...");
console.log(`App: ${dbConfig.app}`);
console.log(`Host: ${dbConfig.host}`);
console.log(`Port: ${dbConfig.port}`);
console.log(`Database: ${dbConfig.database}`);
console.log(`User: ${dbConfig.user}`);
console.log("Password: [HIDDEN]");
console.log(`Output Directory: ${dbConfig.outputDir}`);
console.log(`Components: ${dbConfig.components}`);

// Função para perguntar ao usuário quais componentes deseja gerar
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

async function main() {

    // Define o caminho para o schema
    const schemaPath = path.join(dbConfig.outputDir, "db.reader.postgres.json");
    console.log(`Executando comando para ${schemaPath}`);
    const dbReader = new DbReader(schemaPath, dbConfig); // Passa as configurações para o DbReader
    await dbReader.getSchemaInfo(); // Executa o método para obter o schema e gerar o arquivo

    let components: string[];
    if (dbConfig.components && Array.isArray(dbConfig.components)) {
        components = dbConfig.components;
    } else {
        const response = await askQuestion(
            "Especifique quais componentes gerar \n" + 
            "(entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme): "
        );
        components = response.replace("\"", "")
        .split(",")
        .map((c) => c.trim().toLowerCase());
    }

    for (const component of components) {
        if (component) {
            if (component === "entities") {
                console.log(`Executando comando para ${component}, ${schemaPath}, ${JSON.stringify(dbConfig)}`);
                // Cria uma instância do gerador de entidades passando o schema e as configurações
                const entityGenerator = new TypeORMEntityGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as entidades
                entityGenerator.generateEntities();
            }
            if (component === "services") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de serviços passando o schema e as configurações
                const serviceGenerator = new ServiceGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera os serviços
                serviceGenerator.generateServices();
            }
            if (component === "interfaces") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de interfaces passando o schema e as configurações
                const interfaceGenerator = new InterfaceGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as interfaces
                interfaceGenerator.generateInterfaces();
            }
            if (component === "controllers") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de controllers passando o schema e as configurações
                const controllersGenerator = new ControllerGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as controllers
                controllersGenerator.generateControllers();
            }
            if (component === "dtos") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de DTOs passando o schema e as configurações
                const dtosGenerator = new DTOGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as DTOs
                dtosGenerator.generateDTOs();
            }
            if (component === "modules") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de modules passando o schema e as configurações
                const modulesGenerator = new ModuleGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as modules
                modulesGenerator.generateModules();
            }
            if (component === "app-module") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de app-module passando o schema e as configurações
                const appModuleGenerator = new AppModuleGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as app-module
                appModuleGenerator.generateAppModule();
            }
            if (component === "main") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de main passando o schema e as configurações
                const mainGenerator = new MainFileGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as main
                mainGenerator.generateMainFile();
            }
            if (component === "env") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de env passando o schema e as configurações
                const envGenerator = new EnvGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as env
                envGenerator.generateEnvFile();
            }
            if (component === "package.json") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de package.json passando o schema e as configurações
                const packageJsonGenerator = new PackageJsonGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as package.json
                packageJsonGenerator.generatePackageJsonFile();
            }
            if (component === "readme") {
                console.log(`Executando comando para ${component}`);
                // Cria uma instância do gerador de readme passando o schema e as configurações
                const readmeGenerator = new ReadmeGenerator(
                    schemaPath,
                    dbConfig
                );
                // Gera as readme
                readmeGenerator.generateReadme();
            }
        } else {
            console.log(`Componente ${component} não reconhecido.`);
        }
    }
}

main();
