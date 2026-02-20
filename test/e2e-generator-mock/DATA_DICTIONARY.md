<!-- test/e2e-generator-mock/DATA_DICTIONARY.md -->
# Dicionário de Dados — Projetos E2E (1–26)

Relacionamentos entre projetos são apenas lógicos (campos UUID). Não há Foreign Keys entre bases.

## Padrões globais (todas as tabelas)

| Campo       | Tipo    | Obrigatório | Descrição |
|------------|---------|-------------|-----------|
| tenant     | UUID    | Sim         | Identificador lógico do locatário (serviço companies). Sem FK. |
| external_id| UUID    | Sim, único  | Identificador público para APIs e referência entre serviços. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não        | Última modificação. |
| deleted_at | Timestamp | Não        | Exclusão lógica (soft delete). |

Nenhuma restrição `FOREIGN KEY` aponta para dados de outro banco/serviço; vínculos são apenas colunas UUID.

---

## Regras de validação e mensagens

### Obrigatórias (erro)
A ausência ou formato inválido de UUIDs obrigatórios ou dados críticos (ex.: credenciais de integração vazias) deve gerar:
`[ERROR] Validação falhou: O campo/regra obrigatório '{nome}' não foi atendido no payload de entrada.`

### Opcionais (aviso)
Campos que apenas estendem a funcionalidade devem emitir:
`[WARNING] O campo opcional '{nome}' não foi fornecido. O sistema assumirá o registo principal/padrão associado.`

### Soft delete
A cláusula `WHERE deleted_at IS NULL` é implícita em todas as leituras da aplicação.

---

## Domínios e valores permitidos

| Contexto | Campo | Valores / Regra |
|----------|--------|------------------|
| account | status | `active`, `suspended`, `pending_verification`, `closed` (conta de acesso à plataforma) |
| payments (tabela currency) | code / region | ISO 4217; region: `SOUTH_AMERICA`, `NORTH_AMERICA`, `EUROPE` (ex.: BRL, USD, EUR, GBP, MXN, ARS, COP, CLP, PEN, CAD, CHF) |
| transactions, orders | currency_code | ISO 4217 (referência lógica; catálogo em payments/currency). |
| products | currency_id | FK local para currency; catálogo em products/currency. payments referencia currency por external_id (UUID). |
| (address usa tabelas country, state, city; não há CHECK de texto) | — | Ver projects/addresses. |
| order | status | `draft`, `confirmed`, `paid`, `shipped`, `delivered`, `cancelled` |
| shipment | status | `pending`, `picked_up`, `in_transit`, `out_for_delivery`, `delivered`, `exception` |
| notification | channel | `email`, `sms`, `push` |
| notification | priority | `low`, `normal`, `high`, `urgent` |

Todas as relações entre projetos são **UUID** (PostgreSQL UUID; MySQL CHAR(36); SQL Server UNIQUEIDENTIFIER; SQLite TEXT). Nenhuma FK física entre bases.

---

## 1. projects/accounts

**Conceito:** Conta de **usuário de acesso à plataforma** (não é conta bancária nem de pagamento; nada de financeiro neste domínio).

**Relação lógica:** tenant. Entidade centralizadora de identidade de acesso (quem pode aceder à plataforma).

### Tabela: account

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna (SERIAL/IDENTITY/AUTO_INCREMENT) | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant ao qual a conta pertence. |
| name | Texto | Sim | Nome da conta (ex.: nome do utilizador ou da organização de acesso). |
| status | Domínio | Sim | Estado da conta de acesso: active, suspended, pending_verification, closed. Ver domínios acima. |
| created_at | Timestamp | Sim (default) | Data/hora de criação. |
| updated_at | Timestamp | Não | Data/hora da última atualização. |
| deleted_at | Timestamp | Não | Exclusão lógica (soft delete); NULL = ativo. |

---

## 2. projects/addresses

**Relação lógica:** account_id, tenant. País, estado e cidade são tabelas de referência (América Latina, América do Norte e Europa); address referencia-as por FK dentro do mesmo projeto.

