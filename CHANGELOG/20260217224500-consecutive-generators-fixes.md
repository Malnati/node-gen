<!-- CHANGELOG/20260217224500-consecutive-generators-fixes.md -->

# 2026-02-17 22:45:00 UTC — Correções consecutivas em todos os geradores (inconformidades aprovadas)

## Arquivos modificados
- `src/env-generator.ts`
- `src/interface-generator.ts`
- `src/dto-generator.ts`
- `src/diagram-generator.ts`
- `src/readme-generator.ts`
- `CHANGELOG/20260217224500-consecutive-generators-fixes.md`

## Regras e requisitos atendidos
- Execução consecutiva das correções aprovadas nos CHANGELOGs e no plano de revisão EPIC/SUB.
- Alterações restritas a inconformidades e defeitos já registrados; sem expansão de escopo.

## Correções implementadas

### env-generator.ts
- PORT, ENDPOINT_SESSION_TOKEN e ENDPOINT_SESSION_HEALTHCHECK passam a usar `process.env.* ?? default`, permitindo override em tempo de geração sem alterar código.
- Valores padrão mantidos para compatibilidade com o comportamento anterior quando variáveis de ambiente não estão definidas.

### interface-generator.ts
- `mapType` ampliado: smallint, serial, bigserial, real, double precision, varchar, char, bool, timestamptz, time, time with time zone.
- Fallback continua `any`; uso de `??` e tentativa com `dataType.toLowerCase()` para melhor cobertura.

### dto-generator.ts
- `mapType` alinhado ao interface-generator (mesmos tipos) para evitar validação incorreta e fallback indevido.
- Inclusão de `@IsBoolean()` quando tipo mapeado é boolean.
- `getExampleForColumn` ampliado para smallint, numeric, decimal, boolean/bool, varchar, text, date, timestamptz.

### diagram-generator.ts
- Schema vazio: retorna SVG mínimo com mensagem "Nenhuma tabela no schema." em vez de quebrar em `Math.max(...[])`.
- Criação do diretório `public` antes de escrever o arquivo (path com `path.join` e `fs.mkdirSync`).
- Import de `path` adicionado.

### readme-generator.ts
- `mapType` ampliado para documentação: smallint, serial, bigserial, real, double precision, timestamptz, time, varchar, char, bool; uso de `??` e `toLowerCase()` para aliases.

## Comandos executados e resultado
- `npm run build` — sucesso (tsc concluído).

## Resultado resumido
- Inconformidades de env (hardcode), interface/dto (mapeamento de tipos), diagram (schema vazio e diretório) e readme (mapeamento) endereçadas.
- Build do gerador validado com sucesso.
