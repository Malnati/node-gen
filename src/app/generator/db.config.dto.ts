// src/app/generator/db-reader-config.dto.ts

import { ApiProperty } from '@nestjs/swagger';
import { TComponents } from './interfaces';

export class DbConfigDto {
  @ApiProperty({ description: 'Nome da aplicação que utiliza o banco de dados', example: 'myApp' })
	app: string = 'myApp';

  @ApiProperty({ description: 'Host do banco de dados', example: 'localhost' })
	host: string = "localhost";

  @ApiProperty({ description: 'Porta de conexão com o banco de dados', example: 5432 })
	port: number = 5432;

  @ApiProperty({ description: 'Nome do banco de dados', example: 'postgres' })
	database: string = 'postgres';

  @ApiProperty({ description: 'Nome do usuário para autenticação no banco de dados', example: 'postgres' })
	user: string = 'postgres';

  @ApiProperty({ description: 'Senha do usuário para autenticação', example: 'postgres' })
	password: string = 'postgres';

  @ApiProperty({ description: 'Diretório onde os arquivos gerados serão salvos', example: './output' })
	outputDir: string = './output';

  @ApiProperty({
		description: 'Tipos de componentes a serem gerados',
		type: 'array',
		items: { type: 'string', enum: ['entities', 'services', 'interfaces', 'controllers', 'dtos', 'modules', 'app-module', 'main', 'env', 'package.json', 'readme', 'datasource', 'diagram'] },
		example: ['entities', 'services', 'controllers']
	})
	components: TComponents = ['entities', 'services', 'interfaces', 'controllers', 'dtos', 'modules', 'app-module', 'main', 'env', 'package.json', 'readme', 'datasource', 'diagram'];

  @ApiProperty({ description: 'Tipo de banco de dados utilizado', enum: ['mysql', 'postgres'], example: 'postgres' })
	dbType: 'mysql' | 'postgres' = 'postgres';
}
