
// src/app/version/version.module.ts

import { Module } from "@nestjs/common";
import { GeneratorController } from "./generator.controller";
import { GeneratorService } from "./generator.service";
import { EnvironmentModule } from "../config/environment.module";

@Module({
	imports: [
		EnvironmentModule, // Importa o EnvironmentModule para usar neste modulo
	],
	providers: [GeneratorService], // Registra-os como provedores para serem utilizados por este módulo
	exports: [GeneratorService], // Exporta para que possa ser injetado em outros módulos
	controllers: [GeneratorController],
})
export class GeneratorModule {}
