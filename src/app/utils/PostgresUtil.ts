// src/app/utils/PostgresUtil.ts

import { HttpException, HttpStatus, Logger } from "@nestjs/common";
import { IDbReaderConfig } from "../generator/interfaces";
import { Client } from "pg";
import dns from "dns/promises";

export async function validateDatabaseConnection(
  dbConfig: IDbReaderConfig,
  logger: Logger,
): Promise<void> {
  const { host, port, user, password, database } = dbConfig;

  // Validação de host local
  const localHosts = ["localhost", "127.0.0.1", "::1"];
  if (localHosts.includes(host)) {
    logger.error(`Erro de configuração: O host ${host} é local.`);
    throw new HttpException(
      "Host não pode ser 'localhost' ou um IP local em uma configuração de rede.",
      HttpStatus.BAD_REQUEST,
    );
  }

  // Verificação de acessibilidade do host
  try {
    await dns.lookup(host);
  } catch (dnsError) {
    const errorMessage = (dnsError as Error).message;
    logger.error(`Host ${host} não está acessível na rede: ${errorMessage}`);
    throw new HttpException(
      `Host ${host} não acessível. Verifique a configuração de rede.`,
      HttpStatus.BAD_REQUEST,
    );
  }

  const client = new Client({ host, port, user, password, database });

  try {
    await client.connect();
    logger.log("Conexão com o banco de dados estabelecida com sucesso.");
  } catch (error: any) {
    logger.error(`Parâmetros de conexão: ${JSON.stringify(dbConfig, null, 2)}`);

    if (error.code === "ECONNREFUSED") {
      if (error.address === host) {
        logger.error("Erro de conexão: O host não está acessível.");
        throw new HttpException(
          "Host não acessível. Verifique o endereço do host.",
          HttpStatus.BAD_REQUEST,
        );
      }
      if (error.port === port) {
        logger.error("Erro de conexão: A porta do banco de dados não está acessível.");
        throw new HttpException(
          "Porta do banco de dados não acessível. Verifique a porta configurada.",
          HttpStatus.BAD_REQUEST,
        );
      }
    } else if (error.code === "28P01") {
      // erro de autenticação no PostgreSQL
      logger.error("Erro de autenticação: Usuário ou senha incorretos.");
      throw new HttpException(
        "Usuário ou senha incorretos. Verifique suas credenciais.",
        HttpStatus.UNAUTHORIZED,
      );
    } else {
      logger.error("Erro ao conectar ao banco de dados:", error.message);
      throw new HttpException(
        "Erro desconhecido ao conectar ao banco de dados.",
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  } finally {
    await client.end();
  }
}
