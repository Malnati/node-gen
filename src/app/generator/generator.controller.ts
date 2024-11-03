import { Body, Controller, Logger, Post, Res, HttpException, HttpStatus } from "@nestjs/common";
import * as fs from 'fs';
import { Response } from 'express';
import { GeneratorService } from "./generator.service";
import { DbConfigDto } from "./db.config.dto"
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';

@Controller("Generator")
@ApiTags("Code Generation")
export class GeneratorController {
  private readonly logger = new Logger(GeneratorController.name);

  constructor(private readonly generatorService: GeneratorService) {}

  @ApiOperation({
    summary: 'Geração de código e download de arquivo zip',
    description: 'Gera um arquivo zip contendo o código-fonte com base nas configurações fornecidas.',
  })
  @ApiResponse({
    status: 201,
    description: 'O arquivo zip foi criado e está disponível para download.',
    schema: {
      type: 'string',
      format: 'binary',
    },
  })
  @ApiResponse({ status: 400, description: 'Dados inválidos. Verifique os parâmetros de entrada.' })
  @ApiResponse({ status: 409, description: 'Conflito: item existente ou conflito nos dados fornecidos.' })
  @ApiResponse({ status: 500, description: 'Erro interno no servidor ao processar o pedido.' })
  @Post()
  async generateCode(@Body() config: DbConfigDto, @Res() res: Response) {
    try {
      const zipPath = await this.generatorService.generate(config);

      res.setHeader('Content-Type', 'application/zip');
      res.setHeader('Content-Disposition', `attachment; filename=generated_code.zip`);
      res.sendFile(zipPath, (err) => {
        if (err) {
          this.logger.error(`Erro ao enviar o arquivo: ${err.message}`);
          throw new HttpException('Falha ao enviar o arquivo zip.', HttpStatus.INTERNAL_SERVER_ERROR);
        }
        fs.unlinkSync(zipPath); // Exclui o arquivo zip temporário após o envio
      });
    } catch (error: any) {
      this.handleException(error, res);
    }
  }

  private handleException(error: any, res: Response) {
    this.logger.error(`Erro durante a geração de código: ${error.message}`);

    if (error instanceof HttpException) {
      res.status(error.getStatus()).json({ message: error.message });
    } else if (error.code === 'EEXIST') {
      res.status(HttpStatus.CONFLICT).json({ message: 'Conflito: O recurso já existe.' });
    } else if (error.name === 'ValidationError') {
      res.status(HttpStatus.BAD_REQUEST).json({ message: 'Dados inválidos. Verifique os parâmetros de entrada.' });
    } else {
      res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({ message: 'Erro ao gerar o código. Tente novamente mais tarde.' });
    }
  }
}
