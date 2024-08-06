import * as fs from 'fs';
import * as path from 'path';

class EnvFileGenerator {
  private envConfig: { [key: string]: string } = {
    DATABASE_HOST: '34.134.67.65',
    DATABASE_PORT: '5432',
    DATABASE_NAME: 'biud_optout',
    DATABASE_USER: 'biud_optout',
    DATABASE_PASSWORD: 'ios5iUJT-432.1l0',
    ENDPOINT_SESSION_TOKEN: 'https://biud-microservice-session.dev.biud.services/session/verify',
    ENDPOINT_SESSION_HEALTHCHECK: 'https://biud-microservice-session.dev.biud.services/health',
    MICROSERVICE_NAME: 'Micro-servico OPT-OUT',
    PORT: '3001'
  };

  generateEnvFile(outputDir: string) {
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const envFileContent = this.generateEnvFileContent();
    const filePath = path.join(outputDir, '.env');
    fs.writeFileSync(filePath, envFileContent);

    console.log(`.env file has been generated in ${outputDir}`);
  }

  private generateEnvFileContent(): string {
    return Object.entries(this.envConfig)
      .map(([key, value]) => `${key}='${value}'`)
      .join('\n');
  }
}

// Usage
const outputDir = path.join(__dirname, 'build');

const generator = new EnvFileGenerator();
generator.generateEnvFile(outputDir);