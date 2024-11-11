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
		const startTime = Date.now(); // Marca o início da execução

		try {
			this.logger.log('Validação de configuração iniciada.');
			this.validateConfig(config);

			this.logger.log('Iniciando geração do código no serviço.');
			const zipPath = await this.generatorService.generate(config);
			this.logger.log(`Código gerado no caminho ${zipPath} em ${Date.now() - startTime} ms.`);

			const absoluteZipPath = path.resolve(zipPath);
			this.logger.log(`Verificando a existência do arquivo ZIP em ${absoluteZipPath}`);

			if (!fs.existsSync(absoluteZipPath)) {
				throw new HttpException('Arquivo ZIP não encontrado', HttpStatus.INTERNAL_SERVER_ERROR);
			}

			this.logger.log(`Arquivo ZIP encontrado: ${absoluteZipPath}. Preparando resposta...`);
			res.setHeader('Content-Type', 'application/zip');
			res.setHeader('Content-Disposition', `attachment; filename=${path.basename(absoluteZipPath)}`);

			this.logger.log('Enviando o arquivo ZIP como resposta...');
			res.sendFile(absoluteZipPath, (err) => {
				if (err) {
					this.logger.error(`Erro ao enviar o arquivo: ${err.message}`);
					res.status(HttpStatus.INTERNAL_SERVER_ERROR).send('Falha ao enviar o arquivo zip.');
				} else {
					this.logger.log('Arquivo enviado com sucesso.');
					res.end();  // Finaliza a resposta explicitamente
				}
			});

		} catch (error: any) {
			this.logger.error(`Erro durante a geração de código: ${error.message}`);
			if (error instanceof HttpException) {
				res.status(error.getStatus()).json({ message: error.message });
			} else {
				res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({ message: 'Erro ao gerar o código. Tente novamente mais tarde.' });
			}
		}
		this.logger.log(`Tempo total de processamento: ${Date.now() - startTime} ms.`);
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
