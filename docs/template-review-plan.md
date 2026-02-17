<!-- docs/template-review-plan.md -->

# Plano de revisão completa dos geradores TypeScript de código-fonte

## 1) Arquivos existentes relevantes para o escopo
- `src/env-generator.ts`
- `src/package-json-generator.ts`
- `src/diagram-generator.ts`
- `src/interface-generator.ts`
- `src/controller-generator.ts`
- `src/module-generator.ts`
- `src/main-generator.ts`
- `src/app-module-generator.ts`
- `src/readme-generator.ts`
- `src/datasource-generator.ts`
- `src/dto-generator.ts`
- `src/service-generator.ts`
- `src/typeorm-entity-generator.ts`
- `src/main.ts`
- `src/interfaces.ts`
- `src/utils/template-loader.ts`
- `src/utils/TemplateEngine.ts`
- `src/utils/string.ts`
- `templates/*.ts` e `templates/service.ejs`
- `static/**` (artefatos de suporte copiados para o projeto gerado)
- `package.json`, `tsconfig.json`, `README.md`

## 2) Arquivos que serão alterados
- `docs/template-review-plan.md`

## 3) Requisitos combinados (mudança + requisitos globais)
- Criar um plano novo em `docs/template-review-plan.md`.
- Cobrir revisão de todos os geradores TypeScript de código-fonte.
- Definir a ordem de revisão do menos dependente ao mais dependente.
- Incluir as análises necessárias por gerador para permitir correções de inconformidades até alcançar funcionamento completo.
- Considerar revisão de stack completo (entradas, templates, artefatos gerados, integração final e validações).
- Manter rastreabilidade e objetividade, sem expandir escopo para implementação de correções nesta entrega.

## 4) Requisitos atualmente não atendidos que este plano resolve
- Ausência de plano consolidado e ordenado para revisão completa dos geradores TypeScript.
- Ausência de checklist unificado de análises técnicas por gerador e por integração fim a fim.

## 5) Regras combinadas (mudança específica + regras globais)
- Não alterar lógica dos geradores nesta tarefa; apenas produzir o plano solicitado.
- Revisão deve priorizar dependências explícitas (imports, contratos, templates e artefatos gerados).
- Usar ordem progressiva para reduzir efeito cascata de diagnósticos:
  1. Geradores base (baixa dependência funcional)
  2. Geradores intermediários (dependem de contratos/nomes gerados)
  3. Geradores de domínio e composição
  4. Orquestração e validação fim a fim
- Para cada gerador, analisar no mínimo: contratos de entrada, regras de transformação, escrita de arquivos, idempotência, naming/path, compatibilidade com templates e compilação do código gerado.

## 6) Regras atualmente não atendidas que motivam os ajustes
- Falta de ordem formal de revisão orientada por dependências entre geradores.
- Falta de critérios padronizados para concluir que um gerador está apto para correção segura.

## 7) Plano de auditoria (manual + automático)
- Auditoria manual de cobertura do plano:
  - Confirmar que os 13 geradores TypeScript estão listados.
  - Confirmar presença da ordem do menos para o mais dependente.
  - Confirmar que cada gerador possui checklist de análise técnica e de validação de saída.
- Auditoria automática recomendada para execução durante a revisão:
  - `npm run build` no repositório do gerador.
  - Execução controlada do CLI com banco de referência por tipo suportado.
  - `npm run build` e `npm test` (quando disponível) no projeto gerado para cada combinação crítica de componentes.

## 8) Checklists aplicáveis
- Checklist obrigatório de revisão de TypeScript (tipagem strict, imports, contratos e erros).
- Checklist obrigatório de templates gerados (placeholders, escaping, paths e consistência de nomeação).
- Checklist obrigatório de integração de geração (execução do CLI, build do output e smoke de execução).
- Checklist obrigatório de documentação/rastreabilidade (registro de falhas, causa raiz, correção proposta e evidência de validação).

---

## Ordem de revisão dos geradores (menos dependente → mais dependente)

### 1. `env-generator.ts`
**Por que nesta posição:** gera arquivo isolado, sem depender de entidades/relacionamentos.

**Análises necessárias:**
- Validação de cadeia de variáveis e defaults.
- Verificação de sobrescrita idempotente do `.env`.
- Compatibilidade com variáveis consumidas por `datasource`, `main` e runtime NestJS.

### 2. `package-json-generator.ts`
**Por que nesta posição:** gera metadados e scripts, com baixa dependência de schema.

**Análises necessárias:**
- Conformidade de scripts (`build`, `start`, `test`, lint, format).
- Coerência entre dependências e código realmente gerado.
- Compatibilidade com versão de TypeScript/Nest e lockfile do stack alvo.

### 3. `diagram-generator.ts`
**Por que nesta posição:** consome schema, mas não afeta compilação do código gerado.

**Análises necessárias:**
- Integridade do parse de tabelas/colunas/relacionamentos no SVG/PNG.
- Tratamento de tabela sem relações e com múltiplas relações.
- Robustez para schemas extensos (legibilidade e tempo de geração).

### 4. `interface-generator.ts`
**Por que nesta posição:** define contratos base reutilizados por DTOs e serviços.

