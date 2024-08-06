#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { config as dotenvConfig } from 'dotenv';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { Table } from './interfaces';

dotenvConfig();

// Debugging section to check environment variables
console.log("Environment Variables:");
console.log(`DB_HOST: ${process.env.DB_HOST}`);
console.log(`DB_PORT: ${process.env.DB_PORT}`);
console.log(`DB_NAME: ${process.env.DB_NAME}`);
console.log(`DB_USER: ${process.env.DB_USER}`);
console.log(`DB_PASSWORD: ${process.env.DB_PASSWORD}`);

const argv = yargs(hideBin(process.argv))
  .option('host', {
    alias: 'h',
    description: 'Host do banco de dados',
    type: 'string'
  })
  .option('port', {
    alias: 'p',
    description: 'Porta do banco de dados',
    type: 'number'
  })
  .option('database', {
    alias: 'd',
    description: 'Nome do banco de dados',
    type: 'string'
  })
  .option('user', {
    alias: 'u',
    description: 'Usuário do banco de dados',
    type: 'string'
  })
  .option('password', {
    alias: 'pw',
    description: 'Senha do banco de dados',
    type: 'string'
  })
  .option('microserviceName', {
    alias: 'ms',
    description: 'Nome do microserviço',
    type: 'string'
  })
  .help()
  .alias('help', 'h')
  .argv as {
    host?: string;
    port?: number;
    database?: string;
    user?: string;
    password?: string;
    microserviceName?: string;
  };

const dbConfig = {
  host: argv.host || process.env.DB_HOST,
  port: argv.port || parseInt(process.env.DB_PORT || '5432', 10),
  database: argv.database || process.env.DB_NAME,
  user: argv.user || process.env.DB_USER,
  password: argv.password || process.env.DB_PASSWORD
};

const microserviceName = argv.microserviceName || 'Default Microservice Name';

console.log("Using the following database configuration:");
console.log(`Host: ${dbConfig.host}`);
console.log(`Port: ${dbConfig.port}`);
console.log(`Database: ${dbConfig.database}`);
console.log(`User: ${dbConfig.user}`);
console.log(`Password: ${dbConfig.password}`);
console.log(`Microservice Name: ${microserviceName}`);

function generateEnvFile() {
  const envConfig = {
    DATABASE_HOST: dbConfig.host,
    DATABASE_PORT: dbConfig.port.toString(),
    DATABASE_NAME: dbConfig.database,
    DATABASE_USER: dbConfig.user,
    DATABASE_PASSWORD: dbConfig.password,
    ENDPOINT_SESSION_TOKEN: 'https://biud-microservice-session.dev.biud.services/session/verify',
    ENDPOINT_SESSION_HEALTHCHECK: 'https://biud-microservice-session.dev.biud.services/health',
    MICROSERVICE_NAME: microserviceName,
    PORT: '3001'
  };

  const envFileContent = Object.entries(envConfig)
    .map(([key, value]) => `${key}='${value}'`)
    .join('\n');

  const buildDir = path.join(__dirname, 'build');
  if (!fs.existsSync(buildDir)) {
    fs.mkdirSync(buildDir, { recursive: true });
  }

  const filePath = path.join(buildDir, '.env');
  fs.writeFileSync(filePath, envFileContent);

  console.log(`.env file has been generated in ${buildDir}`);
}

generateEnvFile();