#!/usr/bin/env node

require('dotenv').config();
const { Client } = require('pg');
const yargs = require('yargs');

// Debugging section to check environment variables
console.log("Environment Variables:");
console.log(`DB_HOST: ${process.env.DB_HOST}`);
console.log(`DB_PORT: ${process.env.DB_PORT}`);
console.log(`DB_NAME: ${process.env.DB_NAME}`);
console.log(`DB_USER: ${process.env.DB_USER}`);
console.log(`DB_PASSWORD: ${process.env.DB_PASSWORD}`);

const argv = yargs
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
  .help()
  .alias('help', 'h')
  .argv;

const config = {
  host: argv.host || process.env.DB_HOST,
  port: argv.port || process.env.DB_PORT,
  database: argv.database || process.env.DB_NAME,
  user: argv.user || process.env.DB_USER,
  password: argv.password || process.env.DB_PASSWORD
};

console.log("Using the following database configuration:");
console.log(`Host: ${config.host}`);
console.log(`Port: ${config.port}`);
console.log(`Database: ${config.database}`);
console.log(`User: ${config.user}`);
console.log(`Password: ${config.password}`);

async function getSchemaInfo() {
  const client = new Client(config);

  await client.connect();

  try {
    const tablesQuery = `
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = 'public'
    `;
    const tablesResult = await client.query(tablesQuery);
    const tables = tablesResult.rows.map(row => row.table_name);

    for (const table of tables) {
      console.log(`\nTabela: ${table}`);

      const columnsQuery = `
        SELECT 
          column_name, 
          data_type, 
          character_maximum_length, 
          is_nullable, 
          column_default,
          col_description(format('%s.%s', table_name, column_name)::regclass, ordinal_position) AS column_comment
        FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = $1
      `;
      const columnsResult = await client.query(columnsQuery, [table]);

      columnsResult.rows.forEach(column => {
        console.log(`  Coluna: ${column.column_name}, Tipo: ${column.data_type}, Tamanho: ${column.character_maximum_length || 'N/A'}, Obrigatório: ${column.is_nullable === 'NO' ? 'Sim' : 'Não'}, Valor Padrão: ${column.column_default || 'N/A'}, Comentário: ${column.column_comment || 'N/A'}`);
      });

      const relationsQuery = `
        SELECT
          kcu.column_name,
          ccu.table_name AS foreign_table_name,
          ccu.column_name AS foreign_column_name
        FROM
          information_schema.table_constraints AS tc
          JOIN information_schema.key_column_usage AS kcu
          ON tc.constraint_name = kcu.constraint_name
          AND tc.table_schema = kcu.table_schema
          JOIN information_schema.constraint_column_usage AS ccu
          ON ccu.constraint_name = tc.constraint_name
        WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name=$1;
      `;
      const relationsResult = await client.query(relationsQuery, [table]);

      relationsResult.rows.forEach(relation => {
        console.log(`  Relação: ${relation.column_name} -> ${relation.foreign_table_name}(${relation.foreign_column_name})`);
      });
    }
  } catch (err) {
    console.error('Erro ao acessar o banco de dados:', err);
  } finally {
    await client.end();
  }
}

getSchemaInfo();