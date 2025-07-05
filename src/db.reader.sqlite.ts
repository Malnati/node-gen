// /src/db.reader.sqlite.ts
import sqlite3 from 'sqlite3'
import * as fs from 'fs'
import { DbReaderConfig, Table, Column, Relation } from './interfaces'

export class DbReaderSqlite {
  private config: DbReaderConfig
  private schemaPath: string

  constructor(schemaPath: string, config: DbReaderConfig) {
    this.config = config
    this.schemaPath = schemaPath
  }

  public async getSchemaInfo() {
    const dbPath = this.config.database
    const db = new sqlite3.Database(dbPath)

    const tables: string[] = await new Promise((resolve, reject) => {
      db.all(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
        (err, rows) => {
          if (err) reject(err)
          else resolve(rows.map((r: any) => r.name))
        },
      )
    })

    const schemaInfo: Table[] = []
    for (const tableName of tables) {
      const columns: Column[] = await new Promise((resolve, reject) => {
        db.all(`PRAGMA table_info(${tableName})`, (err, rows) => {
          if (err) return reject(err)
          resolve(
            rows.map((row: any) => ({
              columnName: row.name,
              dataType: row.type,
              characterMaximumLength: null,
              isNullable: row.notnull === 0,
              isPrimaryKey: row.pk !== 0,
              columnDefault: row.dflt_value,
              columnComment: null,
            }))
          )
        })
      })

      const relations: Relation[] = await new Promise((resolve, reject) => {
        db.all(`PRAGMA foreign_key_list(${tableName})`, (err, rows) => {
          if (err) return reject(err)
          resolve(
            rows.map((r: any) => ({
              columnName: r.from,
              foreignTableName: r.table,
              foreignColumnName: r.to,
              relationType: 'ManyToOne',
            }))
          )
        })
      })

      schemaInfo.push({ tableName, tableComment: null, columns, relations })
    }

    db.close()
    this.saveSchemaInfoToFile(schemaInfo)
  }

  private saveSchemaInfoToFile(schemaInfo: Table[]) {
    if (!fs.existsSync(this.config.outputDir)) {
      fs.mkdirSync(this.config.outputDir, { recursive: true })
    }
    const filePath = this.schemaPath
    const projectName = this.toCamelCase(this.config.database)
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
      .replace(/([-_][a-z])/g, (group) => group.toUpperCase().replace('-', '').replace('_', ''))
      .replace(/(^\w)/, (group) => group.toUpperCase())
  }
}
