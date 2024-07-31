#!/usr/bin/env node

import { config as dotenvConfig } from 'dotenv';
import { Client } from 'pg';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { Table, Column, Relation } from './interfaces'; // Import the interfaces

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
  .help()
  .alias('help', 'h')
  .argv as {
    host?: string;
    port?: number;
    database?: string;
    user?: string;
    password?: string;
  };

const dbConfig = {
  host: argv.host || process.env.DB_HOST,
  port: argv.port || parseInt(process.env.DB_PORT || '5432', 10),
  database: argv.database || process.env.DB_NAME,
  user: argv.user || process.env.DB_USER,
  password: argv.password || process.env.DB_PASSWORD
};

console.log("Using the following database configuration:");
console.log(`Host: ${dbConfig.host}`);
console.log(`Port: ${dbConfig.port}`);
console.log(`Database: ${dbConfig.database}`);
console.log(`User: ${dbConfig.user}`);
console.log(`Password: ${dbConfig.password}`);

async function getSchemaInfo() {
  const client = new Client(dbConfig);

  await client.connect();

  try {
    const tablesQuery = `
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = 'public'
    `;
    const tablesResult = await client.query(tablesQuery);
    const tables = tablesResult.rows.map(row => row.table_name);

    const schemaInfo: Table[] = [];

    for (const tableName of tables) {
      const columnsQuery = `
        SELECT 
          c.column_name, 
          c.data_type, 
          c.character_maximum_length, 
          c.is_nullable, 
          c.column_default,
          pgd.description AS column_comment
        FROM 
          information_schema.columns c
        LEFT JOIN 
          pg_catalog.pg_statio_all_tables as st on c.table_schema = st.schemaname and c.table_name = st.relname
        LEFT JOIN 
          pg_catalog.pg_description pgd on pgd.objoid = st.relid and pgd.objsubid = c.ordinal_position
        WHERE 
          c.table_schema = 'public' AND c.table_name = $1
      `;
      const columnsResult = await client.query(columnsQuery, [tableName]);

      const columns: Column[] = columnsResult.rows.map((column: any) => ({
        columnName: column.column_name,
        dataType: column.data_type,
        characterMaximumLength: column.character_maximum_length,
        isNullable: column.is_nullable === 'YES',
        columnDefault: column.column_default,
        columnComment: column.column_comment,
      }));

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
      const relationsResult = await client.query(relationsQuery, [tableName]);

      const relations: Relation[] = relationsResult.rows.map((relation: any) => ({
        columnName: relation.column_name,
        foreignTableName: relation.foreign_table_name,
        foreignColumnName: relation.foreign_column_name,
      }));

      schemaInfo.push({ tableName, columns, relations });
    }

    printSchemaInfo(schemaInfo);
  } catch (err) {
    console.error('Erro ao acessar o banco de dados:', err);
  } finally {
    await client.end();
  }
}

function printSchemaInfo(schemaInfo: Table[]) {
  for (const table of schemaInfo) {
    console.log(`\nTabela: ${table.tableName}`);
    for (const column of table.columns) {
      console.log(`  Coluna: ${column.columnName}, Tipo: ${column.dataType}, Tamanho: ${column.characterMaximumLength || 'N/A'}, Obrigatório: ${column.isNullable ? 'Não' : 'Sim'}, Valor Padrão: ${column.columnDefault || 'N/A'}, Comentário: ${column.columnComment || 'N/A'}`);
    }
    for (const relation of table.relations) {
      console.log(`  Relação: ${relation.columnName} -> ${relation.foreignTableName}(${relation.foreignColumnName})`);
    }
  }
}

getSchemaInfo();