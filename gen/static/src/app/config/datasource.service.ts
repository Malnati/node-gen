// /static/src/app/config/datasource.service.ts
import "reflect-metadata";
import { DataSource } from "typeorm";
import { Injectable } from "@nestjs/common";
import { EnvironmentService } from "./environment.service";

export const cacheDuration = 31536000000;

@Injectable()
export class DataSourceService {
  private dataSource: DataSource;

  constructor(private env: EnvironmentService) {
    const dbType = env.getEnv().get<string>("DATABASE_TYPE") || "postgres";
    const type = dbType === 'sqlserver' ? 'mssql' : dbType;
    if (type === "sqlite") {
      this.dataSource = new DataSource({
        type: "sqlite",
        database: env.getEnv().get<string>("DATABASE_PATH") || "test/e2e-generator-mock/projects/todo/db/database.db",
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
        ssl: {
          rejectUnauthorized: false,
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
        ssl: {
          rejectUnauthorized: false,
        },
        cache: {
          type: "database",
          duration: cacheDuration,
        },
      });
    }
  }

  getDataSource(): DataSource {
    return this.dataSource;
  }
}
