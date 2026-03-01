// app/api/src/constants/index.ts

export const MAX_FOTOS_PER_LOTE = 5;
export const MAX_FOTOS_PER_OFFER = 5; // Same as MAX_FOTOS_PER_LOTE for backward compatibility
export const MAX_FOTO_SIZE_MB = 10;
export const MAX_FOTO_SIZE_BYTES = MAX_FOTO_SIZE_MB * 1024 * 1024;

export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  NOT_FOUND: 404,
  INTERNAL_SERVER_ERROR: 500,
} as const;

/**
 * Standardized error codes used throughout the application
 */
export const ERROR_CODES = {
  VALIDATION_ERROR: "VALIDATION_ERROR",
  NOT_FOUND: "NOT_FOUND",
  INSUFFICIENT_QUANTITY: "INSUFFICIENT_QUANTITY",
  OWN_LOT_PURCHASE: "OWN_LOT_PURCHASE", // Legacy alias
  LOT_ALREADY_SOLD: "LOT_ALREADY_SOLD", // Legacy alias
  OWN_OFFER_PURCHASE: "OWN_OFFER_PURCHASE",
  OFFER_ALREADY_SOLD: "OFFER_ALREADY_SOLD",
  TIPO_NOT_FOUND: "TIPO_NOT_FOUND",
  UNIDADE_NOT_FOUND: "UNIDADE_NOT_FOUND",
  MAX_FOTOS_EXCEEDED: "MAX_FOTOS_EXCEEDED",
  NO_FORNECEDOR_ASSOCIATED: "NO_FORNECEDOR_ASSOCIATED",
} as const;

/**
 * Standard HTTP headers
 */
export const HTTP_HEADERS = {
  CONTENT_TYPE: "Content-Type",
  AUTHORIZATION: "Authorization",
  HTTP_REFERER: "HTTP-Referer",
  X_TITLE: "X-Title",
} as const;

/**
 * Standard content types
 */
export const CONTENT_TYPES = {
  JSON: "application/json",
  FORM_URLENCODED: "application/x-www-form-urlencoded",
  MULTIPART: "multipart/form-data",
} as const;

/**
 * Mock values for testing and development
 */
export const MOCK_VALUES = {
  API_KEY: "mock-key-for-tests",
  LATITUDE_SAO_PAULO: -23.5505,
  LONGITUDE_SAO_PAULO: -46.6333,
  ACCURACY_APPROXIMATE: "APPROXIMATE",
} as const;
