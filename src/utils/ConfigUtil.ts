
// src/utils/ConfigUtil.ts

import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { DbReaderConfig } from '../interfaces';

export class ConfigUtil {
  public static getConfig(): DbReaderConfig {
    const argv = yargs(hideBin(process.argv))
      .option('host', {
        alias: 'h',
        description: 'Host do banco de dados',
        type: 'string',
        demandOption: true,
      })
      .option('port', {
        alias: 'p',
        description: 'Porta do banco de dados',
        type: 'number',
        default: 5432,
      })
      .option('database', {
        alias: 'd',
        description: 'Nome do banco de dados',
        type: 'string',
        demandOption: true,
      })
      .option('user', {
        alias: 'u',
        description: 'Usuário do banco de dados',
        type: 'string',
        demandOption: true,
      })
      .option('password', {
        alias: 'pw',
        description: 'Senha do banco de dados',
        type: 'string',
        demandOption: true,
      })
      .option('outputDir', {
        alias: 'o',
        description: 'Diretório de saída para os arquivos gerados',
        type: 'string',
        default: './build',
      })
      .option('outputFile', {
        alias: 'f',
        description: 'Nome do arquivo de saída',
        type: 'string',
        default: 'db.reader.postgres.json',
      })
      .help()
      .alias('help', 'h')
      .argv as DbReaderConfig;

    return argv; // Retornar diretamente o argv, que já é do tipo DbReaderConfig
  }
}