<!-- test/e2e-generator-mock/DATA_DICTIONARY.md -->
# Dicionário de Dados — Projetos E2E (Accounts, Addresses, Contacts, Users, Companies, Payments, Transactions, Auth, Notifications, Products, Inventory, Orders, Logistics, Reports)

Relacionamentos entre projetos são apenas lógicos (campos UUID). Não há Foreign Keys entre bases.

---

## 1. projects/accounts

**Relação lógica:** tenant.

### Tabela: account

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna (SERIAL/IDENTITY/AUTO_INCREMENT) | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant ao qual a conta pertence. |
| name | Texto | Sim | Nome da conta. |
| account_type | Texto | Sim | Tipo (ex.: checking, savings). |
| balance | Decimal(12,2) | Não | Saldo; default 0. |
| currency_code | Texto (3) | Não | Código da moeda; default BRL. |
| created_at | Timestamp | Sim (default) | Data/hora de criação. |
| updated_at | Timestamp | Não | Data/hora da última atualização. |
| deleted_at | Timestamp | Não | Exclusão lógica (soft delete); NULL = ativo. |

---

## 2. projects/addresses

**Relação lógica:** account_id, tenant.

### Tabela: address

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account (projects/accounts). |
| street | Texto | Sim | Logradouro. |
| city | Texto | Sim | Cidade. |
| state | Texto | Não | Estado/região. |
| zip_code | Texto | Não | CEP/código postal. |
| country | Texto | Não | País; default BR. |
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

## 5. projects/companies

**Relação lógica:** account_id, contact_id, address_id, tenant.

### Tabela: company

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

**Relação lógica:** account_id, contact_id, billing_address_id (address), tenant.

Método de pagamento: apenas `DEBITO`, `CREDITO`, `PIX`, `BOLETO`, `CRIPTO`, `SWIFT`, `SEPA`, `ACH`.

### Tabela: payment

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Sim | Referência lógica ao account. |
| contact_id | UUID | Não | Titular/contacto. |
| billing_address_id | UUID | Não | Morada de faturação (address). |
| method | Enum | Sim | DEBITO, CREDITO, PIX, BOLETO, CRIPTO, SWIFT, SEPA, ACH. |
| amount | Decimal(12,2) | Não | Valor; default 0. |
| currency_code | Texto (3) | Não | Moeda; default BRL. |
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
| channel | Texto | Não | Canal (email, sms, push). |
| subject | Texto | Não | Assunto. |
| body | Texto | Não | Corpo da mensagem. |
| read_at | Timestamp | Não | Data de leitura; NULL = não lida. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 10. projects/products

**Relação lógica:** account_id (fornecedor/criador), tenant. Catálogo, preços e descrições.

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
| unit_price | Decimal(12,2) | Não | Preço unitário; default 0. |
| currency_code | Texto (3) | Não | Moeda; default BRL. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

---

## 11. projects/inventory

**Relação lógica:** product_id, address_id (local do stock), tenant. Disponibilidade, reservas e baixas.

### Tabela: inventory_level

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| product_id | UUID | Sim | Referência lógica ao product. |
| address_id | UUID | Sim | Local do stock (address). |
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
| status | Texto | Não | Estado do pedido (draft, confirmed, shipped, etc.). |
| total | Decimal(12,2) | Não | Total; default 0. |
| currency_code | Texto (3) | Não | Moeda; default BRL. |
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

**Relação lógica:** order_id, origin_address_id, destination_address_id, driver_contact_id, receiver_contact_id, tenant. Rastreamento, rotas e estado de entrega.

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
| status | Texto | Não | Estado da entrega (pending, in_transit, delivered). |
| tracking_code | Texto | Não | Código de rastreio. |
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

### Tabela: current_inventory_levels

Tabela física. Atualização esperada: sob demanda ou diária.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| tenant | UUID | Sim | Tenant. |
| product_id | UUID | Sim | Referência lógica ao product. |
| address_id | UUID | Sim | Local (address). |
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

### VIEW: v_inventory_levels

Lê de `current_inventory_levels`. Apresenta níveis de stock atuais.

### VIEW: v_logistics_performance

Lê de `logistics_performance`. Apresenta indicadores de logística.
