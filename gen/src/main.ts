// gen/src/main.ts
import path from "path";
import { execSync } from "child_process";
import * as readline from "readline";
import { DbReader } from "./db.reader.postgres";
import { ConfigUtil } from "./utils/ConfigUtil";
import { MicrofrontendGenerator } from "./microfrontend-generator";
import { AppShellGenerator } from "./appshell-generator";
import { MFEParcelPagingGenerator } from "./mfe-parcel-paging-generator";
import { SspaStaticAssetsGenerator } from "./sspa-static-assets-generator";
// API Generators
import { ApiEntityGenerator } from "./api-entity-generator";
import { ApiServiceGenerator } from "./api-service-generator";
import { ApiControllerGenerator } from "./api-controller-generator";
import { ApiDTOGenerator } from "./api-dto-generator";
import { ApiModuleGenerator } from "./api-module-generator";
import { ApiAppModuleGenerator } from "./api-app-module-generator";
import { ApiMainGenerator } from "./api-main-generator";
import { ApiDataSourceGenerator } from "./api-datasource-generator";
import { ApiInterfaceGenerator } from "./api-interface-generator";
import { ApiReadmeGenerator } from "./api-readme-generator";
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

async function copyStaticApiFiles(destDir: string, templateDir?: string) {
    await copyStaticComponentFiles({
        destDir,
        outputSubDir: ".",
        staticComponentDirName: "api",
        templateDir,
        fallbackStaticDirName: "static-api",
        successMessage: "Arquivos estáticos API copiados com sucesso.",
        errorMessage: "Erro ao copiar arquivos estáticos API:",
    });
}

async function copyStaticParcelPagingFiles(destDir: string, templateDir?: string) {
    await copyStaticComponentFiles({
        destDir,
        outputSubDir: path.join("frontend", "mfe-parcel-paging"),
        staticComponentDirName: "mfe-parcel-paging",
        templateDir,
        successMessage: "Arquivos estáticos MFE Parcel Paging copiados com sucesso.",
        errorMessage: "Erro ao copiar arquivos estáticos MFE Parcel Paging:",
    });
}

async function copyStaticComponentFiles(params: {
    destDir: string;
    outputSubDir: string;
    staticComponentDirName: string;
    templateDir?: string;
    fallbackStaticDirName?: string;
    successMessage: string;
    errorMessage: string;
}) {
    try {
        const {
            destDir,
            outputSubDir,
            staticComponentDirName,
            templateDir,
            fallbackStaticDirName,
            successMessage,
            errorMessage,
        } = params;
        const staticPathCandidates = [
            ...(templateDir ? [
                path.resolve(templateDir, staticComponentDirName),
                path.resolve(templateDir, "..", "static", staticComponentDirName),
                ...(fallbackStaticDirName ? [path.resolve(templateDir, "..", fallbackStaticDirName)] : []),
            ] : []),
            path.resolve(__dirname, "..", "static", staticComponentDirName),
            ...(fallbackStaticDirName ? [path.resolve(__dirname, "..", fallbackStaticDirName)] : []),
        ];
        const staticSourcePath = staticPathCandidates.find((candidate) => fs.existsSync(candidate));
        if (!staticSourcePath) {
            throw new Error(`Static source not found for '${staticComponentDirName}' in: ${staticPathCandidates.join(", ")}`);
        }

        const outputDir = path.join(destDir, outputSubDir);
        await fs.copy(staticSourcePath, outputDir, {
            overwrite: true,
        });
        console.log(successMessage);
    } catch (err) {
        console.error(params.errorMessage, err);
    }
}

function ensureGitRepo(outputDir: string): void {
    const gitDir = path.join(outputDir, ".git");
    if (fs.existsSync(gitDir)) {
        return;
    }
    try {
        execSync("git init", { cwd: outputDir, stdio: "pipe" });
        execSync("git config user.email \"gen@local\"", { cwd: outputDir, stdio: "pipe" });
        execSync("git config user.name \"gen\"", { cwd: outputDir, stdio: "pipe" });
        execSync("git add .", { cwd: outputDir, stdio: "pipe" });
        execSync("git commit -m \"Initial generated\"", { cwd: outputDir, stdio: "pipe" });
    } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        console.warn("[gen] Git repo init skipped (non-fatal):", msg);
    }
}

