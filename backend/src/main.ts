import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: ['log', 'error', 'warn', 'debug'],
  });
  await app.listen(Number(process.env.PORT), '0.0.0.0');
  Logger.debug(`🚀 Application is running on: ${await app.getUrl()}`);
}
bootstrap();
