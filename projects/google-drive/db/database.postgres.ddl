-- test/e2e-generator/projects/google-drive/db/database.postgres.ddl
CREATE TABLE drive_integration (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  connected_email TEXT NOT NULL,
  oauth_ref TEXT,
  last_sync_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_drive_integration PRIMARY KEY (id),
  CONSTRAINT uk_drive_integration_external_id UNIQUE(external_id)
);

COMMENT ON TABLE drive_integration IS 'Integração Google Drive por conta e tenant.';
COMMENT ON COLUMN drive_integration.id IS 'Identificador interno.';
COMMENT ON COLUMN drive_integration.external_id IS 'UUID público.';
COMMENT ON COLUMN drive_integration.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN drive_integration.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN drive_integration.connected_email IS 'E-mail conectado.';
COMMENT ON COLUMN drive_integration.oauth_ref IS 'Referência OAuth.';
COMMENT ON COLUMN drive_integration.last_sync_at IS 'Última sincronização.';
COMMENT ON COLUMN drive_integration.created_at IS 'Data de criação.';
COMMENT ON COLUMN drive_integration.updated_at IS 'Última atualização.';
COMMENT ON COLUMN drive_integration.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_drive_integration ON drive_integration IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_drive_integration_external_id ON drive_integration IS 'UUID único.';

CREATE TABLE drive_folder (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  integration_id UUID NOT NULL,
  name TEXT NOT NULL,
  parent_folder_id UUID,
  drive_folder_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_drive_folder PRIMARY KEY (id),
  CONSTRAINT uk_drive_folder_external_id UNIQUE(external_id)
);

COMMENT ON TABLE drive_folder IS 'Pastas do Drive por integração e tenant.';
COMMENT ON COLUMN drive_folder.id IS 'Identificador interno.';
COMMENT ON COLUMN drive_folder.external_id IS 'UUID público.';
COMMENT ON COLUMN drive_folder.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN drive_folder.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN drive_folder.integration_id IS 'Integração (UUID externo).';
COMMENT ON COLUMN drive_folder.name IS 'Nome da pasta.';
COMMENT ON COLUMN drive_folder.parent_folder_id IS 'Pasta pai (UUID externo).';
COMMENT ON COLUMN drive_folder.drive_folder_id IS 'ID da pasta no Google Drive.';
COMMENT ON COLUMN drive_folder.created_at IS 'Data de criação.';
COMMENT ON COLUMN drive_folder.updated_at IS 'Última atualização.';
COMMENT ON COLUMN drive_folder.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_drive_folder ON drive_folder IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_drive_folder_external_id ON drive_folder IS 'UUID único.';

CREATE TABLE drive_file (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  integration_id UUID NOT NULL,
  folder_id UUID,
  file_name TEXT NOT NULL,
  mime_type TEXT,
  size_bytes BIGINT DEFAULT 0,
  drive_file_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_drive_file PRIMARY KEY (id),
  CONSTRAINT uk_drive_file_external_id UNIQUE(external_id)
);

COMMENT ON TABLE drive_file IS 'Arquivos do Drive por tenant e conta.';
COMMENT ON COLUMN drive_file.id IS 'Identificador interno.';
COMMENT ON COLUMN drive_file.external_id IS 'UUID público.';
COMMENT ON COLUMN drive_file.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN drive_file.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN drive_file.integration_id IS 'Integração (UUID externo).';
COMMENT ON COLUMN drive_file.folder_id IS 'Pasta (UUID externo).';
COMMENT ON COLUMN drive_file.file_name IS 'Nome do arquivo.';
COMMENT ON COLUMN drive_file.mime_type IS 'Tipo MIME.';
COMMENT ON COLUMN drive_file.size_bytes IS 'Tamanho em bytes.';
COMMENT ON COLUMN drive_file.drive_file_id IS 'ID do arquivo no Google Drive.';
COMMENT ON COLUMN drive_file.created_at IS 'Data de criação.';
COMMENT ON COLUMN drive_file.updated_at IS 'Última atualização.';
COMMENT ON COLUMN drive_file.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_drive_file ON drive_file IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_drive_file_external_id ON drive_file IS 'UUID único.';
