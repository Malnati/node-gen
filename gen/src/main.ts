// /src/main.ts
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
import { DbReaderMysql } from "./db.reader.mysql";
import { DbReaderSqlServer } from "./db.reader.sqlserver";

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

if (dbConfig.templateDir) {
    console.log(`Template Directory: ${dbConfig.templateDir}`);
}

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

async function copyStaticFiles(destDir: string, templateDir?: string) {
    try {
        const staticPath = templateDir ? path.resolve(templateDir) : path.resolve(__dirname, '../static');
        await fs.copy(staticPath, destDir, {
            overwrite: true,
        });
        console.log('Arquivos estáticos copiados com sucesso.');
    } catch (err) {
        console.error('Erro ao copiar arquivos estáticos:', err);
    }
}

async function main() {
    await copyStaticFiles(dbConfig.outputDir, dbConfig.templateDir);
    let schemaPath;

    let dbReader;
    if (dbConfig.dbType === 'mysql') {
        dbReader = new DbReaderMysql(path.join(dbConfig.outputDir, "db.reader.mysql.json"), dbConfig);
        schemaPath = path.join(dbConfig.outputDir, "db.reader.mysql.json");
    } else if (dbConfig.dbType === 'sqlserver') {
        dbReader = new DbReaderSqlServer(path.join(dbConfig.outputDir, 'db.reader.sqlserver.json'), dbConfig);
        schemaPath = path.join(dbConfig.outputDir, 'db.reader.sqlserver.json');
    } else if (dbConfig.dbType === 'postgres') {
        dbReader = new DbReader(path.join(dbConfig.outputDir, "db.reader.postgres.json"), dbConfig);
        schemaPath = path.join(dbConfig.outputDir, "db.reader.postgres.json");
    } else if (dbConfig.dbType === 'sqlite') {
        const { DbReaderSqlite } = await import('./db.reader.sqlite');
        dbReader = new DbReaderSqlite(path.join(dbConfig.outputDir, 'db.reader.sqlite.json'), dbConfig);
        schemaPath = path.join(dbConfig.outputDir, 'db.reader.sqlite.json');
    } else {
        throw new Error('Tipo de banco de dados não suportado');
    }

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

    for (const component of components) {
        if (component) {
            console.log(`Executando comando para ${component}`);
            switch (component) {
                case "entities": {
                    const entityGenerator = new TypeORMEntityGenerator(schemaPath, dbConfig);
                    await entityGenerator.generateEntities();
                    break;
                }

                case "services": {
                    const serviceGenerator = new ServiceGenerator(schemaPath, dbConfig);
                    await serviceGenerator.generateServices();
                    break;
                }

                case "interfaces": {
                    const interfaceGenerator = new InterfaceGenerator(schemaPath, dbConfig);
                    await interfaceGenerator.generateInterfaces();
                    break;
                }

                case "controllers": {
                    const controllersGenerator = new ControllerGenerator(schemaPath, dbConfig);
                    await controllersGenerator.generateControllers();
                    break;
                }

                case "dtos": {
                    const dtosGenerator = new DTOGenerator(schemaPath, dbConfig);
                    await dtosGenerator.generateDTOs();
                    break;
                }

                case "modules": {
                    const modulesGenerator = new ModuleGenerator(schemaPath, dbConfig);
                    await modulesGenerator.generateModules();
                    break;
                }

                case "app-module": {
                    const appModuleGenerator = new AppModuleGenerator(schemaPath, dbConfig);
                    await appModuleGenerator.generateAppModule();
                    break;
                }

                case "main": {
                    const mainGenerator = new MainFileGenerator(dbConfig);
                    await mainGenerator.generateMainFile();
                    break;
                }

                case "env": {
                    const envGenerator = new EnvGenerator(dbConfig);
                    await envGenerator.generateEnvFile();
                    break;
                }

                case "package.json": {
                    const packageJsonGenerator = new PackageJsonGenerator(dbConfig);
                    await packageJsonGenerator.generatePackageJsonFile();
                    break;
                }

                case "readme": {
                    const readmeGenerator = new ReadmeGenerator(schemaPath, dbConfig);
                    await readmeGenerator.generateReadme();
                    break;
                }

                case "datasource": {
                    const dsGenerator = new DataSourceGenerator(schemaPath, dbConfig);
                    await dsGenerator.generateDataSourceFile();
                    break;
                }

                case "diagram": {
                    const { DiagramGenerator } = await import("./diagram-generator");
                    const diagramGenerator = new DiagramGenerator(schemaPath, dbConfig);
                    await diagramGenerator.generateDiagram();
                    break;
                }

                default: {
                    console.log(`Componente ${component} não reconhecido.`);
                    break;
                }
            }
        }
    }

}

main();
