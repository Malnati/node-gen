// src/app/utils/ZipUtil.ts

import archiver from 'archiver';
import * as fs from 'fs';
import * as path from 'path';

export async function getRenamedFilePath(originalPath: string): Promise<string> {
	const now = new Date();
	const formattedDate = now.toISOString().replace(/[-T:]/g, '').slice(0, 13); // YYYYMMDDHHmm
	const dir = path.dirname(originalPath);
	const ext = path.extname(originalPath);
	const baseName = path.basename(originalPath, ext);
	return path.join(dir, `${baseName}.${formattedDate}${ext}`);
}

export async function zipDirectory(sourceDir: string, zipFilePath: string): Promise<string> {
	const absoluteZipPath = await getRenamedFilePath(path.resolve(zipFilePath));

	try {
		// Verifique se o diretório de origem existe
		if (!fs.existsSync(sourceDir)) {
			console.error(`Diretório de origem não encontrado: ${sourceDir}`);
			throw new Error(`Diretório de origem ${sourceDir} não existe.`);
		}

		console.log(`Iniciando criação do arquivo zip: ${absoluteZipPath}`);
		const output = fs.createWriteStream(absoluteZipPath);
		const archive = archiver('zip', { zlib: { level: 9 } });

		output.on('close', () => {
			console.log(`Arquivo zip criado com sucesso em: ${absoluteZipPath}`);
		});

		archive.on('error', (err: Error) => {
			console.error(`Erro ao criar arquivo zip: ${err.message}`);
			throw err;
		});

		archive.pipe(output);

		console.log(`Adicionando diretório ao zip: ${sourceDir}`);
		archive.directory(sourceDir, false);

		await archive.finalize();
		console.log('Processo de arquivamento finalizado.');

		return absoluteZipPath;

	} catch (error) {
		if (error instanceof Error) {
			console.error(`Erro durante o processo de criação do zip: ${error.message}`);
			throw new Error(`Erro ao gerar o arquivo zip: ${error.message}`);
		} else {
			console.error('Erro durante o processo de criação do zip: erro desconhecido');
			throw new Error('Erro ao gerar o arquivo zip: erro desconhecido');
		}
	}
}
