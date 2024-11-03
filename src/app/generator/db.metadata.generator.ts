// src/db.reader.ts

import * as fs from 'fs';
import { Client as PgClient } from 'pg';
import mysql, { RowDataPacket } from 'mysql2/promise';
import { IDbReaderConfig, ITable, IColumn, IRelation } from './interfaces';
import { formatAttributeName, mapDatabaseTypeToJsType, toCamelCase, toPascalCase, toSlugCase } from './db.reader.util';

type DatabaseType = 'postgres' | 'mysql';

export class DbReader {
  private config: IDbReaderConfig;
  private schemaPath: string;
  private dbType: DatabaseType;

  constructor(schemaPath: string, config: IDbReaderConfig, dbType: DatabaseType) {
    this.config = config;
    this.schemaPath = schemaPath;
    this.dbType = dbType;
  }

  public async getSchemaInfo() {
    console.log(`Connecting to the ${this.dbType} database...`);

    if (this.dbType === 'postgres') {
      await this.connectPostgres();
    } else if (this.dbType === 'mysql') {
      await this.connectMysql();
    } else {
      throw new Error(`Database type ${this.dbType} is not supported.`);
    }
  }

  private async connectPostgres() {
    const client = new PgClient({
      host: this.config.host,
      port: this.config.port,
      database: this.config.database,
      user: this.config.user,
      password: this.config.password,
    });

    try {
      await client.connect();
      console.log('Connected to the Postgres database successfully.');
      const tablesQuery = `SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'`;
      const tablesResult = await client.query<{ table_name: string }>(tablesQuery);
      const tables = tablesResult.rows.map(row => row.table_name);
      const schemaInfo = await this.getTableSchemas(tables, client);
      this.saveSchemaInfoToFile(schemaInfo);
    } catch (err) {
      console.error('Error accessing the Postgres database:', err);
    } finally {
      await client.end();
      console.log('Postgres database connection closed.');
    }
  }

  private async connectMysql() {
    const connection = await mysql.createConnection({
      host: this.config.host,
      port: this.config.port,
      database: this.config.database,
      user: this.config.user,
      password: this.config.password,
    });

    try {
      console.log('Connected to the MySQL database successfully.');
      const [tablesResult] = await connection.query<RowDataPacket[]>(`
        SELECT TABLE_NAME FROM information_schema.tables WHERE table_schema = ?
      `, [this.config.database]);
      const tables = tablesResult.map((row: any) => row.TABLE_NAME);
      const schemaInfo = await this.getTableSchemas(tables, connection);
      this.saveSchemaInfoToFile(schemaInfo);
    } catch (err) {
      console.error('Error accessing the MySQL database:', err);
    } finally {
      await connection.end();
      console.log('MySQL database connection closed.');
    }
  }

  private async getTableSchemas(tables: string[], connection: PgClient | mysql.Connection) {
    const schemaInfo: ITable[] = [];
    for (const tableName of tables) {
      const columns = await this.getColumns(connection, tableName);
      const relations = await this.getRelations(connection, tableName);
      const entityName = toPascalCase(tableName);
      const slugName = toSlugCase(tableName);
      schemaInfo.push({ tableName, entityName, slugName, columns, relations });
    }
    return schemaInfo;
  }

