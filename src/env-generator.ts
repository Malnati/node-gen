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
    const envConfig = {
      DATABASE_HOST: this.config.host,
      DATABASE_PORT: this.config.port.toString(),
      DATABASE_NAME: this.config.database,
      DATABASE_USER: this.config.user,
      DATABASE_PASSWORD: this.config.password,
      DATABASE_TYPE: this.config.dbType,
      DATABASE_PATH: this.config.dbType === 'sqlite' ? this.config.database : '',
      ENDPOINT_SESSION_TOKEN: 'https://biud-microservice-session.dev.biud.services/session/verify',
      ENDPOINT_SESSION_HEALTHCHECK: 'https://biud-microservice-session.dev.biud.services/health',
      MICROSERVICE_NAME: this.config.app,
      PORT: '3001'
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