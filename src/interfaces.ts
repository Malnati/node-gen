// src/interfaces.ts

import { TComponents } from "./types";

export interface IColumn {
  columnName: string;
  dataType: string;
  characterMaximumLength: number | null;
  isNullable: boolean;
  isPrimaryKey: boolean;
  columnDefault: string | null;
  columnComment: string | null;
}

export interface ITable {
  tableName: string;
  columns: IColumn[];
  relations: IRelation[];
}

export interface IRelation {
  columnName: string;
  foreignTableName: string;
  foreignColumnName: string;
  relationType: 'ManyToOne' | 'OneToOne' | 'OneToMany' | 'ManyToMany'; // Novo campo adicionado
}

export interface IDbReaderConfig {
  app: string;
  host: string;
  port: number;
  database: string;
  user: string;
  password: string;
  outputDir: string;
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

export interface IGeneratorConfig {
    app: string;
	templatesPath: string;
	schemaPath: string;
    outputDir: string;
    components: TComponents;
    scripts?: Record<string, string>; // Novas propriedades para scripts
    dependencies?: Record<string, string>; // Novas propriedades para dependências
    devDependencies?: Record<string, string>; // Novas propriedades para devDependencies
}

export interface IGenerator {
	templateFileName: string;
	targetDir: string;
	generate(): void
}

export interface IRequestConfig {
	method: string
	url: string
	headers: Record<string, string>
	body: string | null
}
