// gen/static-api/src/constants/shared.ts
export const APP_NAME = process.env.MICROSERVICE_NAME || 'API';
export const APP_PORT = parseInt(process.env.PORT || '3000', 10);
export const DATABASE_TYPE = process.env.DATABASE_TYPE || 'postgres';
export const DATABASE_HOST = process.env.DATABASE_HOST || 'localhost';
export const DATABASE_PORT = parseInt(process.env.DATABASE_PORT || '5432', 10);
export const DATABASE_NAME = process.env.DATABASE_NAME || 'app';
export const DATABASE_USER = process.env.DATABASE_USER || 'postgres';
export const DATABASE_PASSWORD = process.env.DATABASE_PASSWORD || 'postgres';

export const SWAGGER_PATH = 'api';
export const DEFAULT_PAGE_SIZE = 10;
export const MAX_PAGE_SIZE = 100;
