// /src/static-templates.ts
import { loadTemplate } from "./utils/template-loader"
import { toPascalCase } from "./utils/string"

export const entityTemplate = (
	tableName: string,
	columns: string,
	relations: string,
	imports: string,
	customMethods: string = "",
	entityDescription: string = "",
	columnList: string = "",
) =>
	loadTemplate("entity.template.ts", {
		tableName,
		pascalTableName: toPascalCase(tableName),
		columns,
		relations,
		imports,
		customMethods,
		entityDescription,
		columnList,
	})

export const columnTemplate = (
	columnDecorator: string,
	apiPropertyDecorator: string,
	columnName: string,
	columnType: string,
) =>
	loadTemplate("column.template.ts", {
		columnDecorator,
		apiPropertyDecorator,
		columnName,
		columnType,
	})

export const relationTemplate = (
	relationType: "ManyToOne" | "OneToOne" | "OneToMany" | "ManyToMany",
	foreignTableName: string,
	propertyName: string,
	joinColumnDbName: string,
	joinColumn: boolean = true,
) => {
	const relationDecorator = `@${relationType}(() => ${toPascalCase(foreignTableName)}Entity)`
	const joinColumnDecorator = joinColumn
		? `@JoinColumn({ name: '${joinColumnDbName}' })`
		: ""
	const apiPropertyDecorator = `@ApiProperty({ description: "Relacionamento com ${foreignTableName}." })`
	return loadTemplate("relation.template.ts", {
		relationDecorator,
		joinColumnDecorator,
		apiPropertyDecorator,
		columnName: propertyName,
		relationEntity: toPascalCase(foreignTableName),
		arraySuffix:
			relationType === "OneToMany" || relationType === "ManyToMany"
				? "[]"
				: "",
	})
}

export const typeMapping: { [key: string]: string } = {
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
}

export const jsTypeMapping: { [key: string]: string } = {
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
}
