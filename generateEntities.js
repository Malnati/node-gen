const fs = require('fs');
const ejs = require('ejs');
const path = require('path');

// Carrega o JSON com os metadados do banco de dados
const metadataPath = path.join(__dirname, 'build/db.metadata.json');
const metadataJSONContent = JSON.parse(fs.readFileSync(metadataPath, 'utf-8'));

// Carrega o template EJS para entidades
const entitiesTemplatePath = path.join(__dirname, 'templates/typeorm-entity.ejs');
const entitiesTemplateContent = fs.readFileSync(entitiesTemplatePath, 'utf-8');
// Caminho para salvar os arquivos de saída
const entitiesOutputDir = path.join(__dirname, 'build/src/app/entities');
// Cria o diretório de saída, se não existir
if (!fs.existsSync(entitiesOutputDir)) {
	fs.mkdirSync(entitiesOutputDir, { recursive: true });
}
// Carrega o template EJS para entidades
const servicesTemplatePath = path.join(__dirname, 'templates/services.ejs');
const servicesTemplateContent = fs.readFileSync(servicesTemplatePath, 'utf-8');

// Gera um arquivo separado para cada entidade
metadataJSONContent.schema.forEach(table => {
	const entitiesContentOutput = ejs.render(entitiesTemplateContent, { table });
	// Define o nome do arquivo com base no nome da entidade
	const entitiesOutputPath = path.join(entitiesOutputDir, `${table.entityName}.ts`);
	// Salva o arquivo para a entidade específica
	fs.writeFileSync(entitiesOutputPath, entitiesContentOutput);
	console.log(`Entidade ${table.entityName} gerada com sucesso em ${entitiesOutputPath}`);


	// Caminho para salvar os arquivos de saída
	const moduleOutputDir = path.join(__dirname, `build/src/app/${table.slugName}`);
	// Cria o diretório de saída, se não existir
	if (!fs.existsSync(moduleOutputDir)) {
		fs.mkdirSync(moduleOutputDir, { recursive: true });
	}
	const servicesContentOutput = ejs.render(servicesTemplateContent, { table });
	// Define o nome do arquivo com base no nome da entidade
	const serviceOutputPath = path.join(moduleOutputDir, `${table.entityName}Service.ts`);
	// Salva o arquivo para a entidade específica
	fs.writeFileSync(serviceOutputPath, servicesContentOutput);
	console.log(`Serviço ${table.entityName}Service.ts gerada com sucesso em ${serviceOutputPath}`);
});