  private async getColumns(connection: PgClient | mysql.Connection, tableName: string): Promise<IColumn[]> {
    const query = this.dbType === 'postgres'
      ? `
        SELECT
          c.column_name,
          c.data_type,
          c.character_maximum_length,
          c.is_nullable,
          c.column_default,
          pgd.description AS column_comment,
          (SELECT EXISTS (
            SELECT 1
            FROM information_schema.table_constraints tc
            JOIN information_schema.key_column_usage kcu
            ON tc.constraint_name = kcu.constraint_name
            AND tc.table_schema = kcu.table_schema
            WHERE tc.constraint_type = 'PRIMARY KEY'
            AND tc.table_name = c.table_name
            AND kcu.column_name = c.column_name
          )) AS is_primary_key
        FROM
          information_schema.columns c
        LEFT JOIN
          pg_catalog.pg_statio_all_tables as st on c.table_schema = st.schemaname and c.table_name = st.relname
        LEFT JOIN
          pg_catalog.pg_description pgd on pgd.objoid = st.relid and pgd.objsubid = c.ordinal_position
        WHERE
          c.table_schema = 'public' AND c.table_name = $1
      `
      : `
        SELECT
          COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT, COLUMN_KEY
        FROM information_schema.columns
        WHERE table_schema = ? AND table_name = ?
      `;

    const columnsResult = this.dbType === 'postgres'
      ? await (connection as PgClient).query(query, [tableName])
      : await (connection as mysql.Connection).query<RowDataPacket[]>(query, [this.config.database, tableName]);

    return (columnsResult as any).rows.map((column: any) => ({
      columnName: column.column_name || column.COLUMN_NAME,
      attributeName: formatAttributeName(column.column_name || column.COLUMN_NAME),
      dataType: column.data_type || column.DATA_TYPE,
      type: mapDatabaseTypeToJsType(column.data_type || column.DATA_TYPE),
      characterMaximumLength: column.character_maximum_length || column.CHARACTER_MAXIMUM_LENGTH,
      isNullable: (column.is_nullable || column.IS_NULLABLE) === 'YES',
      isPrimaryKey: column.is_primary_key || column.COLUMN_KEY === 'PRI',
      columnDefault: column.column_default || column.COLUMN_DEFAULT,
      columnComment: column.column_comment || column.COLUMN_COMMENT
    }));
  }

  private async getRelations(connection: PgClient | mysql.Connection, tableName: string): Promise<IRelation[]> {
    const query = this.dbType === 'postgres'
      ? `
        SELECT
          kcu.column_name,
          ccu.table_name AS foreign_table_name,
          ccu.column_name AS foreign_column_name,
          tc.constraint_type AS relation_type,
          (SELECT COUNT(*) = 1
           FROM information_schema.table_constraints tc2
           JOIN information_schema.key_column_usage kcu2
           ON tc2.constraint_name = kcu2.constraint_name
           AND tc2.table_schema = kcu2.table_schema
           WHERE tc2.table_name = kcu.table_name
           AND kcu2.column_name = kcu.column_name
           AND tc2.constraint_type = 'UNIQUE') AS is_unique_constraint,
          (SELECT COUNT(*) > 0
           FROM information_schema.table_constraints tc2
           JOIN information_schema.key_column_usage kcu2
           ON tc2.constraint_name = kcu2.constraint_name
           AND tc2.table_schema = kcu2.table_schema
           WHERE tc2.table_name = kcu.table_name
           AND kcu2.column_name = kcu.column_name
           AND tc2.constraint_type = 'PRIMARY KEY') AS is_primary_key_constraint
        FROM
          information_schema.table_constraints AS tc
        JOIN information_schema.key_column_usage AS kcu
          ON tc.constraint_name = kcu.constraint_name
          AND tc.table_schema = kcu.table_schema
        JOIN information_schema.constraint_column_usage AS ccu
          ON ccu.constraint_name = tc.constraint_name
        WHERE
          tc.constraint_type = 'FOREIGN KEY'
          AND tc.table_name = $1;
      `
      : `
        SELECT
          COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
        FROM information_schema.key_column_usage
        WHERE table_schema = ?
          AND table_name = ?
          AND REFERENCED_TABLE_NAME IS NOT NULL
      `;

    const relationsResult = this.dbType === 'postgres'
      ? await (connection as PgClient).query(query, [tableName])
      : await (connection as mysql.Connection).query<RowDataPacket[]>(query, [this.config.database, tableName]);

    return (relationsResult as any).rows.map((relation: any) => ({
      columnName: relation.column_name || relation.COLUMN_NAME,
      attributeName: formatAttributeName(relation.column_name || relation.COLUMN_NAME),
      foreignTableName: relation.foreign_table_name || relation.REFERENCED_TABLE_NAME,
      foreignColumnName: relation.foreign_column_name || relation.REFERENCED_COLUMN_NAME,
      relationType: 'ManyToOne'
    }));
  }

  private saveSchemaInfoToFile(schemaInfo: ITable[]) {
    if (!fs.existsSync(this.config.outputDir)) {
      fs.mkdirSync(this.config.outputDir, { recursive: true });
    }

    const filePath = this.schemaPath;
    const output = {
      databaseName: this.config.database,
      projectName: toCamelCase(this.config.database),
      schema: schemaInfo,
      host: this.config.host,
      port: this.config.port,
      user: this.config.user,
      password: this.config.password,
    };
    fs.writeFileSync(filePath, JSON.stringify(output, null, 2));

    console.log(`Schema information has been saved to ${filePath}`);
  }
}
