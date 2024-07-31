#!/usr/bin/env node

require('dotenv').config();
const { Client } = require('pg');
const yargs = require('yargs');

const argv = yargs
  .option('host', {
    alias: 'h',
    description: 'Host do banco de dados',
    type: 'string',
    default: process.env.DB_HOST || 'localhost'
  })
  .option('port', {
    alias: 'p',
    description: 'Porta do banco de dados',
    type: 'number',
    default: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : 5432
  })
  .option('database', {
    alias: 'd',
    description: 'Nome do banco de dados',
    type: 'string',
    default: process.env.DB_NAME
  })
  .option('user', {
    alias: 'u',
    description: 'Usuário do banco de dados',
    type: 'string',
    default: process.env.DB_USER || 'postgres'
  })
  .option('password', {
    alias: 'pw',
    description: 'Senha do banco de dados',
    type: 'string',
    default: process.env.DB_PASSWORD
  })
  .help()
  .alias('help', 'h')
  .argv;

async function getSchemaInfo() {
  const client = new Client({
    host: argv.host,
    port: argv.port,
    database: argv.database,
    user: argv.user,
    password: argv.password
  });

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
        SELECT column_name, data_type, character_maximum_length
        FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = $1
      `;
      const columnsResult = await client.query(columnsQuery, [table]);

      columnsResult.rows.forEach(column => {
        console.log(`  Coluna: ${column.column_name}, Tipo: ${column.data_type}, Tamanho: ${column.character_maximum_length || 'N/A'}`);
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