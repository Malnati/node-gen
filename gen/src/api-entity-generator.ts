// gen/src/api-entity-generator.ts
import * as fs from "fs";
import * as path from "path";
import { Table, Column, Relation, DbReaderConfig } from "./interfaces";
import { toPascalCase, toSnakeCase, removeTbPrefix } from "./utils/string";
import { loadTemplate } from "./utils/template-loader";

export class ApiEntityGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, "utf-8");
    const parsedSchema = JSON.parse(schemaJson);
    this.schema = parsedSchema.schema;
    this.config = config;
  }

  generateEntities() {
    // Nova estrutura: <output>/api/src/entities/
    const outputDir = path.join(this.config.outputDir, "api", "src", "entities");

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    this.schema.forEach((table) => {
      const entityContent = this.generateEntityContent(table);
      const filePath = path.join(outputDir, `${removeTbPrefix(table.tableName)}.ts`);
      fs.writeFileSync(filePath, entityContent);
    });

    console.log(`API Entities have been generated in ${outputDir}`);
  }

  private generateEntityContent(table: Table): string {
    const primaryKeys = table.columns.filter((col) => col.isPrimaryKey);

    const columns = table.columns
      .filter(
        (col) =>
          !this.isRelationColumn(col.columnName, table.relations) ||
          col.isPrimaryKey,
      )
      .map((col) =>
        this.generateColumnDefinition(col, primaryKeys.includes(col)),
      )
      .join("\n");

    const columnList = table.columns
      .map(
        (col) =>
          ` * @property ${col.columnName} - ${col.columnComment || ""}`,
      )
      .join("\n");

    const relations = table.relations
      .map((rel) => this.generateRelationDefinition(rel))
      .join("\n");
    const imports = this.generateImports(table);
    const customMethods = this.generateCustomMethods(table);

    return loadTemplate("api-entity.template.ejs", {
      tableName: table.tableName,
      pascalTableName: toPascalCase(table.tableName),
      columns,
      relations,
      imports,
      customMethods,
      entityDescription: table.tableComment || "",
      columnList,
    });
  }

  private generateColumnDefinition(
    column: Column,
    isPrimaryKey: boolean = false,
  ): string {
    const typeMapping: { [key: string]: string } = {
      integer: "int",
      bigint: "bigint",
      uuid: "uuid",
      "timestamp without time zone": "timestamp",
      "character varying": "varchar",
      bytea: "bytea",
      boolean: "boolean",
      json: "json",
      jsonb: "jsonb",
      text: "text",
      "double precision": "float",
    };

    const jsTypeMapping: { [key: string]: string } = {
      integer: "number",
      bigint: "number",
      uuid: "string",
      "timestamp without time zone": "Date",
      "character varying": "string",
      bytea: "Buffer",
      boolean: "boolean",
      json: "any",
      jsonb: "any",
      text: "string",
      "double precision": "number",
      // SQLite types (uppercase)
      INTEGER: "number",
      BIGINT: "number",
      UUID: "string",
      TIMESTAMP: "Date",
      "TIMESTAMP WITHOUT TIME ZONE": "Date",
      "CHARACTER VARYING": "string",
      BYTEA: "Buffer",
      BOOLEAN: "boolean",
      JSON: "any",
      JSONB: "any",
      TEXT: "string",
      "DOUBLE PRECISION": "number",
      VARCHAR: "string",
      CHAR: "string",
      BLOB: "Buffer",
    };

    const options: string[] = [];
    const typeOptions: string[] = [];

    if (column.isNullable) typeOptions.push("nullable: true");
    if (column.columnDefault)
      options.push(
        `default: "${column.columnDefault.replace(/"/g, '\\"')}"`,
      );

    const dataTypeLower = column.dataType?.toLowerCase();
    const ormType = typeMapping[column.dataType] ?? typeMapping[dataTypeLower] ?? (dataTypeLower || column.dataType);
    const lengthSupported = ["string", "varchar", "char", "nvarchar", "nchar"];
    if (column.characterMaximumLength != null && column.characterMaximumLength > 0 && lengthSupported.includes(String(ormType))) {
      options.push(`length: ${column.characterMaximumLength}`);
    }
    let columnOptions = [`type: '${ormType}'`, ...options];
    let columnDecorator = `@Column({ ${columnOptions.join(", ")} })`;

    // SQLite uses INTEGER PRIMARY KEY for auto-increment
    if (isPrimaryKey && (column.isIdentity || dataTypeLower === 'integer' || dataTypeLower === 'bigint')) {
      columnDecorator = `@PrimaryGeneratedColumn()`;
    } else if (isPrimaryKey) {
      columnDecorator = `@PrimaryColumn({ ${columnOptions.join(", ")} })`;
    }

    if (column.columnName === "created_at") {
      columnDecorator = `@CreateDateColumn()`;
    }

    if (column.columnName === "updated_at") {
      columnDecorator = `@UpdateDateColumn()`;
    }

    if (column.columnName === "deleted_at") {
      columnDecorator = `@DeleteDateColumn()`;
    }

    const apiPropertyOptions = [`description: "${column.columnComment || ""}"`, ...typeOptions];
    const apiPropertyDecorator = `@ApiProperty({ ${apiPropertyOptions.join(", ")} })`;

    const jsType = jsTypeMapping[column.dataType?.toLowerCase()] || jsTypeMapping[column.dataType] || "any";

    return loadTemplate("api-column.template.ejs", {
      columnDecorator,
      apiPropertyDecorator,
      columnName: column.columnName,
      columnType: jsType,
    });
  }

  private generateRelationDefinition(relation: Relation): string {
    let relationType: "ManyToOne" | "OneToOne" | "OneToMany" | "ManyToMany" = "ManyToOne";

    if (relation.relationType === "OneToOne") {
      relationType = "OneToOne";
    } else if (relation.relationType === "OneToMany") {
      relationType = "OneToMany";
    } else if (relation.relationType === "ManyToMany") {
      relationType = "ManyToMany";
    }

    const propertyName = this.removeIdSuffix(relation.columnName);

    const relationDecorator = `@${relationType}(() => ${toPascalCase(relation.foreignTableName)}Entity)`;
    const joinColumnDecorator = relationType === "ManyToOne" || relationType === "OneToOne"
      ? `@JoinColumn({ name: '${relation.columnName}' })`
      : "";
    const apiPropertyDecorator = `@ApiProperty({ description: "Relacionamento com ${relation.foreignTableName}." })`;

    return loadTemplate("api-relation.template.ejs", {
      relationDecorator,
      joinColumnDecorator,
      apiPropertyDecorator,
      columnName: propertyName,
      relationEntity: toPascalCase(relation.foreignTableName),
      arraySuffix: relationType === "OneToMany" || relationType === "ManyToMany" ? "[]" : "",
    });
  }

  private generateImports(table: Table): string {
    const typeormImports = new Set<string>([
      "Entity",
      "Column",
      "CreateDateColumn",
      "UpdateDateColumn",
      "DeleteDateColumn",
      "PrimaryColumn",
      "PrimaryGeneratedColumn",
      "JoinColumn",
    ]);

    table.relations.forEach((relation) => {
      typeormImports.add(relation.relationType);
    });

    const entityImports = table.relations
      .filter((relation) => relation.foreignTableName !== table.tableName)
      .map(
        (relation) =>
          `import { ${toPascalCase(relation.foreignTableName)}Entity } from './${removeTbPrefix(relation.foreignTableName)}';`,
      )
      .join("\n");

    const typeormImportsString = `import { ${Array.from(typeormImports).join(", ")} } from 'typeorm';`;

    return `${typeormImportsString}\nimport 'reflect-metadata';\nimport { ApiProperty } from '@nestjs/swagger';\n${entityImports}`;
  }

  private generateCustomMethods(table: Table): string {
    const hasExternalId = table.columns.some((c) => c.columnName === "external_id");
    const firstPkScalar = table.columns.find(
      (c) => c.isPrimaryKey && !this.isRelationColumn(c.columnName, table.relations),
    );
    const displayKey = hasExternalId ? "this.external_id" : (firstPkScalar ? `this.${firstPkScalar.columnName}` : "''");
    const column = table.columns.find(
      (col) =>
        ![
          "id",
          "external_id",
          "updated_at",
          "created_at",
          "deleted_at",
        ].includes(col.columnName),
    );
    const propName = column
      ? (this.isRelationColumn(column.columnName, table.relations) ? this.removeIdSuffix(column.columnName) : column.columnName)
      : "";
    const columnName = propName ? ` - \${this.${propName}}` : "";

    return `
    toString() {
      return \`\${${displayKey}}${columnName}\`;
    }`;
  }

  private isRelationColumn(columnName: string, relations: Relation[]): boolean {
    return relations.some((relation) => relation.columnName === columnName);
  }

  private removeIdSuffix(columnName: string): string {
    return columnName.endsWith("_id") && columnName !== "external_id"
      ? columnName.slice(0, -3)
      : columnName;
  }
}
