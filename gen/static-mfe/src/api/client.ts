import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000';

export const apiClient = axios.create({
  baseURL: `${API_BASE_URL}/{{kebabName}}`,
  headers: {
    'Content-Type': 'application/json',
  },
});

apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error('API Error:', error.response?.data || error.message);
    return Promise.reject(error);
  }
);

export const {{camelName}}Api = {
  getAll: () => apiClient.get('/'),
  getById: (id: string) => apiClient.get(`/${id}`),
  create: (data: unknown) => apiClient.post('/', data),
  update: (id: string, data: unknown) => apiClient.put(`/${id}`, data),
  delete: (id: string) => apiClient.delete(`/${id}`),
};
