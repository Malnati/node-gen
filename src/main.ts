import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app/AppModule';
import { EnvironmentService } from './app/config/environment.service';
import { AppReadinessService } from './app/config/app.readiness.service';

async function bootstrap() {
	const app = await NestFactory.create(AppModule);

	app.connectMicroservice<MicroserviceOptions>({
		transport: Transport.TCP,
		options: { retryAttempts: 5, retryDelay: 3000 },
	});

	app.enableCors({
		allowedHeaders: 'Authorization, X-Requested-With, Content-Type, Accept',
		origin: '*',
		methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
		credentials: true,
	});

	const isProd = process.env.NODE_ENV === 'production';
	const microserviceName =
		app.get(EnvironmentService).getEnv().get<string>('MICROSERVICE_NAME') ||
		'Postgres';

	const microservicePort =
		app.get(EnvironmentService).getEnv().get<string>('PORT') || '3001';

	if (!isProd) {

		const config = new DocumentBuilder()
			.setTitle(microserviceName)
			.setDescription(microserviceName)
			.setVersion('1.0')
			.addTag('system')
			.addBearerAuth(
				{ type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
				'access_token'
			)
			.build();
		const document = SwaggerModule.createDocument(app, config);
		SwaggerModule.setup('api', app, document);
	}

	await app.startAllMicroservices();
	const PORT = process.env.PORT || microservicePort;
	await app.listen(PORT);

	try {
		const appUrl = await app.getUrl();
		console.log(`Application ${microserviceName} is running on: ${appUrl}`);
		const appReadinessService = app.get(AppReadinessService);
		appReadinessService.setAppReady(true);
	} catch (error) {
		console.error('Error obtaining application URL:', error);
	}
}

bootstrap().catch((error) => {
	console.error('Application initialization error:', error);
});
