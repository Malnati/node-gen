# Node.js Project Generator

Este repositório contém um conjunto de geradores TypeScript para criar a estrutura de um projeto NestJS completo, incluindo módulos, controladores, serviços, entidades TypeORM, DTOs e arquivos de configuração.

## Estrutura do Projeto

```bash
.
├── LICENSE
├── README.md
├── app-module-generator.ts
├── controller-generator.ts
├── db.reader.postgres.sh
├── db.reader.postgres.ts
├── dto-generator.ts
├── env-generator.ts
├── interface-generator.ts
├── interfaces.ts
├── main-generator.ts
├── module-generator.ts
├── package-json-generator.ts
├── package-lock.json
├── package.json
├── readme-generator.ts
├── service-generator.ts
├── static
│   ├── add-header.js
│   ├── bitbucket-pipelines.yml
│   ├── config
│   │   ├── app.readiness.service.ts
│   │   ├── datasource.service.ts
│   │   ├── environment.module.ts
│   │   ├── environment.service.ts
│   │   └── httpsource.service.ts
│   ├── docker-compose.yaml
│   ├── docker-start.sh
│   ├── health
│   │   ├── health.controller.ts
│   │   ├── health.database.indicator.ts
│   │   ├── health.module.ts
│   │   └── health.service.ts
│   ├── jest.config.ts
│   ├── middleware
│   │   ├── jwt-auth.guard.module.ts
│   │   └── jwt-auth.guard.ts
│   ├── tsconfig.build.json
│   ├── tsconfig.json
│   ├── validators
│   │   └── constraint.isRecentDate.ts
│   └── version
│       ├── version.controller.ts
│       └── version.module.ts
├── tsconfig.json
└── typeorm-entity-generator.ts
```

## Instalação

Para instalar todas as dependências necessárias, execute o comando:

```bash
npm install
```

## Uso

Este repositório contém vários geradores para criar diferentes partes de um projeto NestJS. Aqui está uma breve descrição de cada gerador:

- **db.reader.postgres.ts**: Lê a estrutura do banco de dados PostgreSQL e gera um arquivo JSON com a definição do esquema.
- **typeorm-entity-generator.ts**: Gera entidades TypeORM com base na definição do esquema.
- **service-generator.ts**: Gera serviços NestJS com base nas entidades geradas.
- **interface-generator.ts**: Gera interfaces para as entidades e serviços.
- **controller-generator.ts**: Gera controladores NestJS com base nos serviços gerados.
- **dto-generator.ts**: Gera DTOs (Data Transfer Objects) com base nas entidades geradas.
- **module-generator.ts**: Gera módulos NestJS com base nos controladores e serviços gerados.
- **app-module-generator.ts**: Gera o módulo principal do aplicativo NestJS.
- **main-generator.ts**: Gera o arquivo de entrada principal do aplicativo NestJS.
- **env-generator.ts**: Gera arquivos de configuração de ambiente.
- **package-json-generator.ts**: Gera o arquivo `package.json` para o projeto.
- **readme-generator.ts**: Gera o arquivo `README.md` para o projeto gerado.

## Executando o Gerador

Para executar o gerador e criar toda a estrutura do projeto, use o script `db.reader.postgres.sh`:

```bash
./db.reader.postgres.sh
```

Este script executará todos os geradores na ordem correta e copiará os arquivos estáticos para o diretório `./build`.

## Estrutura do Projeto Gerado

Após a execução do script, a estrutura do projeto gerado será semelhante a esta:

```bash
./build
├── LICENSE
├── README.md
├── app.module.ts
├── controller
│   ├── example.controller.ts
├── dto
│   ├── create-example.dto.ts
│   ├── update-example.dto.ts
├── entity
│   ├── example.entity.ts
├── interface
│   ├── example.interface.ts
├── main.ts
├── module
│   ├── example.module.ts
├── service
│   ├── example.service.ts
├── static
│   ├── add-header.js
│   ├── bitbucket-pipelines.yml
│   ├── config
│   │   ├── app.readiness.service.ts
│   │   ├── datasource.service.ts
│   │   ├── environment.module.ts
│   │   ├── environment.service.ts
│   │   └── httpsource.service.ts
│   ├── docker-compose.yaml
│   ├── docker-start.sh
│   ├── health
│   │   ├── health.controller.ts
│   │   ├── health.database.indicator.ts
│   │   ├── health.module.ts
│   │   └── health.service.ts
│   ├── jest.config.ts
│   ├── middleware
│   │   ├── jwt-auth.guard.module.ts
│   │   └── jwt-auth.guard.ts
│   ├── tsconfig.build.json
│   ├── tsconfig.json
│   ├── validators
│   │   └── constraint.isRecentDate.ts
│   └── version
│       ├── version.controller.ts
│       └── version.module.ts
```

## Executando o Projeto Gerado

Para executar o projeto gerado, use os seguintes comandos:

1. Navegue até o diretório `./build`:
   ```bash
   cd build
   ```

2. Instale as dependências do projeto gerado:
   ```bash
   npm install
   ```

3. Inicie o projeto:
   ```bash
   npm start
   ```

Isso iniciará o servidor NestJS usando as configurações geradas.

---

### Licença

Este projeto é licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.
```

Para adicionar o gerador de README ao script `db.reader.postgres.sh`, basta incluir a chamada ao `readme-generator.ts` no final do script:

```sh
rm -rf ./build

npx ts-node db.reader.postgres.ts
npx ts-node typeorm-entity-generator.ts
npx ts-node service-generator.ts
npx ts-node interface-generator.ts
npx ts-node controller-generator.ts
npx ts-node dto-generator.ts
npx ts-node module-generator.ts
npx ts-node app-module-generator.ts
npx ts-node main-generator.ts
npx ts-node env-generator.ts
npx ts-node package-json-generator.ts
npx ts-node readme-generator.ts

cp -r ./static/* ./build/
```
