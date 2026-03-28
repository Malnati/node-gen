// gen/static-api/src/modules/proxy/proxy.service.ts
import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { AxiosError } from 'axios';
import { catchError, firstValueFrom } from 'rxjs';

@Injectable()
export class ProxyService {
  private readonly baseUrl: string;

  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
  ) {
    this.baseUrl = this.configService.get<string>('PROXY_TARGET_URL') || '';
  }

  async forwardRequest(
    path: string,
    method: string,
    data: any,
    headers: Record<string, string>,
  ) {
    if (!this.baseUrl) {
        return { message: 'Proxy not configured (PROXY_TARGET_URL missing)' };
    }

    const url = `${this.baseUrl}/${path.replace(/^\/+/, '')}`;

    const forwardHeaders: Record<string, string | undefined> = {
      'content-type': headers['content-type'] || 'application/json',
      'authorization': headers['authorization'],
      'x-api-key': headers['x-api-key'],
    };

    const config = {
      method,
      url,
      data: method !== 'GET' && data ? data : undefined,
      headers: forwardHeaders,
      timeout: 30000,
    };

    try {
      const response = await firstValueFrom(
        this.httpService.request(config).pipe(
          catchError((error: AxiosError) => {
            throw new HttpException(
              error.response?.data || error.message,
              error.response?.status || HttpStatus.BAD_GATEWAY,
            );
          }),
        ),
      );
      return response.data;
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      throw new HttpException('Proxy error', HttpStatus.BAD_GATEWAY);
    }
  }
}
