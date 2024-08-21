#!/usr/bin/env node

import path from "path";
import * as readline from "readline";
import { DbReader } from "./db.reader.postgres";
import { ConfigUtil } from "./utils/ConfigUtil";
import { TypeORMEntityGenerator } from "./typeorm-entity-generator";

const dbConfig = ConfigUtil.getConfig(); // Obtém as configurações do banco de dados

// Log para confirmar os valores capturados
console.log("DbReader Configuration after ConfigUtil.getConfig():");
console.log(`Host: ${dbConfig.host}`);
console.log(`Port: ${dbConfig.port}`);
console.log(`Database: ${dbConfig.database}`);
console.log(`User: ${dbConfig.user}`);
console.log("Password: [HIDDEN]");
console.log(`Output Directory: ${dbConfig.outputDir}`);
console.log(`Components: ${dbConfig.components}`);

const dbReader = new DbReader(dbConfig); // Passa as configurações para o DbReader
dbReader.getSchemaInfo(); // Executa o método para obter o schema e gerar o arquivo

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
  const componentsToGenerate = await askQuestion(
    "Especifique quais componentes gerar (entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme): "
  );
  const components = componentsToGenerate
    .split(",")
    .map((component) => component.trim().toLowerCase());

  // Define o caminho para o schema
  const schemaPath = path.join(dbConfig.outputDir, "db.reader.postgres.json");

  for (const component of components) {
    const command = component;
    if (command) {
      console.log(`Executando comando para ${component}: ${command}`);
      if (command === "entities") {
        // Cria uma instância do gerador de entidades passando o schema e as configurações
        const entityGenerator = new TypeORMEntityGenerator(
          schemaPath,
          dbConfig
        );
        // Gera as entidades
        entityGenerator.generateEntities();
      }
    } else {
      console.log(`Componente ${component} não reconhecido.`);
    }
}
}

main();
