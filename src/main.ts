#!/usr/bin/env node

import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { execSync } from 'child_process';

const argv = yargs(hideBin(process.argv))
  .option('host', {
    alias: 'h',
    description: 'Host do banco de dados',
    type: 'string',
    demandOption: true,
  })
  .option('port', {
    alias: 'p',
    description: 'Porta do banco de dados',
    type: 'number',
    default: 5432,
  })
  .option('database', {
    alias: 'd',
    description: 'Nome do banco de dados',
    type: 'string',
    demandOption: true,
  })
  .option('user', {
    alias: 'u',
    description: 'Usuário do banco de dados',
    type: 'string',
    demandOption: true,
  })
  .option('password', {
    alias: 'pw',
    description: 'Senha do banco de dados',
    type: 'string',
    demandOption: true,
  })
  .option('outputDir', {
    alias: 'o',
    description: 'Diretório de saída para os arquivos gerados',
    type: 'string',
    default: './build',
  })
  .option('generate', {
    alias: 'g',
    description: 'Especifique quais componentes gerar (entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme)',
    type: 'array',
    choices: ['entities', 'services', 'interfaces', 'controllers', 'dtos', 'modules', 'app-module', 'main', 'env', 'package.json', 'readme'],
    demandOption: true,
  })
  .help()
  .alias('help', 'h')
  .argv;

const dbConfig = {
  host: argv.host,
  port: argv.port,
  database: argv.database,
  user: argv.user,
  password: argv.password,
  outputDir: argv.outputDir,
  generate: argv.generate,
};

console.log("Usando a seguinte configuração de banco de dados:");
console.log(`Host: ${dbConfig.host}`);
console.log(`Port: ${dbConfig.port}`);
console.log(`Database: ${dbConfig.database}`);
console.log(`User: ${dbConfig.user}`);
console.log(`Password: ${dbConfig.password}`);
console.log(`Output Directory: ${dbConfig.outputDir}`);
console.log(`Components to Generate: ${dbConfig.generate.join(', ')}`);

function executeCommand(command: string) {
  try {
    console.log(`Executando: ${command}`);
    execSync(command, { stdio: 'inherit' });
  } catch (error) {
    console.error(`Erro ao executar ${command}:`, error);
    process.exit(1);
  }
}

// Mapeamento das opções de geração para os comandos correspondentes
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

// Executando cada gerador conforme as opções selecionadas
executeCommand(`${commandPrefix} npx ts-node src/db.reader.postgres.ts`);

dbConfig.generate.forEach(component => {
  if (commandsMap[component]) {
    executeCommand(commandsMap[component]);
  } else {
    console.warn(`Componente ${component} não é reconhecido.`);
  }
});