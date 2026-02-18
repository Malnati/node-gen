---
name: Adicionar suporte a banco de dados Postgres para testes automatizados
about: Criação de banco Postgres relacional para testes, com modelagem avançada e carga de dados, além de ajustes no codebase para suportar o novo banco.
labels: enhancement, database, postgres, test
---

# Objetivo

Criar um banco de dados Postgres em `test/db/database.db`, contendo uma modelagem definida em `test/db/database.postgres.ddl` e uma carga definida em `test/db/database.postgres.sql`. O banco será utilizado para testes automatizados e não deve impactar a modelagem dos arquivos fonte do repositório, apenas permitir que o código seja executado contra o Postgres para geração dinâmica de back-end.

## Instruções

### 1. Criação do banco e scripts

- Criar o diretório `test/db/` na raiz do projeto, caso não exista.
- Criar o arquivo `test/db/database.postgres.ddl` contendo a modelagem relacional do banco, com as seguintes características:
  - Mínimo de 10 tabelas.
  - Todas as tabelas devem conter os campos `created_at`, `updated_at`, `deleted_at`.
  - Modelagem deve incluir exemplos de relacionamentos N-N, N-1 e chaves compostas.
  - Utilizar tipos variados de dados (INTEGER, TEXT, REAL, BYTEA, BOOLEAN, DATE, TIMESTAMP, etc).
  - O sistema deve conter um registro de TODOs (ex: tabela `todo`).
- Criar o arquivo `test/db/database.postgres.sql` com carga de dados para todas as tabelas, com pelo menos 10 registros em cada uma.
- Gerar o banco Postgres em `test/db/database.db` a partir dos scripts acima.

#### Exemplo de trecho para `database.postgres.ddl`:

```sql
CREATE TABLE "user" (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE TABLE todo (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT,
  due_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES "user"(id)
);

-- Exemplo de tabela N-N
CREATE TABLE todo_tag (
  todo_id INTEGER,
  tag_id INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP,
  PRIMARY KEY (todo_id, tag_id),
  FOREIGN KEY (todo_id) REFERENCES todo(id),
  FOREIGN KEY (tag_id) REFERENCES tag(id)
);
```

#### Exemplo de trecho para `database.postgres.sql`:

```sql
INSERT INTO "user" (name, email) VALUES ('João', 'joao@email.com');
INSERT INTO todo (user_id, title, status) VALUES (1, 'Comprar pão', 'pendente');
-- ... completar com 10 registros por tabela
```

### 2. Ajustes no codebase para suporte ao Postgres

#### Diretórios e arquivos a serem ajustados:

- Todos os arquivos em `src/`, `src/utils/`, `templates/`
- Todos os arquivos em subdiretórios de `static/src/app/` (ex: `config/`, `health/`, `middleware/`, `validators/`, `version/`)
- Os seguintes arquivos na raiz, se necessário:
  - `gen.sh`
  - `package.json`
  - `README.md`

#### Exemplos de ajustes:

- Adicionar suporte ao Postgres nos arquivos de leitura de banco, como `src/db.reader.mysql.ts` e `src/db.reader.sqlite.ts`, garantindo que o suporte ao Postgres esteja completo.
- Ajustar templates em `templates/` para permitir geração de código compatível com Postgres.
- Atualizar scripts de inicialização ou geração (`gen.sh`, `README.md`) para incluir instruções de uso do Postgres.
- Garantir que a configuração de conexão com o banco permita selecionar Postgres para testes, sem impactar a modelagem dos arquivos fonte.

##### Exemplo de trecho a ser alterado em `src/db.reader.mysql.ts`:

```typescript
// ... código existente ...
// Adicionar suporte condicional ao Postgres:
if (dbType === 'postgres') {
  // lógica de conexão e leitura para Postgres
}
// ... código existente ...
```

##### Exemplo de ajuste em `templates/datasource.template.ts`:

```typescript
// ... código existente ...
// Adicionar opção para Postgres:
if (type === 'postgres') {
  // configuração específica para Postgres
}
// ... código existente ...
```

### 3. Observações

- Não alterar a modelagem dos arquivos fonte para se adequar ao design do banco Postgres. O objetivo é que o código funcione com o Postgres para geração dinâmica, mas mantenha-se agnóstico quanto ao design do banco de testes.
- Documentar no `README.md` como executar os testes utilizando o banco Postgres.

---

Se precisar de exemplos mais detalhados para cada arquivo, consulte os arquivos existentes em `src/`, `templates/` e subdiretórios de `static/src/app/`. 