// app/api/src/main.ts
import { NestFactory } from "@nestjs/core";
import { ValidationPipe } from "@nestjs/common";
import { SwaggerModule, DocumentBuilder } from "@nestjs/swagger";
import { AppModule } from "./app.module";
import { LoggingInterceptor } from "./common/interceptors/logging.interceptor";
import express from "express";

// Default configuration values
const DEFAULT_PORT = 3001;
const DEFAULT_HOST = "0.0.0.0";
const DEFAULT_JSON_PAYLOAD_LIMIT = "10mb";
const DEFAULT_PROTOCOL = "http";

// Swagger configuration
const SWAGGER_TITLE = "API - Marketplace de Resíduos";
const SWAGGER_DESCRIPTION =
  "API NestJS para protótipo MVP de marketplace de produtos";
const SWAGGER_VERSION = "0.1.0";
const SWAGGER_SERVER_DEV_LABEL = "Desenvolvimento Local";
const SWAGGER_SERVER_PROD_LABEL = "Produção";
const SWAGGER_AUTH_TYPE = "http";
const SWAGGER_AUTH_SCHEME = "bearer";
const SWAGGER_AUTH_FORMAT = "JWT";
const SWAGGER_AUTH_NAME = "JWT";
const SWAGGER_AUTH_DESCRIPTION = "Enter JWT token";
const SWAGGER_AUTH_IN = "header";
const SWAGGER_AUTH_KEY = "JWT-auth";
const SWAGGER_SITE_TITLE = "API Documentation";
const SWAGGER_FAVICON = "/favicon.ico";
const SWAGGER_CSS = ".swagger-ui .topbar { display: none }";

const PORT = process.env.PORT ? parseInt(process.env.PORT, 10) : DEFAULT_PORT;
const HOST = process.env.HOST || DEFAULT_HOST;
const JSON_PAYLOAD_LIMIT =
  process.env.JSON_PAYLOAD_LIMIT || DEFAULT_JSON_PAYLOAD_LIMIT;
const API_BASE_URL =
  process.env.API_BASE_URL || `${DEFAULT_PROTOCOL}://${HOST}:${PORT}`;

// Ensure API_PRODUCTION_URL is set in production
if (process.env.NODE_ENV === "production" && !process.env.API_PRODUCTION_URL) {
  throw new Error(
    "API_PRODUCTION_URL environment variable must be set in production.",
  );
}
const API_PRODUCTION_URL = process.env.API_PRODUCTION_URL || API_BASE_URL;

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Aumentar limite de payload JSON para uploads grandes (ex: lotes com múltiplas fotos)
  // O NestJS usa express internamente, então podemos acessar o app HTTP
  const expressApp = app.getHttpAdapter().getInstance();
  expressApp.use(express.json({ limit: JSON_PAYLOAD_LIMIT }));
  expressApp.use(
    express.urlencoded({ extended: true, limit: JSON_PAYLOAD_LIMIT }),
  );

  // Habilitar CORS para desenvolvimento
  app.enableCors({
    origin: process.env.CORS_ORIGIN || "*",
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS",
    credentials: true,
  });

  // Validação global
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Interceptor de logging global
  app.useGlobalInterceptors(new LoggingInterceptor());

  // Prefixo global de API
  app.setGlobalPrefix("api");

  // Configuração do Swagger
  const config = new DocumentBuilder()
    .setTitle(SWAGGER_TITLE)
    .setDescription(SWAGGER_DESCRIPTION)
    .setVersion(SWAGGER_VERSION)
    .addBearerAuth(
      {
        type: SWAGGER_AUTH_TYPE,
        scheme: SWAGGER_AUTH_SCHEME,
        bearerFormat: SWAGGER_AUTH_FORMAT,
        name: SWAGGER_AUTH_NAME,
        description: SWAGGER_AUTH_DESCRIPTION,
        in: SWAGGER_AUTH_IN,
      },
      SWAGGER_AUTH_KEY,
    )
    .addServer(API_BASE_URL, SWAGGER_SERVER_DEV_LABEL)
    .addServer(API_PRODUCTION_URL, SWAGGER_SERVER_PROD_LABEL)
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("api/docs", app, document, {
    customSiteTitle: SWAGGER_SITE_TITLE,
    customfavIcon: SWAGGER_FAVICON,
    customCss: SWAGGER_CSS,
  });

  await app.listen(PORT, HOST);
  console.log(`🚀 API rodando em ${API_BASE_URL}/api`);
  console.log(`📚 Swagger disponível em ${API_BASE_URL}/api/docs`);
}

bootstrap();
