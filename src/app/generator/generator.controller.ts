// src/app/generator/generator.controller.ts

import { Body, Controller, Logger, Post, Res } from "@nestjs/common";
import * as fs from 'fs';
import { Response } from 'express';
import { ApiTags } from "@nestjs/swagger";
import { GeneratorService } from "./generator.service";
import { IDbReaderConfig } from "./interfaces";

@Controller("version")
@ApiTags("Version Check")
export class GeneratorController {
  private readonly logger = new Logger(GeneratorController.name);

  constructor(private readonly generatorService: GeneratorService) {}

  @Post()
  async generateCode(@Body() config: IDbReaderConfig, @Res() res: Response) {
    try {
      const service = new GeneratorService();
      const zipPath = await service.generate(config);

      res.setHeader('Content-Type', 'application/zip');
      res.setHeader('Content-Disposition', `attachment; filename=generated_code.zip`);
      res.sendFile(zipPath, (err) => {
        if (err) {
          this.logger.error(`Erro ao enviar o arquivo: ${err.message}`);
        }
        // Exclua o arquivo zip temporário após o envio
        fs.unlinkSync(zipPath);
      });
    } catch (error: any) {
      this.logger.error(`Erro durante a geração de código: ${error.message}`);
      res.status(500).json({ message: 'Erro ao gerar o código.' });
    }
  }
}
