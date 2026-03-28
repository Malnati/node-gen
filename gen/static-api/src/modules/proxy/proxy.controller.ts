// gen/static-api/src/modules/proxy/proxy.controller.ts
import { Controller, Post, Get, Body, Headers, Req, Res, All } from '@nestjs/common';
import { ProxyService } from './proxy.service';
import { Request, Response } from 'express';

@Controller('bff')
export class ProxyController {
  constructor(private readonly proxyService: ProxyService) {}

  @All('*')
  async proxy(
    @Body() body: any,
    @Headers() headers: Record<string, string>,
    @Req() req: Request,
    @Res() res: Response,
  ) {
    const path = req.params[0] || '';
    const method = req.method;

    try {
      const result = await this.proxyService.forwardRequest(
        path,
        method,
        body,
        headers,
      );
      return res.status(200).json(result);
    } catch (error) {
      throw error;
    }
  }
}
