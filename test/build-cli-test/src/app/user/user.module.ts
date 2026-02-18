// /templates/module.template.ts
import { Module } from "@nestjs/common"; // Define os módulos do NestJS
import { HttpModule } from "@nestjs/axios"; // Permite realizar chamadas HTTP
import { UserService } from "./user.service"; // Lógica de negócio de User
import { EnvironmentModule } from "../config/environment.module"; // Acesso às configurações de ambiente
import { UserController } from "./user.controller"; // Controlador das rotas de User
import { JwtAuthGuardModule } from "../middleware/jwt-auth.guard.module"; // Módulo com as dependências do JwtAuthGuard
import { JwtAuthGuard } from "../middleware/jwt-auth.guard"; // Guarda de autenticação JWT

@Module({
  imports: [
    HttpModule,
    EnvironmentModule,
    JwtAuthGuardModule,
  ],
  providers: [UserService, JwtAuthGuard], // Registra-os como um provedores para ser utilizado por este módulo
  exports: [UserService], // Exporta o UserService para que possa ser injetado em outros módulos
  controllers: [UserController],
})
/**
 * Módulo responsável por organizar as dependências e o controlador
 * relacionados à entidade User.
 */
export class UserModule {}
