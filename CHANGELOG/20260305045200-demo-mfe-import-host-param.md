<!-- CHANGELOG/20260305045200-demo-mfe-import-host-param.md -->
# 2026-03-05 04:52:00 UTC — Parametrização de host de importUrl no demo MFE

## Arquivos modificados
- `Makefile`

## Regras e requisitos atendidos
- Correção direta e de escopo mínimo para publicação remota dos MFEs no demo SSPA.
- Mantido fluxo exclusivo via `Makefile`, sem scripts shell adicionais.
- Rastreabilidade registrada em `CHANGELOG/` para esta entrega.

## Comandos executados
- `sed -n '220,310p' /root/w/node-gen/Makefile`
- `make demo-pg-up DEMO_MFE_IMPORT_HOST=157.173.125.230`
- `cat /tmp/nodegen-demo-discovery-apps.json`
- `docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'`

## Resultado resumido
- Status: **passou**
- Motivo objetivo: `importUrl` do manifesto dinâmico agora aceita host parametrizável por variável do `Makefile`.

## Definição de pronto (item a item)
- [x] Permitir publicar MFEs com host externo em `importUrl`.
- [x] Regerar/publicar/subir novamente o demo com host `157.173.125.230`.
- [x] Validar manifesto gerado com as URLs externas.