### Tabela: country

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| code | Texto (2) | Sim, único | Código ISO 3166-1 alpha-2 (ex.: BR, AR, MX, US, PT, ES). |
| name | Texto | Sim | Nome do país. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: state

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| country_id | FK → country(id) | Sim | País ao qual o estado pertence. |
| code | Texto | Sim | Código do estado/região (ex.: SP, RJ, CA, NY). Único por país. |
| name | Texto | Sim | Nome do estado/região. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: city

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| state_id | FK → state(id) | Sim | Estado ao qual a cidade pertence. |
| name | Texto | Sim | Nome da cidade. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: address

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account (projects/accounts). |
| street | Texto | Sim | Logradouro. |
| zip_code | Texto | Não | CEP/código postal. |
| country_id | FK → country(id) | Sim | Referência ao país. |
| state_id | FK → state(id) | Sim | Referência ao estado/região. |
| city_id | FK → city(id) | Sim | Referência à cidade. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 3. projects/contacts

**Relação lógica:** account_id, address_id, tenant.

### Tabela: contact

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| address_id | UUID | Não | Referência lógica ao address (entrega/cobrança). |
| name | Texto | Sim | Nome do contacto. |
| email | Texto | Não | E-mail. |
| phone | Texto | Não | Telefone. |
| company | Texto | Não | Empresa. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 4. projects/users

**Relação lógica:** account_id, contact_id, address_id, tenant.

### Tabela: app_user

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| contact_id | UUID | Não | Referência lógica ao contact. |
| address_id | UUID | Não | Referência lógica ao address. |
| username | Texto | Sim | Nome de utilizador. |
| email | Texto | Sim | E-mail. |
| password_hash | Texto | Não | Hash da palavra-passe. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 5. projects/tenant

**Conceito:** Dados do inquilino (tenant), em geral uma pessoa jurídica que utiliza a plataforma. O projeto e o banco de dados designam-se «tenant».

**Relação lógica:** account_id, contact_id, address_id, tenant.

### Tabela: tenant

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| contact_id | UUID | Não | Contacto principal. |
| address_id | UUID | Não | Morada fiscal/sede. |
| name | Texto | Sim | Nome comercial. |
| legal_name | Texto | Não | Razão social. |
| tax_id | Texto | Não | NIF/CNPJ. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 6. projects/payments

**Relação lógica:** account_id, contact_id, billing_address_id (address), currency_id (external_id do domínio products/currency), tenant. Pagamentos com tipo (tabela payment_type). Moeda referenciada por UUID ao catálogo em products/currency (sem tabela currency em payments).

### Tabela: payment_type

Tipos de pagamento associados à tabela payment.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Não | Tenant (NULL = catálogo global). |
| code | Texto (20) | Sim, único | Código: DEBITO, CREDITO, PIX, BOLETO, CRIPTO, SWIFT, SEPA, ACH. |
| name | Texto | Não | Nome legível. |
| description | Texto | Não | Descrição. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: payment

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| contact_id | UUID | Não | Titular/contacto (contacts). |
| billing_address_id | UUID | Não | Morada de faturação (addresses). |
| payment_type_id | Chave interna | Sim | FK local para payment_type. |
| currency_id | UUID | Sim | Referência lógica à moeda (products/currency external_id). |
| amount | Decimal(12,2) | Não | Valor; default 0. |
| status | Texto | Não | Estado do pagamento (ex.: pending, completed). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 7. projects/transactions

**Relação lógica:** account_id, payment_id, tenant.

### Tabela: transaction

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| payment_id | UUID | Sim | Referência lógica ao payment. |
| amount | Decimal(12,2) | Sim | Montante. |
| currency_code | Texto (3) | Não | Moeda; default BRL. |
| status | Texto | Sim | Estado da transação. |
| external_reference | Texto | Não | Referência externa (gateway, etc.). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 8. projects/auth

**Relação lógica:** account_id, user_id, tenant.

### Tabela: auth_session

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| user_id | UUID | Sim | Referência lógica ao app_user. |
| token_hash | Texto | Não | Hash do token de sessão. |
| expires_at | Timestamp | Não | Expiração da sessão. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 9. projects/notifications

**Relação lógica:** account_id, user_id, contact_id, tenant.

