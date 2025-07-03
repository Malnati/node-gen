import { Module } from "@nestjs/common";
import { HttpModule } from "@nestjs/axios";
import { {{entityName}}Service } from "./{{kebabCaseName}}.service";
import { EnvironmentModule } from "../config/environment.module";
import { {{entityName}}Controller } from "./{{kebabCaseName}}.controller";
import { JwtAuthGuardModule } from "../middleware/jwt-auth.guard.module";
import { JwtAuthGuard } from "../middleware/jwt-auth.guard";

@Module({
  imports: [
    HttpModule,
    EnvironmentModule, // Importa o EnvironmentModule para usar o EnvironmentService e o DataSourceService
    JwtAuthGuardModule, // Importa o JwtAuthGuardModule para usar o JwtAuthGuard
  ],
  providers: [{{entityName}}Service, JwtAuthGuard], // Registra-os como um provedores para ser utilizado por este módulo
  exports: [{{entityName}}Service], // Exporta o {{entityName}}Service para que possa ser injetado em outros módulos
  controllers: [{{entityName}}Controller],
})
export class {{entityName}}Module {}
