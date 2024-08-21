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
  .help()
  .alias('help', 'h')
  .argv;

const dbConfig = {
  host: argv.host,
  port: argv.port,
  database: argv.database,
  user: argv.user,
  password: argv.password,
};

console.log("Usando a seguinte configuração de banco de dados:");
console.log(`Host: ${dbConfig.host}`);
console.log(`Port: ${dbConfig.port}`);
console.log(`Database: ${dbConfig.database}`);
console.log(`User: ${dbConfig.user}`);
console.log(`Password: ${dbConfig.password}`);

function executeCommand(command: string) {
  try {
    console.log(`Executando: ${command}`);
    execSync(command, { stdio: 'inherit' });
  } catch (error) {
    console.error(`Erro ao executar ${command}:`, error);
    process.exit(1);
  }
}

// Executando a sequência de geradores com os parâmetros fornecidos
const commandPrefix = `DB_HOST=${dbConfig.host} DB_PORT=${dbConfig.port} DB_NAME=${dbConfig.database} DB_USER=${dbConfig.user} DB_PASSWORD='${dbConfig.password}'`;

executeCommand(`${commandPrefix} npx ts-node src/db.reader.postgres.ts`);
executeCommand(`npx ts-node src/typeorm-entity-generator.ts`);
executeCommand(`npx ts-node src/service-generator.ts`);
executeCommand(`npx ts-node src/interface-generator.ts`);
executeCommand(`npx ts-node src/controller-generator.ts`);
executeCommand(`npx ts-node src/dto-generator.ts`);
executeCommand(`npx ts-node src/module-generator.ts`);
executeCommand(`npx ts-node src/app-module-generator.ts`);
executeCommand(`npx ts-node src/main-generator.ts`);
executeCommand(`npx ts-node src/env-generator.ts`);
executeCommand(`npx ts-node src/package-json-generator.ts`);
executeCommand(`npx ts-node src/readme-generator.ts`);