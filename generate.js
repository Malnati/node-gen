const fs = require('fs');
const ejs = require('ejs');
const path = require('path');

// Carrega o JSON com os metadados do banco de dados
const metadataPath = path.join(__dirname, 'build/db.metadata.json');
const metadataJSONContent = JSON.parse(fs.readFileSync(metadataPath, 'utf-8'));

// Caminho para salvar os arquivos de saída
const rootOutputDir = path.join(__dirname, 'build');

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
// Carrega o template EJS para module
const moduleTemplatePath = path.join(__dirname, 'templates/module.ejs');
const moduleTemplateContent = fs.readFileSync(moduleTemplatePath, 'utf-8');

// Carrega o template EJS para 'README.md'
const readmeTemplatePath = path.join(__dirname, 'templates/readme.ejs');
const readmeTemplateContent = fs.readFileSync(readmeTemplatePath, 'utf-8');
const readmeContentOutput = ejs.render(readmeTemplateContent, metadataJSONContent);
// Define o nome do arquivo com base no nome da 'README.md'
const readmeOutputPath = path.join(rootOutputDir, 'README.md');
// Salva o arquivo para a 'README.md' específica
fs.writeFileSync(readmeOutputPath, readmeContentOutput);
console.log(`README.md gerada com sucesso em ${readmeOutputPath}`);

// Carrega o template EJS para package.json
const packageTemplatePath = path.join(__dirname, 'templates/package.ejs');
const packageTemplateContent = fs.readFileSync(packageTemplatePath, 'utf-8');
const packageContentOutput = ejs.render(packageTemplateContent, metadataJSONContent);
// Define o nome do arquivo com base no nome da package.json
const packageOutputPath = path.join(rootOutputDir, 'package.json');
// Salva o arquivo para a package.json específica
fs.writeFileSync(packageOutputPath, packageContentOutput);
console.log(`package.json gerada com sucesso em ${packageOutputPath}`);

// Carrega o template EJS para .env
const envTemplatePath = path.join(__dirname, 'templates/env.ejs');
const envTemplateContent = fs.readFileSync(envTemplatePath, 'utf-8');
const envContentOutput = ejs.render(envTemplateContent, metadataJSONContent);
// Define o nome do arquivo com base no nome da env.json
const envOutputPath = path.join(rootOutputDir, '.env');
// Salva o arquivo para a env.json específica
fs.writeFileSync(envOutputPath, envContentOutput);
console.log(`.env gerada com sucesso em ${envOutputPath}`);

// Carrega o template EJS para main.ts
const mainTemplatePath = path.join(__dirname, 'templates/main.ejs');
const mainTemplateContent = fs.readFileSync(mainTemplatePath, 'utf-8');
const mainContentOutput = ejs.render(mainTemplateContent, metadataJSONContent);
// Define o nome do arquivo com base no nome da main.json
const mainOutputPath = path.join(rootOutputDir, 'app/main.ts');
// Salva o arquivo para a main.ts específica
fs.writeFileSync(mainOutputPath, mainContentOutput);
console.log(`main.ts gerada com sucesso em ${mainOutputPath}`);


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

	// Gera um arquivo separado para cada module
	const moduleContentOutput = ejs.render(moduleTemplateContent, { table });
	// Define o nome do arquivo com base no nome do module
	const moduleOutputPath = path.join(moduleOutputDir, `${table.entityName}Module.ts`);
	// Salva o arquivo para o module específico
	fs.writeFileSync(moduleOutputPath, moduleContentOutput);
	console.log(`module ${table.entityName}Module.ts gerada com sucesso em ${moduleOutputPath}`);
});
