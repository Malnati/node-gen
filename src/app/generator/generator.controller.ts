import { Body, Controller, Logger, Post, Res, HttpException, HttpStatus, BadRequestException } from "@nestjs/common";
import * as fs from 'fs';
import { Response } from 'express';
import { GeneratorService } from "./generator.service";
import { DbConfigDto } from "./db.config.dto"
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import path from "path";

@Controller("Generator")
@ApiTags("Code Generation")
export class GeneratorController {
	private readonly logger = new Logger(GeneratorController.name);

	constructor(private readonly generatorService: GeneratorService) { }

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
		let zipPath = '';
		let absoluteZipPath = '';
		try {
			this.validateConfig(config);
			zipPath = await this.generatorService.generate(config);

			absoluteZipPath = path.resolve(zipPath);
			if (!fs.existsSync(absoluteZipPath)) {
				throw new HttpException('Arquivo ZIP não encontrado', HttpStatus.INTERNAL_SERVER_ERROR);
			}

			res.setHeader('Content-Type', 'application/zip');
			res.setHeader('Content-Disposition', `attachment; filename=${path.basename(absoluteZipPath)}`);

			// Envia o arquivo e encerra a resposta
			res.sendFile(absoluteZipPath, (err) => {
				if (err) {
					this.logger.error(`Erro ao enviar o arquivo: ${err.message}`);
					res.status(HttpStatus.INTERNAL_SERVER_ERROR).send('Falha ao enviar o arquivo zip.');
				} else {
					res.end();  // Finaliza a resposta explicitamente
				}
			});

		} catch (error: any) {
			this.logger.error(`Erro durante a geração de código: ${error.message}`);
			if (error instanceof HttpException) {
				res.status(error.getStatus()).json({ message: error.message });
			} else if (error.code === 'EEXIST') {
				res.status(HttpStatus.CONFLICT).json({ message: 'Conflito: O recurso já existe.' });
			} else if (error.name === 'ValidationError') {
				res.status(HttpStatus.BAD_REQUEST).json({ message: 'Dados inválidos. Verifique os parâmetros de entrada.' });
			} else {
				this.logger.error(error);
				res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({ message: 'Erro ao gerar o código. Tente novamente mais tarde.' });
			}
		}
	}

	private validateConfig(config: DbConfigDto) {
		const requiredFields = ['host', 'port', 'user', 'password', 'database'];
		for (const field of requiredFields) {
			if (!(config as any)[field]) {
				throw new BadRequestException(`O campo "${field}" é obrigatório e não pode estar vazio.`);
			}
		}
	}
}
