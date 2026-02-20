<!-- test/e2e-generator-mock/DATA_DICTIONARY_REFACTOR.md -->
# Dicionário de Dados — Refatoração Schedule, Selling e Todo (Microserviços)

Este documento descreve a refatoração dos modelos de dados dos projetos **schedule**, **selling** e **todo** para alinhamento à arquitetura de microserviços: remoção de entidades que pertencem a domínios globais e substituição por referências lógicas (UUID) sem `FOREIGN KEY` física para outros serviços.

---

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

## 1. Projeto Selling

### Removido (deduplicação de domínio)

| Tabela / conceito        | Motivo |
|--------------------------|--------|
| tb_customer             | Pertence a accounts/users. |
| tb_customer_address     | Pertence a addresses. |
| tb_payment_method       | Pertence a payments. |
| tb_payment              | Pertence a payments. |
| tb_stock_movement        | Pertence a inventory. |

### Mantido e ajustado

**tb_order**

- **Removido:** `customer_id` (FK para tb_customer), `payment_method_id` (FK para tb_payment_method).
- **Adicionado / substituído por referências lógicas (UUID):**
  - `account_id` (UUID NOT NULL) — comprador/responsável (referência lógica a accounts).
  - `billing_address_id` (UUID) — endereço de faturação (referência lógica a addresses).
  - `shipping_address_id` (UUID) — endereço de envio (referência lógica a addresses).
  - `payment_id` (UUID) — pagamento associado (referência lógica a payments).
- Mantidos no mesmo escopo: `id`, `tenant`, `external_id`, `status`, `total`, `discount`, `ordered_at`, `created_at`, `updated_at`, `deleted_at`. Sem FKs para outros serviços.

**tb_order_line**

- **Removido:** `product_sku` (e uso de texto como referência a produto).
- **Adicionado:** `product_id` (UUID NOT NULL) — referência lógica ao domínio products.
- Opcional: `product_name` (TEXT) para cache de exibição, sem vínculo físico.
- Mantidos: `order_id` (FK local para tb_order), `line_number`, `tenant`, `external_id`, `quantity`, `unit_price`, `line_total`, `created_at`, `updated_at`, `deleted_at`.

---

## 2. Projeto Schedule

### Removido (deduplicação de domínio)

| Tabela / conceito       | Motivo |
|-------------------------|--------|
| tb_participant         | Participantes são usuários/contas; pertence a users ou accounts. |

### Ajustado

**tb_booking_participant**

- **Removido:** `participant_id` (FK para tb_participant).
- **Adicionado:** `account_id` (UUID NOT NULL) — referência lógica ao participante (accounts/users).
- Mantidos: `booking_id` (FK local para tb_booking), `tenant`, `external_id`, `role`, `created_at`, `updated_at`, `deleted_at`. PK composta: (booking_id, account_id).

**tb_booking**

- **Adicionado (opcional):** `organizer_account_id` (UUID) — responsável principal pelo agendamento (referência lógica a accounts).
- Mantidos: `slot_id`, `recurrence_rule_id`, `title`, `description`, demais campos de auditoria e tenant/external_id.

**Mantidas sem alteração de domínio**

- tb_resource (com parent_id FK local para hierarquia).
- tb_slot (FK local para tb_resource).
- tb_recurrence_rule.
- tb_booking_history (FK local para tb_booking).

---

## 3. Projeto Todo

### Removido (deduplicação de domínio)

| Tabela / conceito | Motivo |
|-------------------|--------|
| tb_product        | Pertence a products. |
| tb_sale           | Pertence a vendas/orders. |
| tb_sale_item      | Pertence a vendas/orders. |
| tb_document       | Artefatos binários devem ser tratados por serviço de storage. |
| tb_product_tag    | Junção produto–tag; produto removido. |

### Mantido e ajustado

**tb_simple_item**

- **Adicionado:** `category_id` (INTEGER, FK local para tb_category) — classificação no contexto todo.
- **Adicionado:** `product_id` (UUID) — referência lógica ao domínio products quando o item se relacionar a um produto.
- Mantidos: `id`, `tenant`, `external_id`, `name`, `created_at`, `updated_at`, `deleted_at`.

**tb_category**

- Mantida para agrupamento/classificação local (sem alteração de estrutura).

**tb_tag**

- Mantida (sem alteração de estrutura).

**Nova tabela**

- **tb_simple_item_tag** — junção N-N entre tb_simple_item e tb_tag (ambas locais). Campos: `simple_item_id` (FK tb_simple_item), `tag_id` (FK tb_tag), `tenant`, `external_id`, `created_at`, `updated_at`, `deleted_at`. PK: (simple_item_id, tag_id).

---

## Resumo das referências lógicas (UUID)

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
