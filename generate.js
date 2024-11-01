const fs = require('fs');
const ejs = require('ejs');
const path = require('path');

// Carrega o JSON com os metadados do banco de dados
const metadataPath = path.join(__dirname, 'build/db.metadata.json');
const metadataJSONContent = JSON.parse(fs.readFileSync(metadataPath, 'utf-8'));

// Carrega o template EJS para entidades
const entitiesTemplatePath = path.join(__dirname, 'templates/entities.ejs');
const entitiesTemplateContent = fs.readFileSync(entitiesTemplatePath, 'utf-8');
// Caminho para salvar os arquivos de saída
const entitiesOutputDir = path.join(__dirname, 'build/src/app/entities');
// Cria o diretório de saída, se não existir
if (!fs.existsSync(entitiesOutputDir)) {
	fs.mkdirSync(entitiesOutputDir, { recursive: true });
}
// Carrega o template EJS para serviços
const servicesTemplatePath = path.join(__dirname, 'templates/services.ejs');
const servicesTemplateContent = fs.readFileSync(servicesTemplatePath, 'utf-8');
// Carrega o template EJS para controllers
const controllersTemplatePath = path.join(__dirname, 'templates/controllers.ejs');
const controllersTemplateContent = fs.readFileSync(controllersTemplatePath, 'utf-8');
// Carrega o template EJS para dtos
const dtosTemplatePath = path.join(__dirname, 'templates/dtos.ejs');
const dtosTemplateContent = fs.readFileSync(dtosTemplatePath, 'utf-8');
// Carrega o template EJS para interfaces
const interfacesTemplatePath = path.join(__dirname, 'templates/interfaces.ejs');
const interfacesTemplateContent = fs.readFileSync(interfacesTemplatePath, 'utf-8');

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

	// Gera um arquivo separado para cada serviço
	const servicesContentOutput = ejs.render(servicesTemplateContent, { table });
	// Define o nome do arquivo com base no nome do serviço
	const serviceOutputPath = path.join(moduleOutputDir, `${table.entityName}Service.ts`);
	// Salva o arquivo para o serviço específico
	fs.writeFileSync(serviceOutputPath, servicesContentOutput);
	console.log(`Serviço ${table.entityName}Service.ts gerada com sucesso em ${serviceOutputPath}`);

	// Gera um arquivo separado para cada Controller
	const controllersContentOutput = ejs.render(controllersTemplateContent, { table });
	// Define o nome do arquivo com base no nome do Controller
	const controllersOutputPath = path.join(moduleOutputDir, `${table.entityName}Controller.ts`);
	// Salva o arquivo para o Controller específico
	fs.writeFileSync(controllersOutputPath, controllersContentOutput);
	console.log(`Controller ${table.entityName}Controller.ts gerada com sucesso em ${controllersOutputPath}`);

	// Gera um arquivo separado para cada DTOs
	const dtosContentOutput = ejs.render(dtosTemplateContent, { table });
	// Define o nome do arquivo com base no nome do DTOs
	const dtosOutputPath = path.join(moduleOutputDir, `${table.entityName}DTOs.ts`);
	// Salva o arquivo para o DTOs específico
	fs.writeFileSync(dtosOutputPath, dtosContentOutput);
	console.log(`DTOs ${table.entityName}DTOs.ts gerada com sucesso em ${dtosOutputPath}`);

	// Gera um arquivo separado para cada interfaces
	const interfacesContentOutput = ejs.render(interfacesTemplateContent, { table });
	// Define o nome do arquivo com base no nome do interfaces
	const interfacesOutputPath = path.join(moduleOutputDir, `${table.entityName}Interfaces.ts`);
	// Salva o arquivo para o interfaces específico
	fs.writeFileSync(interfacesOutputPath, interfacesContentOutput);
	console.log(`Interfaces ${table.entityName}Interfaces.ts gerada com sucesso em ${interfacesOutputPath}`);
});
