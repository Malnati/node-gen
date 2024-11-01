const fs = require('fs');
const ejs = require('ejs');
const path = require('path');

// Carrega o JSON com os metadados do banco de dados
const metadataPath = path.join(__dirname, 'src/metadata.json');
const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf-8'));

// Carrega o template EJS para entidades
const templatePath = path.join(__dirname, 'templates/typeorm-entity.ejs');
const template = fs.readFileSync(templatePath, 'utf-8');

// Caminho para salvar os arquivos de saída
const outputDir = path.join(__dirname, 'generatedEntities');

// Cria o diretório de saída, se não existir
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir);
}

// Gera um arquivo separado para cada entidade
metadata.schema.forEach(table => {
  const output = ejs.render(template, { table });

  // Define o nome do arquivo com base no nome da entidade
  const outputPath = path.join(outputDir, `${table.entityName}.ts`);

  // Salva o arquivo para a entidade específica
  fs.writeFileSync(outputPath, output);

  console.log(`Entidade ${table.entityName} gerada com sucesso em ${outputPath}`);
});
