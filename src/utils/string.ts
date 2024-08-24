export function toPascalCase(str: string): string {
    if (str.startsWith('tb_')) {
        str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
}

export function toSnakeCase(str: string): string {
    if (str.startsWith('tb_')) {
        str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/([A-Z])/g, "_$1").toLowerCase().replace(/^_/, '');
}

export function toKebabCase(str: string): string {
    if (str.startsWith('tb_')) {
        str = str.substring(3);  // Remove the 'tb_' prefix
    }

    str = toSnakeCase(str);
    return str.replace(/_/g, '-').toLowerCase();
}