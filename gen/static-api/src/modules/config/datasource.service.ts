// /static/src/app/config/datasource.service.ts
import "reflect-metadata";
import { DataSource } from "typeorm";
import { Injectable, OnModuleInit } from "@nestjs/common";
import { EnvironmentService } from "./environment.service";

export const cacheDuration = 31536000000;

@Injectable()
export class DataSourceService implements OnModuleInit {
  private dataSource: DataSource;

  constructor(private env: EnvironmentService) {
    const dbType = env.getEnv().get<string>("DATABASE_TYPE") || "postgres";
    const type = dbType === 'sqlserver' ? 'mssql' : dbType;
    if (type === "sqlite") {
      this.dataSource = new DataSource({
        type: "sqlite",
        database: env.getEnv().get<string>("DATABASE_PATH") || "test/e2e-generator/projects/todo/db/database.db",
        entities: [],
        synchronize: true,
        logging: true,
      });
    } else if (type === "mysql") {
      this.dataSource = new DataSource({
        type: "mysql",
        host: env.getEnv().get<string>("DATABASE_HOST"),
        port: parseInt(env.getEnv().get<string>("DATABASE_PORT") || "3306", 10),
        database: env.getEnv().get<string>("DATABASE_NAME"),
        username: env.getEnv().get<string>("DATABASE_USER"),
        password: env.getEnv().get<string>("DATABASE_PASSWORD"),
        entities: [],
        synchronize: false,
        logging: true,
        cache: {
          type: "database",
          duration: cacheDuration,
        },
      });
    } else if (type === "mssql") {
      this.dataSource = new DataSource({
        type: "mssql",
        host: env.getEnv().get<string>("DATABASE_HOST"),
        port: parseInt(env.getEnv().get<string>("DATABASE_PORT") || "1433", 10),
        database: env.getEnv().get<string>("DATABASE_NAME"),
        username: env.getEnv().get<string>("DATABASE_USER"),
        password: env.getEnv().get<string>("DATABASE_PASSWORD"),
        entities: [],
        synchronize: false,
        logging: true,
        options: {
          trustServerCertificate: true,
        },
        cache: {
          type: "database",
          duration: cacheDuration,
        },
      });
    } else {
      this.dataSource = new DataSource({
        type: type as any,
        host: env.getEnv().get<string>("DATABASE_HOST"),
        port: parseInt(env.getEnv().get<string>("DATABASE_PORT") || "5432", 10),
        database: env.getEnv().get<string>("DATABASE_NAME"),
        username: env.getEnv().get<string>("DATABASE_USER"),
        password: env.getEnv().get<string>("DATABASE_PASSWORD"),
        entities: [],
        synchronize: false,
        logging: true,
        cache: {
          type: "database",
          duration: cacheDuration,
        },
      });
    }
  }

  async onModuleInit(): Promise<void> {
    if (!this.dataSource.isInitialized) {
      await this.dataSource.initialize();
    }
  }

  getDataSource(): DataSource {
    return this.dataSource;
  }
}
