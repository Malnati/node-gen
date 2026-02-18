---
name: Adicionar suporte a banco de dados SQLServer para testes automatizados
about: Criação de banco SQLServer relacional para testes, com modelagem avançada e carga de dados, além de ajustes no codebase para suportar o novo banco.
labels: enhancement, database, sqlserver, test
---

# Objetivo

Criar um banco de dados SQLServer em `test/db/database.db`, contendo uma modelagem definida em `test/db/database.ddl` e uma carga definida em `test/db/data.sql`. O banco será utilizado para testes automatizados e não deve impactar a modelagem dos arquivos fonte do repositório, apenas permitir que o código seja executado contra o SQLServer para geração dinâmica de back-end.

## Instruções

### 1. Criação do banco e scripts

- Criar o diretório `test/db/` na raiz do projeto, caso não exista.
- Criar o arquivo `test/db/sqlserver/database.ddl` contendo a modelagem relacional do banco, com as seguintes características:
  - Mínimo de 10 tabelas.
  - Todas as tabelas devem conter os campos `created_at`, `updated_at`, `deleted_at`.
  - Modelagem deve incluir exemplos de relacionamentos N-N, N-1 e chaves compostas.
  - Utilizar tipos variados de dados (INT, VARCHAR, NVARCHAR, TEXT, DECIMAL, VARBINARY, BIT, DATE, DATETIME, etc).
  - O sistema deve conter um registro de TODOs (ex: tabela `todo`).
- Criar o arquivo `test/db/sqlserver/data.sql` com carga de dados para todas as tabelas, com pelo menos 10 registros em cada uma.
- Gerar o banco SQLServer em `test/db/database.db` a partir dos scripts acima.

#### Exemplo de trecho para `database.ddl`:

```sql
CREATE TABLE [user] (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(255) NOT NULL,
  email NVARCHAR(255) UNIQUE NOT NULL,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE todo (
  id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  title NVARCHAR(255) NOT NULL,
  description TEXT,
  status NVARCHAR(50),
  due_date DATE,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES [user](id)
);

-- Exemplo de tabela N-N
CREATE TABLE todo_tag (
  todo_id INT,
  tag_id INT,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME,
  CONSTRAINT PK_todo_tag PRIMARY KEY (todo_id, tag_id),
  FOREIGN KEY (todo_id) REFERENCES todo(id),
  FOREIGN KEY (tag_id) REFERENCES tag(id)
);
```

#### Exemplo de trecho para `data.sql`:

```sql
INSERT INTO [user] (name, email) VALUES ('João', 'joao@email.com');
INSERT INTO todo (user_id, title, status) VALUES (1, 'Comprar pão', 'pendente');
-- ... completar com 10 registros por tabela
```

### 2. Ajustes no codebase para suporte ao SQLServer

#### Diretórios e arquivos a serem ajustados:

- Todos os arquivos em `src/`, `src/utils/`, `templates/`
- Todos os arquivos em subdiretórios de `static/src/app/` (ex: `config/`, `health/`, `middleware/`, `validators/`, `version/`)
- Os seguintes arquivos na raiz, se necessário:
  - `gen.sh`
  - `package.json`
  - `README.md`

#### Exemplos de ajustes:

- Adicionar suporte ao SQLServer nos arquivos de leitura de banco, como `src/db.reader.mysql.ts`, `src/db.reader.postgres.ts` e `src/db.reader.sqlite.ts`, garantindo que o suporte ao SQLServer esteja completo.
- Ajustar templates em `templates/` para permitir geração de código compatível com SQLServer.
- Atualizar scripts de inicialização ou geração (`gen.sh`, `README.md`) para incluir instruções de uso do SQLServer.
- Garantir que a configuração de conexão com o banco permita selecionar SQLServer para testes, sem impactar a modelagem dos arquivos fonte.

##### Exemplo de trecho a ser alterado em `src/db.reader.mysql.ts`:

```typescript
// ... código existente ...
// Adicionar suporte condicional ao SQLServer:
if (dbType === 'sqlserver') {
  // lógica de conexão e leitura para SQLServer
}
// ... código existente ...
```

##### Exemplo de ajuste em `templates/datasource.template.ts`:

```typescript
// ... código existente ...
// Adicionar opção para SQLServer:
if (type === 'sqlserver') {
  // configuração específica para SQLServer
}
// ... código existente ...
```

### 3. Observações

- Não alterar a modelagem dos arquivos fonte para se adequar ao design do banco SQLServer. O objetivo é que o código funcione com o SQLServer para geração dinâmica, mas mantenha-se agnóstico quanto ao design do banco de testes.
- Documentar no `README.md` como executar os testes utilizando o banco SQLServer.

---

Se precisar de exemplos mais detalhados para cada arquivo, consulte os arquivos existentes em `src/`, `templates/` e subdiretórios de `static/src/app/`. 