### Tabela: notification

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| user_id | UUID | Não | Referência lógica ao app_user. |
| contact_id | UUID | Não | Referência lógica ao contact. |
| template_id | UUID | Não | Referência lógica a notification_template (quando existir). |
| channel | Domínio | Não | email, sms, push. Ver domínios acima. |
| priority | Texto | Não | low, normal, high, urgent. |
| subject | Texto | Não | Assunto. |
| body | Texto | Não | Corpo da mensagem. |
| read_at | Timestamp | Não | Data de leitura; NULL = não lida. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: notification_template (opcional, expansão)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| code | Texto | Sim | Código do template. |
| name | Texto | Não | Nome. |
| channel | Domínio | Não | email, sms, push. |
| subject_tpl | Texto | Não | Modelo do assunto. |
| body_tpl | Texto | Não | Modelo do corpo. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 10. projects/products

**Relação lógica:** account_id (fornecedor/criador), tenant. Catálogo, preços (moeda alinhada a payments), unidades de medida e descrições.

**Integridade com payments:** A tabela `currency` existe apenas em products; payments referencia moeda por `currency_id` (UUID = external_id da currency em products).

### Tabela: currency

Cópia idêntica do catálogo de payments: mesmo DDL e mesmos registos de seed (external_id, code, name, symbol, region). Regiões: SOUTH_AMERICA, NORTH_AMERICA, EUROPE.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Deve coincidir com payments/currency para o mesmo code. |
| tenant | UUID | Não | Tenant (NULL = catálogo global). |
| code | Texto (3) | Sim, único | ISO 4217 (BRL, USD, EUR, GBP, MXN, ARS, COP, CLP, PEN, CAD, CHF). |
| name | Texto | Sim | Nome da moeda. |
| symbol | Texto | Não | Símbolo (R$, $, €, etc.). |
| region | Enum | Não | SOUTH_AMERICA, NORTH_AMERICA, EUROPE. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: unit_of_measure

Unidades de medida pré-definidas para todos os casos (venda, estoque, compras). Categorias: COUNT, WEIGHT, VOLUME, LENGTH, AREA, TIME.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Não | Tenant (NULL = catálogo global). |
| code | Texto (20) | Sim, único | Código (ex.: UN, KG, G, L, ML, M, CM, M2, M3, CX, PCT, DZ, HR, DIA, MIN, T, LB). |
| name | Texto | Não | Nome legível. |
| symbol | Texto | Não | Símbolo (un, kg, L, m, etc.). |
| category | Enum | Não | COUNT, WEIGHT, VOLUME, LENGTH, AREA, TIME. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: product

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Fornecedor/criador (account). |
| sku | Texto | Não | Código SKU. |
| name | Texto | Sim | Nome do produto. |
| description | Texto | Não | Descrição. |
| unit_of_measure_id | Chave interna | Sim | FK para unit_of_measure. |
| currency_id | Chave interna | Sim | FK para currency (equivalente a currency_code; alinhado a payments). |
| unit_price | Decimal(12,2) | Não | Preço unitário; default 0. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 11. projects/warehouse

**Conceito:** Disponibilidade de produtos por armazém (local). O projeto e o banco designam-se «warehouse»; a tabela regista stock por produto e por endereço/armazém.

**Relação lógica:** product_id, address_id (armazém/local), tenant. Disponibilidade, reservas e baixas.

### Tabela: warehouse_stock

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| product_id | UUID | Sim | Referência lógica ao product. |
| address_id | UUID | Sim | Armazém/local (address). |
| quantity | Decimal(12,2) | Não | Quantidade disponível; default 0. |
| reserved | Decimal(12,2) | Não | Quantidade reservada; default 0. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 12. projects/orders

**Relação lógica:** account_id (comprador), product_id (itens), payment_id, shipping_address_id, billing_address_id, tenant. Ciclo de compra e venda.

### Tabela: order

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Comprador (account). |
| shipping_address_id | UUID | Não | Morada de entrega. |
| billing_address_id | UUID | Não | Morada de faturação. |
| payment_id | UUID | Não | Pagamento associado. |
| status | Domínio | Não | draft, confirmed, paid, shipped, delivered, cancelled. Ver domínios acima. |
| total | Decimal(12,2) | Não | Total; default 0. |
| currency_code | Domínio | Não | ISO 4217; default BRL. Ver domínios acima. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: order_item

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| order_id | UUID | Sim | Referência lógica ao order. |
| product_id | UUID | Sim | Referência lógica ao product. |
| quantity | Decimal(12,2) | Não | Quantidade; default 1. |
| unit_price | Decimal(12,2) | Não | Preço unitário no momento; default 0. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 13. projects/logistics