**Análises necessárias:**
- Tipagem correta de campos opcionais/nulos e tipos primitivos.
- Consistência de nomes com entidades e DTOs gerados.
- Export/import em caminhos compatíveis com a estrutura final.

### 5. `controller-generator.ts`
**Por que nesta posição:** depende de convenções de nomeação, mas baixa lógica de domínio.

**Análises necessárias:**
- Rotas, decorators e injeção de dependência válidos.
- Assinaturas de métodos coerentes com DTOs/serviços esperados.
- Caminhos de import e nomes kebab/camel/pascal consistentes.

### 6. `module-generator.ts`
**Por que nesta posição:** compõe providers/controllers por domínio de tabela.

**Análises necessárias:**
- Coesão do módulo por recurso e vinculação de providers.
- Exportações e imports corretos para uso no `app.module.ts`.
- Estrutura de diretórios de saída e nomes de arquivos previsíveis.

### 7. `main-generator.ts`
**Por que nesta posição:** arquivo de bootstrap do projeto gerado, dependente de configuração base.

**Análises necessárias:**
- Inicialização da aplicação e middleware padrão.
- Compatibilidade com health/metrics/Swagger quando aplicável ao template estático.
- Ausência de hardcode inválido para ambiente alvo.

### 8. `app-module-generator.ts`
**Por que nesta posição:** agrega módulos por tabela e depende da geração modular correta.

**Análises necessárias:**
- Lista de imports montada sem duplicação/omissão.
- Ordem e sintaxe válidas para compilação TypeScript.
- Compatibilidade com módulos gerados e com `main.ts` do output.

### 9. `readme-generator.ts`
**Por que nesta posição:** depende de schema e de convenções finais de nomenclatura.

**Análises necessárias:**
- Seções por entidade coerentes com a saída real gerada.
- Tabelas de colunas e comentários sem perda de informação do schema.
- Instruções de execução alinhadas com `package.json` e estrutura final.

### 10. `datasource-generator.ts`
**Por que nesta posição:** integra entidades e configuração de banco, crítico para runtime.

**Análises necessárias:**
- Imports de entidades e registration list corretos.
- Compatibilidade com providers de configuração e ambiente (`.env`).
- Inicialização do datasource válida para cada banco suportado.

### 11. `dto-generator.ts`
**Por que nesta posição:** depende de interfaces/entidades e validações de domínio.

**Análises necessárias:**
- Regras de validação (`class-validator`) corretas por tipo/nullable.
- Contratos Query/Persist coerentes com serviços e controllers.
- Campos de relacionamento (`*_eid`/`*_exid`) consistentes com o schema.

### 12. `service-generator.ts`
**Por que nesta posição:** alta dependência de entidades, DTOs, datasource e relações.

**Análises necessárias:**
- CRUD completo com mapeamento seguro entre DTO e entidade.
- Resolução de relacionamentos, validação de existência e tratamento de erro.
- Consultas, paginação/filtros (se previsto em template) e serialização de saída.

### 13. `typeorm-entity-generator.ts`
**Por que nesta posição:** mais dependente em termos de consistência estrutural do domínio e base para runtime persistente.

**Análises necessárias:**
- Mapping de tipos SQL→TypeScript/TypeORM (nullable, precision, defaults).
- Chaves primárias/estrangeiras, cardinalidades e decorators de relação.
- Imports TypeORM/Nest Swagger e composição final da classe compilável.

---

## Análises transversais obrigatórias (stack completo)

1. Entrada e leitura de schema
   - Validar fluxo `DbReader*` (postgres/mysql/sqlserver/sqlite) e serialização JSON intermediária.
   - Garantir que tabelas, colunas, PK/FK e comentários chegam íntegros a todos os geradores.

2. Motor de templates
   - Verificar `template-loader`, `TemplateEngine` e templates (`templates/*.ts`, `service.ejs`) para placeholders órfãos, escaping e quebras de sintaxe.

3. Padrões de nomeação e paths
   - Auditar `toPascalCase`, `toKebabCase`, `toSnakeCase`, `removeTbPrefix` e impacto em imports/arquivos.

4. Orquestração do processo
   - Revisar `main.ts` para ordem de execução, paralelismo (`Promise.all`), seleção de componentes e tratamento de erros.

5. Qualidade do output gerado
   - Para cada combinação crítica de componentes, gerar projeto e validar:
     - compilação (`npm run build`),
     - lint/format,
     - inicialização mínima (`npm run start`/`start:dev`),
     - consistência de imports e ausência de arquivos quebrados.

6. Matriz mínima de cenários de teste da revisão
   - Tabela simples sem relacionamentos.
   - Tabela com múltiplos relacionamentos e chaves compostas.
   - Campos nullable, enum, decimal, datas e UUID/external_id.
   - Nomes limítrofes (prefixos `tb_`, snake_case, termos reservados).

7. Critério de pronto da revisão
   - Cada gerador recebe status: `Aprovado`, `Aprovado com ressalvas` ou `Reprovado`.
   - Toda inconformidade tem causa raiz, impacto, proposta de correção e evidência de revalidação.
   - O stack completo gera projeto compilável e executável para os cenários críticos definidos.
