{{imports}}

@Entity('{{tableName}}')
export class {{pascalTableName}}Entity {
  {{columns}}
  {{relations}}

  {{customMethods}}
}
