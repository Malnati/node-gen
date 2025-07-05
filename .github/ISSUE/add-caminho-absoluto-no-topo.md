# Solicitação: Adicionar comentário de caminho absoluto no topo de cada arquivo

## Objetivo

Adicionar um comentário no topo de **todos os arquivos** localizados em:

- `src/` (incluindo subdiretórios)
- `templates/`
- `static/src/` e todos os seus subdiretórios
- Além dos arquivos:
  - `.gitignore`
  - `.npmignore`
  - `.prettierignore`
  - `.prettierrc`
  - `gen.sh`
  - `README.md`
  - `.editorconfig`

O comentário deve conter o **caminho absoluto do arquivo em relação ao repositório**.  
**Observação:** Se houver shebang (`#!/bin/bash`) ou outro conteúdo desnecessário no topo, pode ser removido.

---

## Instruções detalhadas

1. **Para cada arquivo listado acima:**
   - Adicione um comentário na primeira linha, contendo o caminho absoluto do arquivo, por exemplo:
     - Para `src/main.ts`:
       ```ts
       // /src/main.ts
       ```
     - Para `templates/controller.template.ts`:
       ```ts
       // /templates/controller.template.ts
       ```
     - Para arquivos shell:
       ```sh
       # /gen.sh
       ```
     - Para arquivos de configuração:
       ```ini
       # /.editorconfig
       ```
   - O tipo de comentário deve respeitar a sintaxe do arquivo (ex: `//` para TypeScript, `#` para shell/config, `<!-- -->` para HTML, etc).

2. **Remover shebangs ou outros conteúdos desnecessários do topo, se existirem.**

---

## Exemplos

### Exemplo 1: TypeScript (`src/main.ts`)

**Antes:**
```ts
import { ... } from '...'
// ...restante do código...
```

**Depois:**
```ts
// /src/main.ts
import { ... } from '...'
// ...restante do código...
```

---

### Exemplo 2: Shell Script (`gen.sh`)

**Antes:**
```sh
#!/bin/bash

echo "Deve gerar o projeto $1"
# ...restante do script...
```

**Depois:**
```sh
# /gen.sh

echo "Deve gerar o projeto $1"
# ...restante do script...
```

---

### Exemplo 3: Configuração (`.editorconfig`)

**Antes:**
```ini
# EditorConfig is awesome: https://EditorConfig.org

root = true
# ...restante do arquivo...
```

**Depois:**
```ini
# /.editorconfig
# EditorConfig is awesome: https://EditorConfig.org

root = true
# ...restante do arquivo...
```

---

### Exemplo 4: Template TypeScript (`templates/controller.template.ts`)

**Antes:**
```ts
import { Controller } from '@nestjs/common'
// ...restante do template...
```

**Depois:**
```ts
// /templates/controller.template.ts
import { Controller } from '@nestjs/common'
// ...restante do template...
```

---

### Exemplo 5: HTML (`static/public/index.html`)

**Antes:**
```html
<!DOCTYPE html>
<html>
<!-- ... -->
</html>
```

**Depois:**
```html
<!-- /static/public/index.html -->
<!DOCTYPE html>
<html>
<!-- ... -->
</html>
```

---

## Observações

- O comentário deve ser sempre a **primeira linha** do arquivo.
- Utilize a sintaxe de comentário apropriada para cada tipo de arquivo.
- Não altere o restante do conteúdo do arquivo.
- Remova o shebang se houver, substituindo pelo comentário do caminho.

---

**Checklist para revisão:**
- [ ] Todos os arquivos em `src/` e subdiretórios ajustados
- [ ] Todos os arquivos em `templates/` ajustados
- [ ] Todos os arquivos em `static/src/` e subdiretórios ajustados
- [ ] Arquivos `.gitignore`, `.npmignore`, `.prettierignore`, `.prettierrc`, `gen.sh`, `README.md`, `.editorconfig` ajustados
- [ ] Comentário de caminho absoluto na primeira linha
- [ ] Shebang removido quando necessário

---

**IMPORTANTE:**  
Não altere arquivos fora dos caminhos e lista especificados.

---

Se precisar de exemplos para outros tipos de arquivo, adicione-os na resposta da issue. 