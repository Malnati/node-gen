
// src/app/config/environment.module.ts

import { Module } from "@nestjs/common";
import { EnvironmentService } from "./environment.service";
import { HttpModule } from "@nestjs/axios";
import { AppReadinessService } from "./app.readiness.service";

@Module({
  imports: [HttpModule], // Importa o HttpModule para usar o axios
  providers: [
    AppReadinessService,
    EnvironmentService,
  ], // Registra EnvironmentService, DataSourceService, HttpSourceService como um provedores para ser utilizado por este módulo
  exports: [
    AppReadinessService,
    EnvironmentService,
  ], // Exporta EnvironmentService, DataSourceService, HttpSourceService para que possam ser injetados em outros módulos
})
export class EnvironmentModule {}