**Relação lógica:** order_id, origin_address_id, destination_address_id, driver_contact_id, receiver_contact_id, tenant. Rastreamento, rotas, transportadora e eventos de tracking.

### Tabela: shipment

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| order_id | UUID | Sim | Referência lógica ao order. |
| origin_address_id | UUID | Não | Morada de origem. |
| destination_address_id | UUID | Não | Morada de destino. |
| driver_contact_id | UUID | Não | Motorista (contact). |
| receiver_contact_id | UUID | Não | Recebedor (contact). |
| carrier | Texto | Não | Nome/código da transportadora. |
| status | Domínio | Não | pending, picked_up, in_transit, out_for_delivery, delivered, exception. Ver domínios acima. |
| tracking_code | Texto | Não | Código de rastreio. |
| estimated_delivery_at | Timestamp | Não | Previsão de entrega. |
| delivered_at | Timestamp | Não | Data/hora efetiva da entrega. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: shipment_event

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| shipment_id | UUID | Sim | Referência lógica ao shipment. |
| event_type | Texto | Não | Tipo do evento (ex.: picked_up, in_transit, delivered). |
| event_at | Timestamp | Não | Data/hora do evento. |
| location_text | Texto | Não | Local ou descrição no momento do evento. |
| raw_payload | Texto | Não | Payload bruto do provedor de tracking (JSON). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 14. projects/reports

**Relação lógica:** múltiplos domínios, tenant. Consolidações analíticas.

Estratégia: tabelas de consolidação físicas + VIEWs padronizadas. Periodicidade de atualização em metadados/descrição.

### Tabela: consolidated_sales_monthly

Tabela física. Atualização esperada: mensal.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| tenant | UUID | Sim | Tenant. |
| year_month | Texto (7) | Sim | Período YYYY-MM. |
| total_amount | Decimal(14,2) | Não | Total de vendas no mês. |
| order_count | Inteiro | Não | Número de pedidos. |
| currency_code | Texto (3) | Não | Moeda; default BRL. |
| updated_at | Timestamp | Não | Última atualização da consolidação. |

### Tabela: current_warehouse_stock

Tabela física. Atualização esperada: sob demanda ou diária. Referencia warehouse por external_id (sem duplicar product_id, address_id, quantity, reserved).

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| tenant | UUID | Sim | Tenant. |
| warehouse_stock_external_id | UUID | Sim | Referência lógica a warehouse.warehouse_stock (external_id). |
| snapshot_at | Timestamp | Não | Data/hora do snapshot. |
| updated_at | Timestamp | Não | Última atualização da consolidação. |

### Tabela: logistics_performance

Tabela física. Atualização esperada: diária ou semanal.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| tenant | UUID | Sim | Tenant. |
| period_type | Texto | Não | Tipo de período (day, week, month). |
| period_key | Texto | Não | Chave do período (ex.: 2025-02). |
| on_time_rate | Decimal(5,2) | Não | Taxa de entrega no prazo (0–100). |
| avg_delivery_days | Decimal(5,2) | Não | Média de dias para entrega. |
| updated_at | Timestamp | Não | Última atualização da consolidação. |

### VIEW: v_sales_monthly

Lê de `consolidated_sales_monthly`. Apresenta vendas mensais consolidadas.

### VIEW: v_warehouse_stock

Lê de `current_warehouse_stock`. Apresenta stock atual por armazém.

### VIEW: v_logistics_performance

Lê de `logistics_performance`. Apresenta indicadores de logística.

---

## 15. projects/roles

**Relação lógica:** user_id, account_id, tenant. Administração de perfis (roles), cadastro de funcionalidades e mapeamento de autorizações.

### Tabela: role

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| name | Texto | Sim | Nome do perfil (ex.: admin, operador). |
| description | Texto | Não | Descrição do perfil. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: feature

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| code | Texto | Sim | Código da funcionalidade (ex.: orders.create). |
| name | Texto | Não | Nome legível. |
| description | Texto | Não | Descrição. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: role_feature

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| role_id | UUID | Sim | Referência lógica ao role. |
| feature_id | UUID | Sim | Referência lógica à feature. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: user_role

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| user_id | UUID | Sim | Referência lógica ao app_user. |
| account_id | UUID | Sim | Referência lógica ao account. |
| role_id | UUID | Sim | Referência lógica ao role. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 16. projects/config

