// src/db.reader.util.ts

export function toCamelCase(str: string): string {
    return str
      .replace(/([-_][a-z])/g, group => group.toUpperCase().replace('-', '').replace('_', ''))
      .replace(/(^\w)/, group => group.toUpperCase());
  }

  export function toPascalCase(str: string): string {
	str = removeTbPrefix(str);
	return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
  }

  export function removeTbPrefix(str: string): string {
	return str.startsWith('tb_') ? str.substring(3) : str;
  }

  export function toLowerFirst(str: string): string {
    if (!str) return str;
    return str.charAt(0).toLowerCase() + str.slice(1);
  }

  export function formatAttributeName(str: string): string {
    if (!str) return str;
    return toLowerFirst(toCamelCase(str));
  }

  export function mapDatabaseTypeToJsType(dbType: string) {
	const typeMap: { [key: string]: string } = {
		'integer': 'number',
		'smallint': 'number',
		'bigint': 'number',
		'real': 'number',
		'double precision': 'number',
		'numeric': 'number',
		'decimal': 'number',
		'boolean': 'boolean',
		'character varying': 'string',
		'character': 'string',
		'text': 'string',
		'bytea': 'Buffer',
		'date': 'Date',
		'timestamp without time zone': 'Date',
		'timestamp with time zone': 'Date',
		'USER-DEFINED': 'any', // Mapear para "any" ou um tipo específico se desejado
		'name': 'string',      // Mapear para string em JS
	};

	return typeMap[dbType as keyof typeof typeMap] || 'any'; // Retorna 'any' como padrão para tipos desconhecidos
  }


  export function toSlugCase(text: string): string {
	text = removeTbPrefix(text.trim());
	text = text
	  .toLowerCase() // Converte todo o texto para minúsculas
	  .normalize("NFD") // Normaliza caracteres com acentos
	  .replace(/[\u0300-\u036f]/g, "") // Remove os acentos
	  .replace(/[^a-z0-9]+/g, "-") // Substitui caracteres não alfanuméricos por hífens
	  .replace(/^-+|-+$/g, ""); // Remove hífens extras no início e no final
	  console.log(`toSlugCase: ${text}`);
	  return text;
  }
