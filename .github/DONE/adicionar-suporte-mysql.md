---
name: Adicionar suporte a banco de dados MySQL para testes automatizados
about: Criação de banco MySQL relacional para testes, com modelagem avançada e carga de dados, além de ajustes no codebase para suportar o novo banco.
labels: enhancement, database, mysql, test
---

# Objetivo

Criar um banco de dados MySQL em `db/database.db`, contendo uma modelagem definida em `db/database.ddl` e uma carga definida em `db/data.sql`. O banco será utilizado para testes automatizados e não deve impactar a modelagem dos arquivos fonte do repositório, apenas permitir que o código seja executado contra o MySQL para geração dinâmica de back-end.

## Instruções

### 1. Criação do banco e scripts

- Criar o diretório `db/` na raiz do projeto, caso não exista.
- Criar o arquivo `db/database.ddl` contendo a modelagem relacional do banco, com as seguintes características:
  - Mínimo de 10 tabelas.
  - Todas as tabelas devem conter os campos `created_at`, `updated_at`, `deleted_at`.
  - Modelagem deve incluir exemplos de relacionamentos N-N, N-1 e chaves compostas.
  - Utilizar tipos variados de dados (INT, VARCHAR, TEXT, DECIMAL, BLOB, BOOLEAN, DATE, DATETIME, etc).
  - O sistema deve conter um registro de TODOs (ex: tabela `todo`).
- Criar o arquivo `db/data.sql` com carga de dados para todas as tabelas, com pelo menos 10 registros em cada uma.
- Gerar o banco MySQL em `db/database.db` a partir dos scripts acima.

#### Exemplo de trecho para `database.ddl`:

```sql
CREATE TABLE `user` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE todo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50),
  due_date DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES `user`(id)
);

-- Exemplo de tabela N-N
CREATE TABLE todo_tag (
  todo_id INT,
  tag_id INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  PRIMARY KEY (todo_id, tag_id),
  FOREIGN KEY (todo_id) REFERENCES todo(id),
  FOREIGN KEY (tag_id) REFERENCES tag(id)
);
```

#### Exemplo de trecho para `data.sql`:

```sql
INSERT INTO `user` (name, email) VALUES ('João', 'joao@email.com');
INSERT INTO todo (user_id, title, status) VALUES (1, 'Comprar pão', 'pendente');
-- ... completar com 10 registros por tabela
```

### 2. Ajustes no codebase para suporte ao MySQL

#### Diretórios e arquivos a serem ajustados:

- Todos os arquivos em `src/`, `src/utils/`, `templates/`
- Todos os arquivos em subdiretórios de `static/src/app/` (ex: `config/`, `health/`, `middleware/`, `validators/`, `version/`)
- Os seguintes arquivos na raiz, se necessário:
  - `gen.sh`
  - `package.json`
  - `README.md`

#### Exemplos de ajustes:

- Adicionar suporte ao MySQL nos arquivos de leitura de banco, como `src/db.reader.postgres.ts` e `src/db.reader.sqlite.ts`, garantindo que o suporte ao MySQL esteja completo.
- Ajustar templates em `templates/` para permitir geração de código compatível com MySQL.
- Atualizar scripts de inicialização ou geração (`gen.sh`, `README.md`) para incluir instruções de uso do MySQL.
- Garantir que a configuração de conexão com o banco permita selecionar MySQL para testes, sem impactar a modelagem dos arquivos fonte.

##### Exemplo de trecho a ser alterado em `src/db.reader.postgres.ts`:

```typescript
// ... código existente ...
// Adicionar suporte condicional ao MySQL:
if (dbType === 'mysql') {
  // lógica de conexão e leitura para MySQL
}
// ... código existente ...
```

##### Exemplo de ajuste em `templates/datasource.template.ts`:

```typescript
// ... código existente ...
// Adicionar opção para MySQL:
if (type === 'mysql') {
  // configuração específica para MySQL
}
// ... código existente ...
```

### 3. Observações

- Não alterar a modelagem dos arquivos fonte para se adequar ao design do banco MySQL. O objetivo é que o código funcione com o MySQL para geração dinâmica, mas mantenha-se agnóstico quanto ao design do banco de testes.
- Documentar no `README.md` como executar os testes utilizando o banco MySQL.

---

Se precisar de exemplos mais detalhados para cada arquivo, consulte os arquivos existentes em `src/`, `templates/` e subdiretórios de `static/src/app/`. 