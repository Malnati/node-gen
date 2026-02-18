// /templates/interface.template.ts
/**
 * Interfaces de transferência de dados para User.
 *
 * `IUserQueryDTO` descreve o formato de retorno das consultas,
 * enquanto `IUserPersistDTO` define os campos aceitos para
 * criação ou atualização da entidade.
 */
/**
   * DTO retornado em consultas de User.
   */
export interface IUserQueryDTO {
  external_id?: string;
  name?: string;
}

/**
   * DTO utilizado para criar ou atualizar User.
   */
export interface IUserPersistDTO {
  external_id: string;
  name: string;
}
