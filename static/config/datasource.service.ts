
// src/app/config/datasource.service.ts

import "reflect-metadata";
import { DataSource } from "typeorm";
import { Injectable } from "@nestjs/common";
import { EnvironmentService } from "./environment.service";
import { ItemEntity } from "../entity/item.entity";
import { OptoutEntity } from "../entity/optout.entity";
import { ItemCorporationEntity } from "@app/entity/item-corporation.entity";
import { ItemEnterpriseEntity } from "@app/entity/item-enterprise.entity";

export const cacheDuration = 31536000000;

@Injectable()
export class DataSourceService {
  private dataSource: DataSource;

  constructor(private env: EnvironmentService) {
    this.dataSource = new DataSource({
      type: "postgres",
      host: env.getEnv().get<string>("DATABASE_HOST"),
      port: env.getEnv().get<number>("DATABASE_PORT"),
      database: env.getEnv().get<string>("DATABASE_NAME"),
      username: env.getEnv().get<string>("DATABASE_USER"),
      password: env.getEnv().get<string>("DATABASE_PASSWORD"),
      entities: [ItemEntity, OptoutEntity, ItemEnterpriseEntity, ItemCorporationEntity],
      synchronize: false,
      logging: true,
      ssl: {
        rejectUnauthorized: false,
      },
      cache: {
        type: "database", // Usando o cache in-memory do TypeORM
        duration: cacheDuration // 1 ano em milissegundos
      },
      // ssl: env.getEnv().get<boolean>('DATABASE_SSL') ? { rejectUnauthorized: false } : undefined,
    });
  }

  getDataSource(): DataSource {
    return this.dataSource;
  }
}
