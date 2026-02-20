<!-- test/e2e-generator-mock/DATA_DICTIONARY.md -->
# Dicionário de Dados — Projetos E2E (1–21)

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

---

## 15. projects/rbac

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

## 16. projects/system_config

**Relação lógica:** tenant. Administração global do software, configurações de integrações externas, parâmetros globais e webhooks.

### Tabela: system_config

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

---

## 17. projects/scheduling

**Relação lógica:** user_id, account_id, tenant. Agendamentos, calendários, slots de tempo e marcações públicas.

### Tabela: calendar

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| account_id | UUID | Não | Referência lógica ao account (dono do calendário). |
| user_id | UUID | Não | Referência lógica ao app_user. |
| name | Texto | Sim | Nome do calendário. |
| timezone | Texto | Não | Fuso (ex.: Europe/Lisbon); default UTC. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: time_slot

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| calendar_id | UUID | Sim | Referência lógica ao calendar. |
| start_at | Timestamp | Sim | Início do slot. |
| end_at | Timestamp | Sim | Fim do slot. |
| available | Booleano | Não | Disponível para reserva; default true. |
| created_at | Timestamp | Sim (default) | Criação. |
| updated_at | Timestamp | Não | Última atualização. |
| deleted_at | Timestamp | Não | Soft delete. |

### Tabela: booking

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | Chave interna | Sim | Identificador físico interno. |
| external_id | UUID | Sim, único | Identificador exposto a outros serviços. |
| tenant | UUID | Sim | Tenant. |
| time_slot_id | UUID | Sim | Referência lógica ao time_slot. |
| user_id | UUID | Não | Utilizador que marca. |
| account_id | UUID | Não | Conta associada. |
| status | Texto | Não | Estado (pending, confirmed, cancelled). |
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

## 20. projects/llm_integrations

**Relação lógica:** account_id, tenant. Modelos de IA, roteamento, fallback (ex.: Ollama), templates de prompts e logs de execução.

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
