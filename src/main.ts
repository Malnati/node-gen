#!/usr/bin/env node

import { DbReader } from './db.reader.postgres';
import { ConfigUtil } from './utils/ConfigUtil';

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