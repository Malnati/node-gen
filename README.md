# Node.js Project Generator

Este repositório contém um conjunto de geradores TypeScript para criar a estrutura de um projeto NestJS completo, incluindo módulos, controladores, serviços, entidades TypeORM, DTOs e arquivos de configuração.

## Instalação

O *node-gen* é um pacote Node.js que pode ser instalado globalmente via npm. O registro estaá disponível em [@codegenerator/node-gen](https://www.npmjs.com/package/@codegenerator/node-gen), então você pode instalar o pacote diretamente a partir do NPM.


Para instalar todas as dependências necessárias, execute o comando:

```bash
npm install -g @codegenerator/node-gen
```

## Uso

Este repositório contém vários geradores para criar diferentes partes de um projeto NestJS. Aqui está uma breve descrição de cada gerador:

```bash
    DB_HOST=99.999.99.99 DB_PORT=5432 DB_NAME=db DB_USER=user DB_PASSWORD='********' ./db.reader.postgres.sh
```


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

## publicação

Para atualizar no NPM, execute um dos os comandos:

```bash
npm run publish:patch
```
ou
```bash
npm run publish:minor
```
ou
```bash
npm run publish:major
```


## Pre-requisitos

Crie seu modelo relacional no PostgreSQL e em seguida execute o script abaixo para criar as funções e triggers necessários para garantir a integridade dos dados.

```SQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
SELECT uuid_generate_v4();

CREATE FUNCTION public.prevent_created_at_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD IS NOT NULL AND NEW.created_at <> OLD.created_at THEN
        RAISE EXCEPTION 'Não é possível atualizar o campo created_at após a criação do registro.';
    END IF;
    RETURN NEW;
END;
$$;

CREATE FUNCTION public.prevent_deleted_at_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD IS NOT NULL AND OLD.created_at IS NOT null THEN
        RAISE EXCEPTION 'Não é possível atualizar o campo deleted_at.';
    END IF;
    RETURN NEW;
END;
$$;

CREATE FUNCTION public.prevent_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE EXCEPTION 'Não é possível excluir o registro. Operação não permitida.';
    RETURN NEW;
END;
$$;

CREATE FUNCTION public.prevent_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE EXCEPTION 'Não é possível atualizar o registro. Operação não permitida.';
    RETURN NEW;
END;
$$;

DO $$
DECLARE
    tbl RECORD;
    col_exists BOOLEAN;
    trg_update_name TEXT;
    trg_delete_name TEXT;
    trg_update_deleted_at_name TEXT;
    index_name TEXT;
BEGIN
    -- Lista todas as tabelas no esquema public com prefixo 'tb_'
    FOR tbl IN 
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'public' AND tablename LIKE 'tb_%'
    LOOP
        -- Verifica se a coluna 'created_at' já existe na tabela
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.columns 
            WHERE table_schema = 'public' 
              AND table_name = tbl.tablename 
              AND column_name = 'created_at'
        ) INTO col_exists;

        -- Se a coluna não existir, adiciona a coluna 'created_at'
        IF NOT col_exists THEN
            EXECUTE format('ALTER TABLE %I ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP', tbl.tablename);
        END IF;

        -- Adiciona ou atualiza o comentário na coluna 'created_at'
        EXECUTE format('COMMENT ON COLUMN %I.created_at IS ''Data de criação do registro.''', tbl.tablename);

        -- Verifica se a coluna 'updated_at' já existe na tabela
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.columns 
            WHERE table_schema = 'public' 
              AND table_name = tbl.tablename 
              AND column_name = 'updated_at'
        ) INTO col_exists;

        -- Se a coluna não existir, adiciona a coluna 'updated_at'
        IF NOT col_exists THEN
            EXECUTE format('ALTER TABLE %I ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP', tbl.tablename);
        END IF;

        -- Adiciona ou atualiza o comentário na coluna 'updated_at'
        EXECUTE format('COMMENT ON COLUMN %I.updated_at IS ''Data de atualização do registro.''', tbl.tablename);

        -- Verifica se a coluna 'deleted_at' já existe na tabela
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.columns 
            WHERE table_schema = 'public' 
              AND table_name = tbl.tablename 
              AND column_name = 'deleted_at'
        ) INTO col_exists;

        -- Se a coluna não existir, adiciona a coluna 'deleted_at'
        IF NOT col_exists THEN
            EXECUTE format('ALTER TABLE %I ADD COLUMN deleted_at TIMESTAMP', tbl.tablename);
        END IF;

        -- Adiciona ou atualiza o comentário na coluna 'deleted_at'
        EXECUTE format('COMMENT ON COLUMN %I.deleted_at IS ''Data da exclusão lógica do registro.''', tbl.tablename);

        -- Verifica se a coluna 'external_id' já existe na tabela
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.columns 
            WHERE table_schema = 'public' 
              AND table_name = tbl.tablename 
              AND column_name = 'external_id'
        ) INTO col_exists;

        -- Se a coluna não existir, adiciona a coluna 'external_id'
        IF NOT col_exists THEN
            EXECUTE format('ALTER TABLE %I ADD COLUMN external_id UUID DEFAULT uuid_generate_v4() NOT NULL', tbl.tablename);
        END IF;

        -- Adiciona ou atualiza o comentário na coluna 'external_id'
        EXECUTE format('COMMENT ON COLUMN %I.external_id IS ''Identificador único externo de registros desta tabela. Este campo é obrigatório.''', tbl.tablename);

        -- Nome do índice único na coluna 'external_id'
        index_name := tbl.tablename || '_external_id_idx';

        -- Cria o índice único na coluna 'external_id' se não existir
        IF NOT EXISTS (
            SELECT 1 
            FROM pg_indexes 
            WHERE tablename = tbl.tablename
              AND indexname = index_name
        ) THEN
            EXECUTE format('CREATE UNIQUE INDEX %I ON %I (external_id)', index_name, tbl.tablename);
        END IF;
        
        -- Nome das triggers baseado no nome da tabela
        trg_update_name := tbl.tablename || '_fire_update_rules';
        trg_delete_name := tbl.tablename || '_fire_delete_rules';
        trg_update_deleted_at_name := tbl.tablename || '_fire_update_deleted_at_rules';
        
        -- Verifica se a trigger de update já existe e a remove se necessário
        IF EXISTS (
            SELECT 1 
            FROM pg_trigger 
            WHERE tgname = trg_update_name 
              AND tgrelid = tbl.tablename::regclass
        ) THEN
            EXECUTE format('DROP TRIGGER %I ON %I', trg_update_name, tbl.tablename);
        END IF;

        -- Cria a trigger de update
        EXECUTE format('
            CREATE TRIGGER %I 
            BEFORE UPDATE ON %I 
            FOR EACH ROW 
            EXECUTE FUNCTION public.prevent_created_at_update();
        ', trg_update_name, tbl.tablename);

        -- Verifica se a trigger de delete já existe e a remove se necessário
        IF EXISTS (
            SELECT 1 
            FROM pg_trigger 
            WHERE tgname = trg_delete_name 
              AND tgrelid = tbl.tablename::regclass
        ) THEN
            EXECUTE format('DROP TRIGGER %I ON %I', trg_delete_name, tbl.tablename);
        END IF;

        -- Cria a trigger de delete
        EXECUTE format('
            CREATE TRIGGER %I 
            BEFORE DELETE ON %I 
            FOR EACH ROW 
            EXECUTE FUNCTION public.prevent_delete();
        ', trg_delete_name, tbl.tablename);

        -- Verifica se a trigger de update em 'deleted_at' já existe e a remove se necessário
        IF EXISTS (
            SELECT 1 
            FROM pg_trigger 
            WHERE tgname = trg_update_deleted_at_name 
              AND tgrelid = tbl.tablename::regclass
        ) THEN
            EXECUTE format('DROP TRIGGER %I ON %I', trg_update_deleted_at_name, tbl.tablename);
        END IF;

        -- Cria a trigger de update em 'deleted_at'
        EXECUTE format('
            CREATE TRIGGER %I 
            BEFORE UPDATE ON %I 
            FOR EACH ROW 
            EXECUTE FUNCTION public.prevent_deleted_at_update();
        ', trg_update_deleted_at_name, tbl.tablename);

    END LOOP;
END $$;
```