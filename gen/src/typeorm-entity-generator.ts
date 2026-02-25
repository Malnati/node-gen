// /src/typeorm-entity-generator.ts
import * as fs from "fs"
import * as path from "path"
import { Table, Column, Relation, DbReaderConfig } from "./interfaces"
import {
	entityTemplate,
	columnTemplate,
	relationTemplate,
	typeMapping,
	jsTypeMapping,
} from "./static-templates"
import { toPascalCase, toSnakeCase, removeTbPrefix } from "./utils/string"

export class TypeORMEntityGenerator {
	private schema: Table[]
	private config: DbReaderConfig

	constructor(schemaPath: string, config: DbReaderConfig) {
		const schemaJson = fs.readFileSync(schemaPath, "utf-8")
		const parsedSchema = JSON.parse(schemaJson)
		this.schema = parsedSchema.schema
		this.config = config
	}

	generateEntities() {
		const outputDir = path.join(this.config.outputDir, "src/app/entities")

		if (!fs.existsSync(outputDir)) {
			fs.mkdirSync(outputDir, { recursive: true })
		}

		this.schema.forEach((table) => {
			const entityContent = this.generateEntityContent(table)
			const filePath = path.join(
				outputDir,
				`${removeTbPrefix(table.tableName)}.ts`,
			)
			fs.writeFileSync(filePath, entityContent)
		})

		console.log(`Entities have been generated in ${outputDir}`)
	}

	private generateEntityContent(table: Table): string {
		const primaryKeys = table.columns.filter((col) => col.isPrimaryKey)

		const columns = table.columns
			.filter(
				(col) =>
					!this.isRelationColumn(col.columnName, table.relations) ||
					col.isPrimaryKey,
			)
			.map((col) =>
				this.generateColumnDefinition(col, primaryKeys.includes(col)),
			)
			.join("\n  ")

		const columnList = table.columns
			.map(
				(col) =>
					` * @property ${col.columnName} - ${col.columnComment || ""}`,
			)
			.join("\n")

		const relations = table.relations
			.map((rel) => this.generateRelationDefinition(rel))
			.join("\n  ")
		const imports = this.generateImports(table)
		const customMethods = this.generateCustomMethods(table)

		return entityTemplate(
			table.tableName,
			columns,
			relations,
			imports,
			customMethods,
			table.tableComment || "",
			columnList,
		)
	}

	private generateColumnDefinition(
		column: Column,
		isPrimaryKey: boolean = false,
	): string {
		const options: string[] = []
		const typeOptions: string[] = []

		if (column.isNullable) typeOptions.push("nullable: true")
		if (column.columnDefault)
			options.push(
				`default: "${column.columnDefault.replace(/"/g, '\\"')}"`,
			)

		const ormType = typeMapping[column.dataType] ?? typeMapping[column.dataType?.toLowerCase()] ?? (column.dataType?.toLowerCase() || column.dataType)
		const lengthSupported = ["string", "varchar", "char", "nvarchar", "nchar"]
		if (column.characterMaximumLength != null && column.characterMaximumLength > 0 && lengthSupported.includes(String(ormType))) {
			options.push(`length: ${column.characterMaximumLength}`)
		}
		const columnOptions = [`type: '${ormType}'`, ...options]
		let columnDecorator = `@Column({ ${columnOptions.join(", ")} })`

		if (isPrimaryKey && column.isIdentity) {
			columnDecorator = `@PrimaryGeneratedColumn()`
		} else if (isPrimaryKey) {
			columnDecorator = `@PrimaryColumn({ ${columnOptions.join(", ")} })`
		}

		if (column.columnName === "created_at") {
			columnDecorator = `@CreateDateColumn()`
		}

		if (column.columnName === "updated_at") {
			columnDecorator = `@UpdateDateColumn()`
		}

		if (column.columnName === "deleted_at") {
			columnDecorator = `@DeleteDateColumn()`
		}

		const apiPropertyOptions = [`description: "${column.columnComment || ""}"`, ...typeOptions]
		const apiPropertyDecorator = `@ApiProperty({ ${apiPropertyOptions.join(", ")} })`

		return columnTemplate(
			columnDecorator,
			apiPropertyDecorator,
			column.columnName,
			jsTypeMapping[column.dataType] || "any",
		)
	}

	private generateRelationDefinition(relation: Relation): string {
		let relationType:
			| "ManyToOne"
			| "OneToOne"
			| "OneToMany"
			| "ManyToMany" = "ManyToOne"

		if (relation.relationType === "OneToOne") {
			relationType = "OneToOne"
		} else if (relation.relationType === "OneToMany") {
			relationType = "OneToMany"
		} else if (relation.relationType === "ManyToMany") {
			relationType = "ManyToMany"
		}

		const propertyName = this.removeIdSuffix(relation.columnName)
		return relationTemplate(
			relationType,
			relation.foreignTableName,
			propertyName,
			relation.columnName,
			relationType === "ManyToOne" || relationType === "OneToOne",
		)
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
		])

		table.relations.forEach((relation) => {
			typeormImports.add(relation.relationType)
		})

		const entityImports = table.relations
			.filter((relation) => relation.foreignTableName !== table.tableName)
			.map(
				(relation) =>
					`import { ${toPascalCase(relation.foreignTableName)}Entity } from './${removeTbPrefix(relation.foreignTableName)}';`,
			)
			.join("\n")

		const typeormImportsString = `import { ${Array.from(typeormImports).join(", ")} } from 'typeorm';`

		return `${typeormImportsString}\nimport 'reflect-metadata';\nimport { ApiProperty } from '@nestjs/swagger';\n${entityImports}`
	}

	private generateCustomMethods(table: Table): string {
		const hasExternalId = table.columns.some((c) => c.columnName === "external_id")
		const firstPkScalar = table.columns.find(
			(c) => c.isPrimaryKey && !this.isRelationColumn(c.columnName, table.relations),
		)
		const displayKey = hasExternalId ? "this.external_id" : (firstPkScalar ? `this.${firstPkScalar.columnName}` : "''")
		const column = table.columns.find(
			(col) =>
				![
					"id",
					"external_id",
					"updated_at",
					"created_at",
					"deleted_at",
				].includes(col.columnName),
		)
		const propName = column
			? (this.isRelationColumn(column.columnName, table.relations) ? this.removeIdSuffix(column.columnName) : column.columnName)
			: ""
		const columnName = propName ? ` - \${this.${propName}}` : ""

		return `
    toString() {
      return \`\${${displayKey}}${columnName}\`;
    }`
	}

	private isRelationColumn(
		columnName: string,
		relations: Relation[],
	): boolean {
		return relations.some((relation) => relation.columnName === columnName)
	}

	private removeIdSuffix(columnName: string): string {
		return columnName.endsWith("_id") && columnName !== "external_id"
			? columnName.slice(0, -3)
			: columnName
	}
}
