// /templates/datasource.template.ts
import "reflect-metadata";
import { DataSource } from "typeorm";
import { Injectable } from "@nestjs/common";
import { EnvironmentService } from "./environment.service";
import { UserEntity } from "@app/entities/user";

/** Cache duration for TypeORM (1 year in milliseconds) */
export const cacheDuration = 31536000000;

@Injectable()
/** Service responsible for providing a configured DataSource instance */
export class DataSourceService {
  private readonly dataSource: DataSource;

  constructor(private readonly env: EnvironmentService) {
    const dbType = env.getEnv().get<string>("DATABASE_TYPE") || "postgres";
    const type = dbType === 'sqlserver' ? 'mssql' : dbType;
    if (type === "sqlite") {
      this.dataSource = new DataSource({
        type: "sqlite",
        database: env.getEnv().get<string>("DATABASE_PATH") || "test/db/database.db",
        entities: [UserEntity],
        synchronize: true,
        logging: true,
      });
    } else if (type === "mysql") {
      this.dataSource = new DataSource({
        type: "mysql",
        host: env.getEnv().get<string>("DATABASE_HOST"),
        port: env.getEnv().get<number>("DATABASE_PORT"),
        database: env.getEnv().get<string>("DATABASE_NAME"),
        username: env.getEnv().get<string>("DATABASE_USER"),
        password: env.getEnv().get<string>("DATABASE_PASSWORD"),
        entities: [UserEntity],
        synchronize: false,
        logging: true,
        cache: {
          type: "database",
          duration: cacheDuration,
        },
      });
    } else {
      this.dataSource = new DataSource({
        type: type as any,
        host: env.getEnv().get<string>("DATABASE_HOST"),
        port: env.getEnv().get<number>("DATABASE_PORT"),
        database: env.getEnv().get<string>("DATABASE_NAME"),
        username: env.getEnv().get<string>("DATABASE_USER"),
        password: env.getEnv().get<string>("DATABASE_PASSWORD"),
        entities: [UserEntity],
        synchronize: false,
        logging: true,
        cache: {
          type: "database",
          duration: cacheDuration,
        },
      });
    }
  }

  /** Returns the configured DataSource */
  getDataSource(): DataSource {
    return this.dataSource;
  }
}
