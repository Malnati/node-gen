// src/api/client.ts
// Placeholder - will be replaced by generated code

export interface PagingRequest {
  page?: number;
  pageSize?: number;
  sort?: string;
  order?: 'ASC' | 'DESC';
  filters?: Record<string, any>;
}

export interface PagingResponse<T> {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

export const pagingApi = {
  async getPage<T>(request: PagingRequest): Promise<PagingResponse<T>> {
    throw new Error('Not implemented - replace with generated code');
  },
};
