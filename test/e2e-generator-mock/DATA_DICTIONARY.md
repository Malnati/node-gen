<!-- test/e2e-generator-mock/DATA_DICTIONARY.md -->
# Dicionário de Dados — Projetos E2E (1–25)

Relacionamentos entre projetos são apenas lógicos (campos UUID). Não há Foreign Keys entre bases.

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
| products | currency_id | FK para currency; catálogo em products/currency (cópia idêntica de payments/currency). |
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

**Relação lógica:** account_id, contact_id, billing_address_id (address), tenant. Pagamentos com tipo (tabela payment_type) e moeda multi‑país (tabela currency); abrangência: América do Sul, América do Norte e Europa.

### Tabela: currency

Catálogo de moedas por região (SOUTH_AMERICA, NORTH_AMERICA, EUROPE).

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Não | Tenant (NULL = catálogo global). |
| code | Texto (3) | Sim, único | Código ISO 4217 (ex.: BRL, USD, EUR, GBP, MXN, ARS, COP, CLP, PEN, CAD, CHF). |
| name | Texto | Sim | Nome da moeda. |
| symbol | Texto | Não | Símbolo (ex.: R$, $, €). |
| region | Enum | Não | SOUTH_AMERICA, NORTH_AMERICA, EUROPE. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

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
| contact_id | UUID | Não | Titular/contacto. |
| billing_address_id | UUID | Não | Morada de faturação (address). |
| payment_type_id | Chave interna | Sim | FK para payment_type. |
| currency_id | Chave interna | Sim | FK para currency. |
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

**Integridade com payments:** A tabela `currency` em products é **cópia idêntica** da de projects/payments: mesma estrutura (external_id, code, name, symbol, region) e mesmos dados de seed (mesmos external_id e code para cada moeda), de forma a manter currency_code e atributos equivalentes sincronizáveis.

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

Tabela física. Atualização esperada: sob demanda ou diária. Consolidação de stock por armazém (projects/warehouse).

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| tenant | UUID | Sim | Tenant. |
| product_id | UUID | Sim | Referência lógica ao product. |
| address_id | UUID | Sim | Armazém/local (address). |
| quantity | Decimal(12,2) | Não | Quantidade disponível. |
| reserved | Decimal(12,2) | Não | Quantidade reservada. |
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

**Conceito:** Projeto de vendas integrado à plataforma distribuída. Em vez de tabelas próprias (cliente, forma de pagamento, endereço), utiliza referências lógicas (UUID) a accounts, orders, payments, products e addresses.

**Relação lógica:** account_id (comprador), order_id (projects/orders), payment_id (projects/payments), billing_address_id e shipping_address_id (projects/addresses), product_id (projects/products).

### Tabela: sale

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Comprador (referência lógica ao account). |
| order_id | UUID | Sim | Referência lógica ao order (projects/orders). |
| payment_id | UUID | Não | Referência lógica ao payment (projects/payments). |
| billing_address_id | UUID | Não | Morada de faturação (projects/addresses). |
| shipping_address_id | UUID | Não | Morada de envio (projects/addresses). |
| status | Texto | Não | Estado da venda (ex.: confirmed, draft). |
| total | Decimal(12,2) | Não | Total; default 0. |
| currency_code | Texto (3) | Não | Moeda; default BRL. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: sale_item

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| sale_id | Chave interna | Sim | FK para sale. |
| product_id | UUID | Sim | Referência lógica ao product (projects/products). |
| quantity | Decimal(12,2) | Não | Quantidade; default 1. |
| unit_price | Decimal(12,2) | Não | Preço unitário; default 0. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 25. projects/todo

**Objetivo:** Tarefas, projetos e notas integrados ao sistema distribuído. Referências lógicas a accounts (users) por UUID; entidades locais (project, status, tag) com external_id e tenant para consistência entre serviços.

**Relação lógica:** tenant; account_id e author_id referenciam projects/accounts (ou users); project_id e status_id são FKs locais; todo_tag liga todo a tag.

### Tabela: project

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| name | Texto | Sim | Nome do projeto. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: status

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Não | Tenant (NULL = status global). |
| code | Texto | Sim | Código (ex.: open, in_progress, closed). |
| name | Texto | Sim | Nome exibido. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: tag

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| name | Texto | Sim | Nome da tag. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: todo

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Responsável (referência lógica ao account). |
| project_id | Chave interna | Sim | FK para project. |
| status_id | Chave interna | Sim | FK para status. |
| title | Texto | Sim | Título da tarefa. |
| description | Texto | Não | Descrição. |
| due_date | Data | Não | Data de vencimento. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: todo_tag

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| todo_id | Chave interna | Sim | FK para todo. |
| tag_id | Chave interna | Sim | FK para tag. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: project_member

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Membro (referência lógica ao account). |
| project_id | Chave interna | Sim | FK para project. |
| role | Texto | Não | Papel (ex.: admin, member). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: comment

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| todo_id | Chave interna | Sim | FK para todo. |
| author_id | UUID | Sim | Autor (referência lógica ao account). |
| content | Texto | Sim | Conteúdo do comentário. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: attachment

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| todo_id | Chave interna | Sim | FK para todo. |
| file_ref | Texto | Não | Referência ao ficheiro (ex.: storage ou URL). |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: note

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Dono da nota (referência lógica ao account). |
| content | Texto | Sim | Conteúdo. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |
