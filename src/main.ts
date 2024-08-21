#!/usr/bin/env node

import { DbReader } from './db.reader.postgres';
import { ConfigUtil } from './utils/ConfigUtil';
import { execSync } from 'child_process';
import * as readline from 'readline';

const dbConfig = ConfigUtil.getConfig(); // Obtém as configurações do banco de dados

// Log para confirmar os valores capturados
console.log('DbReader Configuration after ConfigUtil.getConfig():');
console.log(`Host: ${dbConfig.host}`);
console.log(`Port: ${dbConfig.port}`);
console.log(`Database: ${dbConfig.database}`);
console.log(`User: ${dbConfig.user}`);
console.log('Password: [HIDDEN]');
console.log(`Output Directory: ${dbConfig.outputDir}`);
console.log(`Output File: ${dbConfig.outputFile}`);

const dbReader = new DbReader(dbConfig); // Passa as configurações para o DbReader
dbReader.getSchemaInfo(); // Executa o método para obter o schema e gerar o arquivo

// Função para perguntar ao usuário quais componentes deseja gerar
function askQuestion(query: string): Promise<string> {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  return new Promise((resolve) => rl.question(query, (ans) => {
    rl.close();
    resolve(ans);
  }));
}

async function main() {
  const componentsToGenerate = await askQuestion(
    'Especifique quais componentes gerar (entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme): '
  );

  const components = componentsToGenerate.split(',').map(component => component.trim().toLowerCase());

  // Mapeamento das opções para os comandos correspondentes
  const commandsMap: { [key: string]: string } = {
    'entities': `npx ts-node src/typeorm-entity-generator.ts`,
    'services': `npx ts-node src/service-generator.ts`,
    'interfaces': `npx ts-node src/interface-generator.ts`,
    'controllers': `npx ts-node src/controller-generator.ts`,
    'dtos': `npx ts-node src/dto-generator.ts`,
    'modules': `npx ts-node src/module-generator.ts`,
    'app-module': `npx ts-node src/app-module-generator.ts`,
    'main': `npx ts-node src/main-generator.ts`,
    'env': `npx ts-node src/env-generator.ts`,
    'package.json': `npx ts-node src/package-json-generator.ts`,
    'readme': `npx ts-node src/readme-generator.ts`,
  };

  for (const component of components) {
    const command = commandsMap[component];
    if (command) {
      console.log(`Executando comando para ${component}: ${command}`);
      execSync(command, { stdio: 'inherit' });
    } else {
      console.log(`Componente ${component} não reconhecido.`);
    }
  }
}

main();