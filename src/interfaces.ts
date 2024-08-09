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