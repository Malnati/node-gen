// /src/interfaces.ts
export interface Column {
  columnName: string;
  dataType: string;
  characterMaximumLength: number | null;
  isNullable: boolean;
  isPrimaryKey: boolean;
  columnDefault: string | null;
  columnComment: string | null;
  /** True when column is IDENTITY (SQL Server) or auto-increment (MySQL). */
  isIdentity?: boolean;
}

export interface Table {
  tableName: string;
  tableComment?: string | null;
  columns: Column[];
  relations: Relation[];
}

export interface Relation {
  columnName: string;
  foreignTableName: string;
  foreignColumnName: string;
  relationType: 'ManyToOne' | 'OneToOne' | 'OneToMany' | 'ManyToMany'; // Novo campo adicionado
}

export interface DbReaderConfig {
  app: string;
  host: string;
  port: number;
  database: string;
  user: string;
  password: string;
  outputDir: string;
  templateDir?: string;
  components: [
    'entities' |
    'services' |
    'interfaces' |
    'controllers' |
    'dtos' |
    'modules' |
    'app-module' |
    'main' |
    'env' |
    'package.json' |
    'readme' |
    'datasource' |
    'diagram'
  ];
  dbType: string;
}

export type Format = "svg" | "dot" | "json" | "dot_json" | "xdot_json" | "png";
export type Engine = "circo" | "dot" | "fdp" | "neato" | "osage" | "patchwork" | "twopi";
