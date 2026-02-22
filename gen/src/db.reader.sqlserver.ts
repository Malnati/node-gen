// /src/db.reader.sqlserver.ts
import mssql from 'mssql'
import * as fs from 'fs'
import { DbReaderConfig, Table, Column, Relation } from './interfaces'

export class DbReaderSqlServer {
  private config: DbReaderConfig
  private schemaPath: string

  constructor(schemaPath: string, config: DbReaderConfig) {
    this.config = config
    this.schemaPath = schemaPath
  }

  public async getSchemaInfo() {
    console.log('Connecting to the SQLServer database...')
    const pool = await mssql.connect({
      user: this.config.user,
      password: this.config.password,
      server: this.config.host,
      port: this.config.port,
      database: this.config.database,
      options: { encrypt: true, trustServerCertificate: true },
    })

    try {
      console.log('Connected to the SQLServer database successfully.')

      const currentDbResult = await pool.request().query('SELECT DB_NAME() AS name')
      const currentDb = currentDbResult.recordset?.[0]?.name
      console.log('SQLServer current database:', currentDb)

      const tablesResult = await pool
        .request()
        .query(`SELECT name AS TABLE_NAME FROM sys.tables WHERE type = 'U'`)
      const tables = (tablesResult.recordset || []).map((row: any) => row.TABLE_NAME ?? row.table_name)
      const schemaInfo: Table[] = []

      for (const tableName of tables) {
        const columnsResult = await pool
          .request()
          .query(`
            SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLUMN_DEFAULT
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = '${tableName}'
          `)
        const columns: Column[] = columnsResult.recordset.map((column: any) => ({
          columnName: column.COLUMN_NAME,
          dataType: column.DATA_TYPE,
          characterMaximumLength: column.CHARACTER_MAXIMUM_LENGTH,
          isNullable: column.IS_NULLABLE === 'YES',
          isPrimaryKey: false,
          columnDefault: column.COLUMN_DEFAULT,
          columnComment: null,
        }))

        const pkResult = await pool
          .request()
          .query(`
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
            WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1
              AND TABLE_NAME = '${tableName}'
          `)
        const pkColumns = pkResult.recordset.map((r: any) => r.COLUMN_NAME)
        columns.forEach(col => { if (pkColumns.includes(col.columnName)) col.isPrimaryKey = true })

        const identityResult = await pool
          .request()
          .query(`SELECT name AS COLUMN_NAME FROM sys.identity_columns WHERE object_id = OBJECT_ID('${tableName}')`)
        const identityColumns = (identityResult.recordset || []).map((r: any) => r.COLUMN_NAME)
        columns.forEach(col => { if (identityColumns.includes(col.columnName)) col.isIdentity = true })

        const relationsResult = await pool
          .request()
          .query(`
            SELECT
              k.COLUMN_NAME,
              k2.TABLE_NAME AS foreign_table_name,
              k2.COLUMN_NAME AS foreign_column_name
            FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
            JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE k ON rc.CONSTRAINT_NAME = k.CONSTRAINT_NAME
            JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE k2 ON rc.UNIQUE_CONSTRAINT_NAME = k2.CONSTRAINT_NAME
            WHERE k.TABLE_NAME = '${tableName}'
          `)
        const relations: Relation[] = relationsResult.recordset.map((relation: any) => ({
          columnName: relation.COLUMN_NAME,
          foreignTableName: relation.foreign_table_name,
          foreignColumnName: relation.foreign_column_name,
          relationType: 'ManyToOne',
        }))

        schemaInfo.push({ tableName, tableComment: null, columns, relations })
      }

      this.saveSchemaInfoToFile(schemaInfo)
    } catch (err) {
      console.error('Error accessing the SQLServer database:', err)
    } finally {
      pool.close()
      console.log('SQLServer database connection closed.')
    }
  }

  private saveSchemaInfoToFile(schemaInfo: Table[]) {
    if (!fs.existsSync(this.config.outputDir)) {
      fs.mkdirSync(this.config.outputDir, { recursive: true })
    }

    const projectName = this.toCamelCase(this.config.database)
    const filePath = this.schemaPath
    const output = {
      databaseName: this.config.database,
      projectName: projectName,
      schema: schemaInfo,
    }
    fs.writeFileSync(filePath, JSON.stringify(output, null, 2))
    console.log(`Schema information has been saved to ${filePath}`)
  }

  private toCamelCase(str: string): string {
    return str
      .replace(/([-_][a-z])/g, group => group.toUpperCase().replace('-', '').replace('_', ''))
      .replace(/(^\w)/, group => group.toUpperCase())
  }
}
