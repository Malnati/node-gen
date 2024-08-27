// src/db.reader.postgres.ts

import { Client } from 'pg';
import * as fs from 'fs';
import { DbReaderConfig, Table, Column, Relation } from './interfaces';

export class DbReader {
  private config: DbReaderConfig;
  private schemaPath: string;

  constructor(schemaPath: string, config: DbReaderConfig) {
    this.config = config;
    this.schemaPath = schemaPath;
  }

  public async getSchemaInfo() {
    console.log('Connecting to the database...');
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
      const tablesResult = await client.query<{ table_name: string }>(tablesQuery);
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
	  `;
        const columnsResult = await client.query<{
          column_name: string;
          data_type: string;
          character_maximum_length: number | null;
          is_nullable: 'YES' | 'NO';
		  is_primary_key: boolean;
          column_default: string | null;
          column_comment: string | null;
        }>(columnsQuery, [tableName]);

        const columns: Column[] = columnsResult.rows.map(column => ({
			columnName: column.column_name,
			dataType: column.data_type,
			characterMaximumLength: column.character_maximum_length,
			isNullable: column.is_nullable === 'YES',
			isPrimaryKey: column.is_primary_key,
			columnDefault: column.column_default,
			columnComment: column.column_comment
		  }));

        const relationsQuery = `
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
        `;
        const relationsResult = await client.query<{
          column_name: string;
          foreign_table_name: string;
          foreign_column_name: string;
          relation_type: string;
          is_unique_constraint: boolean;
          is_primary_key_constraint: boolean;
        }>(relationsQuery, [tableName]);

        const relations: Relation[] = relationsResult.rows.map(relation => ({
          columnName: relation.column_name,
          foreignTableName: relation.foreign_table_name,
          foreignColumnName: relation.foreign_column_name,
          relationType: this.determineRelationType(relation.is_unique_constraint, relation.is_primary_key_constraint)
        }));

        schemaInfo.push({ tableName, columns, relations });
      }

      this.saveSchemaInfoToFile(schemaInfo);
    } catch (err) {
      console.error('Error accessing the database:', err);
    } finally {
      await client.end();
      console.log('Database connection closed.');
    }
  }

  private determineRelationType(isUnique: boolean, isPrimaryKey: boolean): 'ManyToOne' | 'OneToOne' | 'OneToMany' | 'ManyToMany' {
    if (isUnique || isPrimaryKey) {
      return 'OneToOne';
    }

    return 'ManyToOne';
  }

  private saveSchemaInfoToFile(schemaInfo: Table[]) {
    if (!fs.existsSync(this.config.outputDir)) {
      fs.mkdirSync(this.config.outputDir, { recursive: true });
    }

    const projectName = this.toCamelCase(this.config.database);

    const filePath = this.schemaPath;
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
      .replace(/([-_][a-z])/g, group => group.toUpperCase().replace('-', '').replace('_', ''))
      .replace(/(^\w)/, group => group.toUpperCase());
  }
}
