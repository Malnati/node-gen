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
    const defaultSessionVerify = process.env.ENDPOINT_SESSION_VERIFY ?? 'https://localhost/session/verify';
    const defaultSessionHealth = process.env.ENDPOINT_SESSION_HEALTH ?? 'https://localhost/health';

    const envConfig = {
      DATABASE_HOST: this.config.host ?? '',
      DATABASE_PORT: (this.config.port != null ? this.config.port : 5432).toString(),
      DATABASE_NAME: this.config.database ?? '',
      DATABASE_USER: this.config.user ?? '',
      DATABASE_PASSWORD: this.config.password ?? '',
      DATABASE_TYPE: this.config.dbType ?? 'postgres',
      DATABASE_PATH: this.config.dbType === 'sqlite' ? (this.config.database ?? '') : '',
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