// /templates/dto.template.ts
import { IsOptional, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";
import { IUserQueryDTO, IUserPersistDTO } from "./user.interface";

/**
 * Data Transfer Object for User.
 *
 * Utilizado para transferir dados entre a camada de persistência e a camada de controle,
 * ocultando chaves primárias e datas automáticas, enquanto expõe os external_id e outras
 * informações de negócio relevantes.
 */
/**
 * DTO usado para consultas de User.
 */
export class UserQueryDTO implements IUserQueryDTO {
  @IsOptional()
  @IsString()
  @ApiProperty({
    example: "b2e293e5-4a4a-4b29-b9a4-4b2b4a4a4b2b",
    description: "Descrição do campo.",
  })
  external_id: string;
  @IsOptional()
  @IsString()
  @ApiProperty({
    example: "exemplo",
    description: "Descrição do campo.",
  })
  name: string;
}

/**
 * DTO utilizado para criação/atualização de User.
 */
export class UserPersistDTO implements IUserPersistDTO {
  @IsOptional()
  @IsString()
  @ApiProperty({
    example: "b2e293e5-4a4a-4b29-b9a4-4b2b4a4a4b2b",
    description: "Descrição do campo.",
  })
  external_id: string;
  @IsOptional()
  @IsString()
  @ApiProperty({
    example: "exemplo",
    description: "Descrição do campo.",
  })
  name: string;
}
