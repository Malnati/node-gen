// /src/env-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig } from './interfaces';

export class EnvGenerator {
  private config: DbReaderConfig;

  constructor(config: DbReaderConfig) {
    this.config = config;
  }

  generateEnvFile() {
    const defaultPort = '3001';
    const defaultSessionVerify = 'https://biud-microservice-session.dev.biud.services/session/verify';
    const defaultSessionHealth = 'https://biud-microservice-session.dev.biud.services/health';

    const envConfig = {
      DATABASE_HOST: this.config.host,
      DATABASE_PORT: this.config.port.toString(),
      DATABASE_NAME: this.config.database,
      DATABASE_USER: this.config.user,
      DATABASE_PASSWORD: this.config.password,
      DATABASE_TYPE: this.config.dbType,
      DATABASE_PATH: this.config.dbType === 'sqlite' ? this.config.database : '',
      ENDPOINT_SESSION_TOKEN: process.env.ENDPOINT_SESSION_TOKEN ?? defaultSessionVerify,
      ENDPOINT_SESSION_HEALTHCHECK: process.env.ENDPOINT_SESSION_HEALTHCHECK ?? defaultSessionHealth,
      MICROSERVICE_NAME: this.config.app,
      PORT: process.env.PORT ?? defaultPort,
    };

    const envFileContent = Object.entries(envConfig)
      .map(([key, value]) => `${key}='${value}'`)
      .join('\n');

    const buildDir = this.config.outputDir;
    
    if (!fs.existsSync(buildDir)) {
      fs.mkdirSync(buildDir, { recursive: true });
    }

    const filePath = path.join(buildDir, '.env');
    fs.writeFileSync(filePath, envFileContent);

    console.log(`.env file has been generated in ${buildDir}`);
  }
}