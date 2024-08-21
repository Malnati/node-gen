
// src/utils/ConfigUtil.ts

import { Command } from 'commander';
import { DbReaderConfig } from '../interfaces';

export class ConfigUtil {
  public static getConfig(): DbReaderConfig {
    const program = new Command();

    program
      .option('-h, --host <type>', 'Host do banco de dados')
      .option('-p, --port <type>', 'Porta do banco de dados', '5432')
      .option('-d, --database <type>', 'Nome do banco de dados')
      .option('-u, --user <type>', 'Usuário do banco de dados')
      .option('-pw, --password <type>', 'Senha do banco de dados')
      .option('-o, --outputDir <type>', 'Diretório de saída para os arquivos gerados', './build')
      .option('-f, --outputFile <type>', 'Nome do arquivo de saída', 'db.reader.postgres.json')
      .parse(process.argv);

    const options = program.opts();

    return {
      host: options.host,
      port: parseInt(options.port, 10),
      database: options.database,
      user: options.user,
      password: options.password,
      outputDir: options.outputDir,
      outputFile: options.outputFile,
    };
  }
}