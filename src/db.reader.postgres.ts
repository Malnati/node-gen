
// src/db.reader.postgres.ts

import { Client } from 'pg';
import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig, Table, Column, Relation } from './interfaces';

export class DbReader {
  private config: DbReaderConfig;

  constructor(config: DbReaderConfig) {
    this.config = config;

    // Adicionando logs para verificar os valores recebidos (exceto senha)
    console.log('DbReader Configuration:');
    console.log(`Host: ${this.config.host}`);
    console.log(`Port: ${this.config.port}`);
    console.log(`Database: ${this.config.database}`);
    console.log(`User: ${this.config.user}`);
    console.log('Password: [HIDDEN]');
    console.log(`Output Directory: ${this.config.outputDir}`);
    console.log(`Output File: ${this.config.outputFile}`);
  }

  public async getSchemaInfo() {
    const client = new Client({
      host: this.config.host,
      port: this.config.port,
      database: this.config.database,
      user: this.config.user,
      password: this.config.password,
    });

    try {
      await client.connect();
      console.log('Connected to the database successfully.');

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

      this.saveSchemaInfoToFile(schemaInfo);
    } catch (err) {
      console.error('Erro ao acessar o banco de dados:', err);
    } finally {
      await client.end();
      console.log('Database connection closed.');
    }
  }

  private saveSchemaInfoToFile(schemaInfo: Table[]) {
    if (!fs.existsSync(this.config.outputDir)) {
      fs.mkdirSync(this.config.outputDir, { recursive: true });
    }

    const projectName = this.toCamelCase(this.config.database);

    const filePath = path.join(this.config.outputDir, this.config.outputFile);
    const output = {
      databaseName: this.config.database,
      projectName: projectName,
      schema: schemaInfo,
    };
    fs.writeFileSync(filePath, JSON.stringify(output, null, 2));

    console.log(`Schema information has been saved to ${filePath}`);
  }

  private toCamelCase(str: string): string {
    return str
      .replace(/([-_][a-z])/g, (group) => group.toUpperCase().replace('-', '').replace('_', ''))
      .replace(/(^\w)/, (group) => group.toUpperCase());
  }
}