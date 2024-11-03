import { join } from 'path';
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ServeStaticModule } from '@nestjs/serve-static';
import { VersionModule } from './version/version.module';
import { EnvironmentModule } from './config/environment.module';

@Module({
	imports: [
		ConfigModule.forRoot({
			isGlobal: true,
			envFilePath:
				process.env.NODE_ENV === 'test'
					? '.env.test'
					: ['.env.local', '.env'],
		}),
		ServeStaticModule.forRoot({
			rootPath: join(__dirname, '..', '..', 'public'),
		}),
		EnvironmentModule,
		VersionModule,
	],
})
export class AppModule {}
