
// src/app/version/version.module.ts

import { Module } from "@nestjs/common";
import { GeneratorController } from "./generator.controller";

@Module({
  controllers: [GeneratorController],
})
export class GeneratorModule {}