async function main() {
    await copyStaticApiFiles(dbConfig.outputDir, dbConfig.templateDir);
    await copyStaticParcelPagingFiles(dbConfig.outputDir, dbConfig.templateDir);
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
            "(api-entities, api-services, api-interfaces, api-controllers, api-dtos, api-modules, api-app-module, api-main, api-datasource, api-readme, mfes, mfe-parcel-paging, app-shell, sspa-static-assets): "
        );
        components = response.replace("\"", "")
        .split(",")
        .map((c) => c.trim().toLowerCase());
    }

    let mfeConfigs: import('./microfrontend-generator').MFEConfig[] = [];

    for (const component of components) {
        if (component) {
            console.log(`Executando comando para ${component}`);
            switch (component) {
                // MFE Components
                case "mfes": {
                    const mfeGenerator = new MicrofrontendGenerator(schemaPath, dbConfig);
                    mfeConfigs = await mfeGenerator.generate();
                    break;
                }

                case "app-shell": {
                    if (mfeConfigs.length === 0) {
                        const mfeGenerator = new MicrofrontendGenerator(schemaPath, dbConfig);
                        mfeConfigs = await mfeGenerator.generate();
                    }
                    const appShellGenerator = new AppShellGenerator(dbConfig);
                    appShellGenerator.generate(mfeConfigs);
                    break;
                }

                case "mfe-parcel-paging": {
                    const pagingGenerator = new MFEParcelPagingGenerator(schemaPath, dbConfig);
                    await pagingGenerator.generate();
                    break;
                }

                case "sspa-static-assets": {
                    const staticAssetsGenerator = new SspaStaticAssetsGenerator();
                    staticAssetsGenerator.sync();
                    break;
                }

                // API Components
                case "api-entities": {
                    const entityGenerator = new ApiEntityGenerator(schemaPath, dbConfig);
                    await entityGenerator.generateEntities();
                    break;
                }

                case "api-services": {
                    const serviceGenerator = new ApiServiceGenerator(schemaPath, dbConfig);
                    await serviceGenerator.generateServices();
                    break;
                }

                case "api-interfaces": {
                    const interfaceGenerator = new ApiInterfaceGenerator(schemaPath, dbConfig);
                    await interfaceGenerator.generateInterfaces();
                    break;
                }

                case "api-controllers": {
                    const controllersGenerator = new ApiControllerGenerator(schemaPath, dbConfig);
                    await controllersGenerator.generateControllers();
                    break;
                }

                case "api-dtos": {
                    const dtosGenerator = new ApiDTOGenerator(schemaPath, dbConfig);
                    await dtosGenerator.generateDTOs();
                    break;
                }

                case "api-modules": {
                    const modulesGenerator = new ApiModuleGenerator(schemaPath, dbConfig);
                    await modulesGenerator.generateModules();
                    break;
                }

                case "api-app-module": {
                    const appModuleGenerator = new ApiAppModuleGenerator(schemaPath, dbConfig);
                    await appModuleGenerator.generateAppModule();
                    break;
                }

                case "api-main": {
                    const mainGenerator = new ApiMainGenerator(dbConfig);
                    await mainGenerator.generateMainFile();
                    break;
                }

                case "api-datasource": {
                    const dsGenerator = new ApiDataSourceGenerator(schemaPath, dbConfig);
                    await dsGenerator.generateDataSourceFile();
                    break;
                }

                case "api-readme": {
                    const readmeGenerator = new ApiReadmeGenerator(schemaPath, dbConfig);
                    await readmeGenerator.generateReadme();
                    break;
                }

                default: {
                    console.log(`Componente ${component} não reconhecido.`);
                    break;
                }
            }
        }
    }

    ensureGitRepo(dbConfig.outputDir);
}

main();
