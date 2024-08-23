
// src/interfaces.ts

export interface Column {
  columnName: string;
  dataType: string;
  characterMaximumLength: number | null;
  isNullable: boolean;
  columnDefault: string | null;
  columnComment: string | null;
}

export interface Table {
  tableName: string;
  columns: Column[];
  relations: Relation[];
}

export interface Relation {
  columnName: string;
  foreignTableName: string;
  foreignColumnName: string;
}

export interface DbReaderConfig {
  app: string;
  host: string;
  port: number;
  database: string;
  user: string;
  password: string;
  outputDir: string;
  components: ['entities'|'services'|'interfaces'|'controllers'|'dtos'|'modules'|'app-module'|'main'|'env'|'package.json'|'readme'|'datasource'];
}

export type Format = "svg" | "dot" | "json" | "dot_json" | "xdot_json" | "png";
export type Engine = "circo" | "dot" | "fdp" | "neato" | "osage" | "patchwork" | "twopi";