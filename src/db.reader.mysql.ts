import mysql, { RowDataPacket } from 'mysql2/promise';
import * as fs from 'fs';
import { DbReaderConfig, Table, Column, Relation } from './interfaces';

export class DbReaderMysql {
  private config: DbReaderConfig;
  private schemaPath: string;

  constructor(schemaPath: string, config: DbReaderConfig) {
    this.config = config;
    this.schemaPath = schemaPath;
  }

  public async getSchemaInfo() {
    console.log('Connecting to the MySQL database...');
    const connection = await mysql.createConnection({
      host: this.config.host,
      port: this.config.port,
      database: this.config.database,
      user: this.config.user,
      password: this.config.password,
    });

    try {
      console.log('Connected to the MySQL database successfully.');

      // Corrigindo o tipo para RowDataPacket[]
      const [tablesResult] = await connection.query<RowDataPacket[]>(`
        SELECT TABLE_NAME 
        FROM information_schema.tables 
        WHERE table_schema = ?
      `, [this.config.database]);

      // Mapear as tabelas corretamente
      const tables = tablesResult.map((row: any) => row.TABLE_NAME);
      const schemaInfo: Table[] = [];

      for (const tableName of tables) {
        const [columnsResult] = await connection.query<RowDataPacket[]>(`
          SELECT 
            COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT, COLUMN_KEY 
          FROM information_schema.columns 
          WHERE table_schema = ? AND table_name = ?
        `, [this.config.database, tableName]);

        const columns: Column[] = columnsResult.map((column: any) => ({
          columnName: column.COLUMN_NAME,
          dataType: column.DATA_TYPE,
          characterMaximumLength: column.CHARACTER_MAXIMUM_LENGTH,
          isNullable: column.IS_NULLABLE === 'YES',
          isPrimaryKey: column.COLUMN_KEY === 'PRI',
          columnDefault: column.COLUMN_DEFAULT,
          columnComment: column.COLUMN_COMMENT
        }));

        const [relationsResult] = await connection.query<RowDataPacket[]>(`
          SELECT 
            COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
          FROM information_schema.key_column_usage 
          WHERE table_schema = ? 
            AND table_name = ? 
            AND REFERENCED_TABLE_NAME IS NOT NULL
        `, [this.config.database, tableName]);

        const relations: Relation[] = relationsResult.map((relation: any) => ({
          columnName: relation.COLUMN_NAME,
          foreignTableName: relation.REFERENCED_TABLE_NAME,
          foreignColumnName: relation.REFERENCED_COLUMN_NAME,
          relationType: 'ManyToOne', // Por padrão, muitas chaves estrangeiras são ManyToOne
        }));

        schemaInfo.push({ tableName, columns, relations });
      }

      this.saveSchemaInfoToFile(schemaInfo);
    } catch (err) {
      console.error('Error accessing the MySQL database:', err);
    } finally {
      await connection.end();
      console.log('MySQL database connection closed.');
    }
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
