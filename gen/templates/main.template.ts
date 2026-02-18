// /templates/main.template.ts
import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import { MicroserviceOptions, Transport } from "@nestjs/microservices";
import { SwaggerModule, DocumentBuilder } from "@nestjs/swagger";
import { Logger } from "@nestjs/common";
import { AppModule } from "./app.module";
import { DataSourceService } from "./config/datasource.service";
import { EnvironmentService } from "./config/environment.service";
import { HealthService } from "./health/health.service";
import { AppReadinessService } from "./config/app.readiness.service";

/**
 * Bootstraps the NestJS application.
 *
 * Configures microservice support, CORS, initializes the DataSource,
 * sets up Swagger in non-production environments and starts the server.
 */
async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.TCP,
    options: { retryAttempts: 5, retryDelay: 3000 },
  });

  app.enableCors({
    allowedHeaders: "Authorization, X-Requested-With, Content-Type, Accept",
    origin: "*",
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS",
    credentials: true,
  });

  const isProd = process.env.NODE_ENV === "production";
  const microserviceName = app
    .get(EnvironmentService)
    .getEnv()
    .get<string>("MICROSERVICE_NAME") || "Microservice";

  const microservicePort = app
    .get(EnvironmentService)
    .getEnv()
    .get<string>("PORT");

  const ds = app.get(DataSourceService).getDataSource();
  try {
    await ds.initialize();
    Logger.log("Data Source has been initialized!");
  } catch (error: any) {
    Logger.error(`Error initializing Data Source: ${error}`);
  }

  if (!isProd) {
    let sessionHealthCheck: boolean;
    try {
      sessionHealthCheck = !!(await app
        .get(HealthService)
        .verifyEndpointSessionHealthCheck());
      if (sessionHealthCheck) {
        Logger.log("Session Token JWT microservice is UP!");
      } else {
        throw Error("Session Token JWT microservice is DOWN!");
      }
    } catch (error: any) {
      Logger.error(`Error during session health check: ${error}`);
      throw Error("Session Token JWT microservice health check failed!");
    }
    const config = new DocumentBuilder()
      .setTitle(microserviceName)
      .setDescription(`${microserviceName} - documentação`)
      .setVersion("1.0")
      .addTag("system")
      .addBearerAuth(
        { type: "http", scheme: "bearer", bearerFormat: "JWT" },
        "access_token",
      )
      .build();
    const document = SwaggerModule.createDocument(app, config);

    SwaggerModule.setup("api", app, document);
  }

  app.startAllMicroservices();
  const PORT = process.env.PORT || microservicePort;
  await app.listen(PORT);
  try {
    const appUrl = await app.getUrl();
    Logger.log(`Application ${microserviceName} is running on: ${appUrl}`);
    const appReadinessService = app.get(AppReadinessService);
    appReadinessService.setAppReady(true);
  } catch (error) {
    Logger.error(`Erro ao obter a URL da aplicação: ${error}`);
  }
} // async function bootstrap()

bootstrap().catch((error) => {
  Logger.error(`Erro na inicialização da aplicação: ${error}`);
});
