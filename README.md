<!-- /README.md -->
# Node.js Project Generator

Este repositório contém um conjunto de geradores TypeScript para criar a estrutura de um projeto NestJS completo, incluindo módulos, controladores, serviços, entidades TypeORM, DTOs e arquivos de configuração.

## Estrutura do repositório

- **`gen/`** — aplicativo gerador (node-gen): `package.json`, `src/`, `static/`, `templates/`, `tsconfig.json`. Build com `cd gen && npm run build` ou, na raiz, `npm run build`.
- **`test/`** — testes e mocks:
  - **`test/e2e-generator/`** — testes e2e do gerador contra o mock; contém `schema.sql`, scripts de criação do banco, `connection.json` e `mock.sqlite`. Saída do gerador (E2E e teste CLI) em `output/` na raiz.

## Instalação

O *node-gen* é um pacote Node.js que pode ser instalado globalmente via npm. O registro estaá disponível em [@codegenerator/node-gen](https://www.npmjs.com/package/@codegenerator/node-gen), então você pode instalar o pacote diretamente a partir do NPM.


Para instalar todas as dependências necessárias, execute o comando:

```bash
npm install -g @codegenerator/node-gen
```

## Uso:

Este repositório contém vários geradores para criar diferentes partes de um projeto NestJS. Aqui está uma breve descrição de cada gerador:

```bash
cd gen && npm run build && \
    node dist/main.js \
                    --app "myapp" \
                    --host "localhost" \
                    --port "5432" \
                    --database "myapp_db" \
                    --user "myapp_user" \
                    --password "********************" \
                    --outputDir "./build" \
                    --templateDir "./templates" \
                    --components "entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource, diagram"

```

## Executando o Gerador

Para executar o gerador e criar toda a estrutura do projeto, use o comando `node-gen`:

```bash
node-gen \
    --app "myapp" \
    --host "localhost" \
    --port "5432" \
    --database "myapp_db" \
    --user "myapp_user" \
    --password "********************" \
    --outputDir "./build" \
    --templateDir "./templates" \
    --components "entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource, diagram"
```

Este comando executará todos os geradores na ordem correta e copiará os arquivos estáticos para o diretório de destino.
Você pode fornecer `--templateDir` para usar um diretório personalizado de templates. Se omitido, o diretório `static` deste projeto será utilizado.

### Usando o SQLite para Testes

Para executar o gerador contra um banco SQLite, use o mock (criar com `node test/e2e-generator/create-db.js`) ou os scripts em `test/e2e-generator/projects/todo/db/` (ex.: `database.sqlite.ddl`, `database.sqlite.sql`). Exemplo com o mock:

```bash
node test/e2e-generator/create-db.js
cd gen && node dist/main.js -a myapp -d ../test/e2e-generator/mock.sqlite -u x -pw x -o ../build -t sqlite -f "entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource,diagram"
```

Ou, na raiz, após `npm run build`: `node gen/dist/main.js ...` com os mesmos parâmetros.

### Usando o MySQL para Testes

Para utilizar o gerador com um banco MySQL, crie primeiro o banco de dados e
carregue os scripts de modelagem e dados:

```bash
mysql -u <usuario> -p -e "CREATE DATABASE IF NOT EXISTS <database>;"
mysql -u <usuario> -p <database> < test/e2e-generator/projects/todo/db/database.mysql.ddl
mysql -u <usuario> -p <database> < test/e2e-generator/projects/todo/db/database.mysql.sql
```

Depois execute o gerador informando `--dbType mysql` e apontando para o banco:

```bash
node-gen \
  --dbType mysql \
  --database <database> \
  --outputDir "./build"
```

### Usando o SQLServer para Testes

O banco SQLServer deve ser criado dinamicamente a partir dos scripts
`test/e2e-generator/projects/todo/db/database.mysql.ddl` e `database.mysql.sql` (e equivalentes para postgres, sqlite, sqlserver). Nenhum arquivo de banco é
versionado no repositório.

```bash
sqlcmd -S <servidor> -U <usuario> -P <senha> -Q "CREATE DATABASE <database>"
sqlcmd -S <servidor> -U <usuario> -P <senha> -d <database> -i test/e2e-generator/projects/todo/db/database.sqlserver.ddl
sqlcmd -S <servidor> -U <usuario> -P <senha> -d <database> -i test/e2e-generator/projects/todo/db/database.sqlserver.sql
```

Depois execute o gerador informando `--dbType sqlserver` e os detalhes de
conexão:

```bash
node-gen \
  --dbType sqlserver \
  --database <database> \
  --outputDir "./build"
```

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

### Exemplo de DTO Gerado

```ts
import { IsNotEmpty, IsString } from 'class-validator'
import { ApiProperty } from '@nestjs/swagger'
import { IExampleQueryDTO, IExamplePersistDTO } from './example.interface'

/** DTO usado para consultas de Example. */
export class ExampleQueryDTO implements IExampleQueryDTO {
  @IsNotEmpty()
  @IsString()
  @ApiProperty({ example: 'exemplo', description: 'Nome do exemplo.' })
  name: string
}
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

## Customização de Templates

Os geradores utilizam a biblioteca [EJS](https://ejs.co/) para renderizar os arquivos finais. Os modelos podem ser encontrados no diretório `templates/` com a extensão `.template.ts`.
Edite esses arquivos para personalizar o código gerado de acordo com as suas necessidades.

## Cobertura dos Templates

Todos os arquivos presentes em `templates/` possuem um gerador correspondente e
são acionados pelo `switch` em `src/main.ts`. A tabela abaixo mostra cada
template, o gerador que o utiliza e o componente que ativa esse gerador.

| Template | Gerador | Componente |
|----------|---------|------------|
| `app-module.template.ts` | `AppModuleGenerator` | `app-module` |
| `column.template.ts` | `TypeORMEntityGenerator` | `entities` |
| `controller.template.ts` | `ControllerGenerator` | `controllers` |
| `datasource.template.ts` | `DataSourceGenerator` | `datasource` |
| `dto.template.ts` | `DTOGenerator` | `dtos` |
| `entity.template.ts` | `TypeORMEntityGenerator` | `entities` |
| `interface.template.ts` | `InterfaceGenerator` | `interfaces` |
| `main.template.ts` | `MainFileGenerator` | `main` |
| `module.template.ts` | `ModuleGenerator` | `modules` |
| `readme.template.ts` | `ReadmeGenerator` | `readme` |
| `relation.template.ts` | `TypeORMEntityGenerator` | `entities` |
| `service.ejs` | `ServiceGenerator` | `services` |

Todas as entradas da tabela acima estão devidamente cobertas no arquivo
`src/main.ts`, garantindo que nenhum template fique sem uso durante a geração
dos códigos.

---

### Licença

Este projeto é licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

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

## Executando testes com Postgres

Crie o banco de dados de testes utilizando os scripts disponíveis em `test/e2e-generator/projects/todo/db/`:

```bash
psql -d seu_banco_testes -f test/e2e-generator/projects/todo/db/database.postgres.ddl
psql -d seu_banco_testes -f test/e2e-generator/projects/todo/db/database.postgres.sql
```

Se desejar criar um dump para reutilização posterior, execute:

```bash
pg_dump -Fc -f test/e2e-generator/projects/todo/db/database.db seu_banco_testes
```

Configure a variável de ambiente `DATABASE_TYPE` com `postgres` para que o template gerado utilize o Postgres.

## Utilizando Docker e Makefile

Para facilitar a execução dos bancos de testes e do gerador, este projeto fornece arquivos Docker e um `Makefile`.
Execute a construção da imagem e inicialização dos serviços com:

```bash
make build
make up
```

Os serviços definidos em `.docker/docker-compose.yml` incluem `sqlite`, `postgres`, `mysql`, `sqlserver` e `node-gen`. Para parar todos os containers utilize:

```bash
make down
```

Consulte o `Makefile` para mais comandos disponíveis.