**Objetivo:** Suportar sistema distribuído white label: parâmetros por tenant, integrações, webhooks, identidade visual (logomarca, cores) e textos de UI (labels) por tenant e locale.

**Relação lógica:** tenant. Administração global do software, configurações de integrações externas, parâmetros globais, webhooks, branding e i18n.

### Tabela: config

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| config_key | Texto | Sim | Chave do parâmetro (ex.: app.timezone). |
| config_value | Texto | Não | Valor; pode ser JSON. |
| value_type | Texto | Não | Tipo (string, number, json, boolean). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: integration_config

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| integration_code | Texto | Sim | Código da integração (ex.: payment_gateway). |
| endpoint_url | Texto | Não | URL base do serviço. |
| credentials_ref | Texto | Não | Referência a credenciais (não armazenar em claro). |
| enabled | Booleano | Não | Ativo; default true. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: webhook

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| url | Texto | Sim | URL de callback. |
| event_type | Texto | Não | Tipo de evento (ex.: order.created). |
| secret_hash | Texto | Não | Hash do segredo para assinatura. |
| enabled | Booleano | Não | Ativo; default true. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: branding

Identidade visual white label por tenant: logomarca, favicon, cor primária.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| name | Texto | Não | Nome da marca exibido na UI. |
| logo_url | Texto | Não | URL pública do logo. |
| logo_ref | Texto | Não | Referência a asset (ex.: vault ou storage). |
| favicon_url | Texto | Não | URL do favicon. |
| primary_color | Texto | Não | Cor primária (ex.: #2D0F55). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: label

Textos de UI por tenant e opcionalmente locale (i18n white label).

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| code | Texto | Sim | Código do label (ex.: login.title, welcome.message). |
| value | Texto | Sim | Texto exibido. |
| locale | Texto | Não | Locale (ex.: pt-PT, en-US); NULL = fallback. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 17. projects/google-calendar

**Conceito:** Integração com agenda digital (ex.: Google Calendar). Mesma abordagem que projects/gmail e projects/google-drive: integração OAuth, calendários e eventos sincronizáveis com o provedor.

**Relação lógica:** tenant, account_id, integration_id (integração ligada à conta), calendar_id (eventos por calendário).

### Tabela: calendar_integration

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Conta associada. |
| connected_email | Texto | Sim | E-mail da conta Google conectada. |
| oauth_ref | Texto | Não | Referência ao token OAuth (não armazenar em claro). |
| last_sync_at | Timestamp | Não | Última sincronização com o provedor. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: calendar

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Conta. |
| integration_id | UUID | Sim | Referência à calendar_integration. |
| name | Texto | Sim | Nome do calendário. |
| timezone | Texto | Não | Fuso (ex.: Europe/Lisbon); default UTC. |
| google_calendar_id | Texto | Não | ID do calendário no Google Calendar. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: calendar_event

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Conta. |
| integration_id | UUID | Sim | Referência à calendar_integration. |
| calendar_id | UUID | Sim | Referência ao calendar. |
| title | Texto | Sim | Título do evento. |
| description | Texto | Não | Descrição. |
| start_at | Timestamp | Sim | Início. |
| end_at | Timestamp | Sim | Fim. |
| all_day | Booleano | Não | Evento dia inteiro; default false. |
| google_event_id | Texto | Não | ID do evento no Google Calendar. |
| status | Texto | Não | Estado (ex.: confirmed, cancelled). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 18. projects/communications

**Relação lógica:** account_id, user_id, tenant. Templates de e-mail, configurações SMTP por tenant, histórico de envios e tracking de entrega.

### Tabela: email_template

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| code | Texto | Sim | Código do template (ex.: welcome_email). |
| name | Texto | Não | Nome legível. |
| subject_tpl | Texto | Não | Modelo do assunto (placeholders permitidos). |
| body_tpl | Texto | Não | Modelo do corpo (HTML/texto). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: smtp_config

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Não | Conta associada (opcional). |
| host | Texto | Sim | Servidor SMTP. |
| port | Inteiro | Não | Porta; default 587. |
| use_tls | Booleano | Não | Usar TLS; default true. |
| credentials_ref | Texto | Não | Referência a credenciais. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: send_history

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| template_id | UUID | Não | Referência lógica ao email_template. |
| recipient | Texto | Sim | Destinatário (e-mail). |
| sent_at | Timestamp | Não | Data/hora de envio. |
| status | Texto | Não | Estado (sent, failed, delivered). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: delivery_tracking

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| send_history_id | UUID | Sim | Referência lógica ao send_history. |
| event_type | Texto | Não | Tipo (delivered, opened, bounced). |
| event_at | Timestamp | Não | Data/hora do evento. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 19. projects/maps

**Relação lógica:** addresses, logistics, tenant. Provedores de mapas, cache de geocodificação e rotas.

### Tabela: map_provider_config

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| provider_code | Texto | Sim | Código do provedor (ex.: osm, google). |
| endpoint_url | Texto | Não | URL base da API. |
| api_key_ref | Texto | Não | Referência à chave (não em claro). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: geocode_cache

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| address_hash | Texto | Não | Hash do endereço para cache. |
| raw_address | Texto | Não | Endereço original. |
| latitude | Decimal(10,7) | Não | Latitude. |
| longitude | Decimal(10,7) | Não | Longitude. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: route_cache

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| origin_key | Texto | Não | Chave de origem (ex.: lat,lng ou address_id). |
| destination_key | Texto | Não | Chave de destino. |
| distance_km | Decimal(10,2) | Não | Distância em km. |
| duration_min | Decimal(8,2) | Não | Duração em minutos. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 20. projects/llm

**Conceito:** Projeto único que consolida log de chamadas LLM, configuração de provedores, templates de prompt, log de execução e resumo de uso.

**Relação lógica:** account_id, tenant, provider_config_id (entre tabelas do mesmo projeto).

### Tabela: llm_log

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Não | Referência lógica ao account. |
| model_name | Texto | Sim | Nome do modelo. |
| prompt | Texto | Não | Prompt enviado. |
| response | Texto | Não | Resposta recebida. |
| tokens_used | Inteiro | Não | Tokens consumidos; default 0. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: llm_provider_config

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Não | Conta associada. |
| provider_code | Texto | Sim | Código (ex.: openai, ollama). |
| model_id | Texto | Não | Identificador do modelo. |
| api_key_ref | Texto | Não | Referência à chave. |
| fallback_local_endpoint | Texto | Não | URL local para fallback (ex.: Ollama). |
| routing_priority | Inteiro | Não | Ordem de tentativa (1 = primeiro). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: prompt_template

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| code | Texto | Sim | Código do template. |
| name | Texto | Não | Nome legível. |
| content | Texto | Não | Conteúdo do prompt (placeholders permitidos). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: llm_execution_log

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| provider_config_id | UUID | Não | Referência lógica à config. |
| model_id | Texto | Não | Modelo utilizado. |
| success | Booleano | Não | Execução com sucesso. |
| latency_ms | Inteiro | Não | Latência em milissegundos. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: llm_usage_summary

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Não | Referência lógica ao account. |
| provider_config_id | UUID | Não | Referência à config do provedor. |
| period_start | Data | Sim | Início do período. |
| period_end | Data | Sim | Fim do período. |
| total_requests | Inteiro | Não | Total de pedidos; default 0. |
| total_tokens_input | Inteiro | Não | Total de tokens de entrada; default 0. |
| total_tokens_output | Inteiro | Não | Total de tokens de saída; default 0. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 21. projects/consents

**Relação lógica:** account_id, user_id, tenant. Opt-in/opt-out, preferências de notificações (e-mail, SMS, push) e registo de consentimento explícito para RGPD/LGPD.

### Tabela: consent_record

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| user_id | UUID | Não | Referência lógica ao app_user. |
| consent_type | Texto | Sim | Tipo (ex.: marketing, terms, privacy). |
| granted_at | Timestamp | Não | Data/hora da concessão. |
| ip_address | Texto | Não | IP no momento do consentimento. |
| version | Texto | Não | Versão do documento/termos. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: notification_preference

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| user_id | UUID | Não | Referência lógica ao app_user. |
| channel | Texto | Sim | Canal: email, sms, push. |
| opt_in | Booleano | Não | Opt-in ativo; default true. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 22. projects/gmail

**Conceito:** Registo de informações de integração com Gmail, templates de mensagem e histórico de mensagens (enviadas/recebidas) via API Gmail.

**Relação lógica:** tenant, account_id, integration_id (entre tabelas do mesmo projeto).

### Tabela: gmail_integration

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| connected_email | Texto | Sim | E-mail da conta Gmail conectada. |
| oauth_ref | Texto | Não | Referência a credenciais OAuth (ex.: vault). |
| last_sync_at | Timestamp | Não | Última sincronização com a API Gmail. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: gmail_message_template

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Não | Referência lógica ao account. |
| code | Texto | Sim | Código do template. |
| name | Texto | Não | Nome do template. |
| subject_tpl | Texto | Não | Modelo do assunto (ex.: placeholders {{nome}}). |
| body_tpl | Texto | Não | Modelo do corpo da mensagem. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: gmail_message

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| integration_id | UUID | Sim | Referência à integração Gmail (gmail_integration). |
| gmail_message_id | Texto | Não | ID da mensagem na API Gmail. |
| gmail_thread_id | Texto | Não | ID do thread na API Gmail. |
| direction | Domínio | Sim | sent, received. |
| subject | Texto | Não | Assunto. |
| from_addr | Texto | Não | Remetente. |
| to_addr | Texto | Não | Destinatário(s). |
| body_preview | Texto | Não | Pré-visualização do corpo. |
| sent_at | Timestamp | Não | Data/hora de envio. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 23. projects/google-drive

**Conceito:** Informações de integração com o Google Drive (credenciais, OAuth, última sincronização) e dados já existentes de pastas e ficheiros (drive_folder, drive_file). Pastas e ficheiros referenciam a integração que os sincronizou.

**Relação lógica:** tenant, account_id, integration_id (entre tabelas do mesmo projeto).

### Tabela: drive_integration

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| connected_email | Texto | Sim | E-mail da conta Google conectada ao Drive. |
| oauth_ref | Texto | Não | Referência a credenciais OAuth (ex.: vault). |
| last_sync_at | Timestamp | Não | Última sincronização com a API Google Drive. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: drive_folder

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| integration_id | UUID | Sim | Referência à integração (drive_integration). |
| name | Texto | Sim | Nome da pasta. |
| parent_folder_id | UUID | Não | Pasta pai (drive_folder). |
| drive_folder_id | Texto | Não | ID da pasta na API Google Drive. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: drive_file

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| integration_id | UUID | Sim | Referência à integração (drive_integration). |
| folder_id | UUID | Não | Pasta (drive_folder). |
| file_name | Texto | Sim | Nome do ficheiro. |
| mime_type | Texto | Não | Tipo MIME. |
| size_bytes | Inteiro | Não | Tamanho em bytes; default 0. |
| drive_file_id | Texto | Não | ID do ficheiro na API Google Drive. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 24. projects/selling

**Conceito:** Pedidos de venda (tb_order, tb_order_line) com referências lógicas a accounts, addresses, payments e products. Sem tabelas de cliente, pagamento ou stock (domínios globais).

**Relação lógica:** tenant, account_id, billing_address_id, shipping_address_id, payment_id (UUID; sem FK). FKs físicas apenas internas: tb_order_line.order_id → tb_order(id).

### Tabela: tb_order

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| account_id | UUID | Sim | Referência lógica ao comprador (accounts). |
| billing_address_id | UUID | Não | Referência lógica ao endereço de faturação (addresses). |
| shipping_address_id | UUID | Não | Referência lógica ao endereço de envio (addresses). |
| payment_id | UUID | Não | Referência lógica ao pagamento (payments). |
| status | Texto | Sim | Estado do pedido. |
| total | Decimal(12,2) | Sim | Total. |
| discount | Decimal(5,2) | Não | Desconto; default 0. |
| ordered_at | Timestamp | Não | Data do pedido. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tb_order_line

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| order_id | Chave interna | Sim | FK local para tb_order (PK composta). |
| line_number | Inteiro | Sim | Número da linha (PK composta). |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| product_id | UUID | Sim | Referência lógica ao produto (products). |
| product_name | Texto | Não | Cache do nome para exibição. |
| quantity | Inteiro | Sim | Quantidade. |
| unit_price | Decimal(12,2) | Sim | Preço unitário. |
| line_total | Decimal(12,2) | Sim | Total da linha. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 25. projects/todo

**Objetivo:** Itens genéricos, categorias, tags e junção item–tag. Sem tabelas de produto, venda ou documento (domínios em products, orders, storage). Referência lógica a products quando o item se relacionar a um produto.

**Relação lógica:** tenant (UUID, sem FK). FKs físicas internas: tb_simple_item.category_id → tb_category; tb_simple_item_tag → tb_simple_item, tb_tag.

### Tabela: tb_category

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| code | Texto | Não | Código. |
| name | Texto | Sim | Nome. |
| full_description | Texto | Não | Descrição completa. |
| status | Texto | Não | Status. |
| price | Decimal/Real | Não | Preço. |
| sort_order | Inteiro | Não | Ordem; default 0. |
| is_active | Booleano | Não | Ativo; default true. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tb_simple_item

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| name | Texto | Sim | Nome. |
| category_id | Chave interna | Não | FK local para tb_category. |
| product_id | UUID | Não | Referência lógica ao produto (products), quando aplicável. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tb_tag

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| name | Texto | Sim | Nome. |
| slug | Texto | Não | Slug. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tb_simple_item_tag

Junção N-N entre tb_simple_item e tb_tag (ambas locais).

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| simple_item_id | Chave interna | Sim | FK local para tb_simple_item (PK composta). |
| tag_id | Chave interna | Sim | FK local para tb_tag (PK composta). |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 26. projects/schedule

**Objetivo:** Recursos agendáveis, slots, regras de recorrência, agendamentos (bookings), participantes por account_id e histórico. Sem tabela tb_participant (participantes são users/accounts). tenant e external_id em todas as tabelas; FKs físicas apenas internas.

**Relação lógica:** tenant, organizer_account_id, account_id em tb_booking_participant (UUID; sem FK para accounts/users). FKs físicas: tb_resource.parent_id → tb_resource; tb_slot → tb_resource; tb_booking → tb_slot, tb_recurrence_rule; tb_booking_participant → tb_booking; tb_booking_history → tb_booking.

### Tabela: tb_resource

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| name | Texto | Sim | Nome do recurso. |
| resource_type | Texto | Sim | Tipo do recurso. |
| capacity | Inteiro | Não | Capacidade; default 1. |
| parent_id | Chave interna | Não | FK local para tb_resource (hierarquia). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tb_slot

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| resource_id | Chave interna | Sim | FK local para tb_resource. |
| start_at | Timestamp | Sim | Início da janela. |
| end_at | Timestamp | Sim | Fim da janela. |
| status | Texto | Sim | Status do slot. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tb_recurrence_rule

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| code | Texto | Sim, único | Código da regra. |
| name | Texto | Sim | Nome. |
| cron_expression | Texto | Não | Expressão CRON. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tb_booking

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| slot_id | Chave interna | Sim | FK local para tb_slot. |
| recurrence_rule_id | Chave interna | Não | FK local para tb_recurrence_rule. |
| organizer_account_id | UUID | Não | Referência lógica ao responsável (accounts). |
| title | Texto | Sim | Título. |
| description | Texto | Não | Descrição. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tb_booking_participant

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| booking_id | Chave interna | Sim | FK local para tb_booking (PK composta). |
| account_id | UUID | Sim | Referência lógica ao participante (accounts/users) (PK composta). |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| role | Texto | Sim | Papel do participante. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tb_booking_history

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto. |
| tenant | UUID | Sim | Locatário. |
| booking_id | Chave interna | Sim | FK local para tb_booking. |
| action | Texto | Sim | Ação registrada. |
| changed_at | Timestamp | Sim | Data/hora da alteração. |
| snapshot | JSONB/Texto | Não | Estado ou payload (auditoria). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## Resumo das referências lógicas (UUID) — selling, schedule, todo

| Projeto  | Tabela / contexto     | Coluna(s) UUID        | Serviço de destino |
|----------|------------------------|------------------------|--------------------|
| selling  | tb_order              | account_id             | accounts           |
| selling  | tb_order              | billing_address_id, shipping_address_id | addresses |
| selling  | tb_order              | payment_id             | payments           |
| selling  | tb_order_line         | product_id             | products           |
| schedule | tb_booking            | organizer_account_id   | accounts           |
| schedule | tb_booking_participant| account_id             | accounts / users   |
| todo     | tb_simple_item        | product_id             | products           |

Nenhuma dessas colunas possui `FOREIGN KEY`; a integridade referencial externa fica a cargo dos serviços e da orquestração da aplicação.
