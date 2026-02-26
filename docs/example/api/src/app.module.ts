// app/api/src/app.module.ts
import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { TipoModule } from "./modules/tipo/tipo.module";

// Database default configuration values
const DEFAULT_DATABASE_HOST = "db";
const DEFAULT_DATABASE_PORT = 5432;
const DEFAULT_DATABASE_USER = "postgres";
const DEFAULT_DATABASE_PASSWORD = "postgres";
const DEFAULT_DATABASE_NAME = "db";

const DATABASE_HOST = (
  process.env.DATABASE_HOST || DEFAULT_DATABASE_HOST
).trim();
const DATABASE_PORT = parseInt(
  (process.env.DATABASE_PORT || String(DEFAULT_DATABASE_PORT)).trim(),
  10,
);
const DATABASE_USER = (
  process.env.DATABASE_USER || DEFAULT_DATABASE_USER
).trim();
const DATABASE_PASSWORD = (
  process.env.DATABASE_PASSWORD || DEFAULT_DATABASE_PASSWORD
).trim();
const DATABASE_NAME = (
  process.env.DATABASE_NAME || DEFAULT_DATABASE_NAME
).trim();

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: "postgres",
      host: DATABASE_HOST,
      port: DATABASE_PORT,
      username: DATABASE_USER,
      password: DATABASE_PASSWORD,
      database: DATABASE_NAME,
      entities: [__dirname + "/**/*.entity{.ts,.js}"],
      synchronize: false, // Desabilitado - usar migrations manuais
      logging: process.env.NODE_ENV === "development",
    }),
    TipoModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
