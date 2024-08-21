#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig } from './interfaces';

export class EnvGenerator {
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.config = config;
  }

  generateEnvFile() {
    const envConfig = {
      DATABASE_HOST: this.config.host,
      DATABASE_PORT: this.config.port.toString(),
      DATABASE_NAME: this.config.database,
      DATABASE_USER: this.config.user,
      DATABASE_PASSWORD: this.config.password,
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