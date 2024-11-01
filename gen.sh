#!/bin/bash

# Função para exibir o exemplo de uso correto
show_example() {
  echo -e "\nExemplo de uso correto:"
  echo "bash $0 projeto_name 192.168.0.1 5432 database_name db_user password /caminho/para/destino"
  echo ""
}

# Função para listar os parâmetros fornecidos
list_provided_params() {
  echo -e "\nParâmetros fornecidos:"
  echo "1: Nome do projeto -> $1"
  echo "2: Host do banco de dados -> $2"
  echo "3: Porta do banco de dados -> $3"
  echo "4: Nome do banco de dados -> $4"
  echo "5: Usuário do banco de dados -> $5"
  echo "6: Senha do banco de dados -> $6"
  echo "7: Caminho de destino -> $7"
}

# Função para validar o IP
validate_ip() {
  local ip="$1"
  if [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Erro: O host do banco de dados (parâmetro 2) deve ser um IP válido no formato X.X.X.X."
    list_provided_params
    show_example
    exit 1
  fi
}

# Função para validar a porta (apenas números de 1 a 65535)
validate_port() {
  local port="$1"
  if [[ ! $port =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
    echo "Erro: A porta do banco de dados (parâmetro 3) deve ser um número entre 1 e 65535."
    list_provided_params
    show_example
    exit 1
  fi
}

# Função para validar o tamanho mínimo de senha
validate_password() {
  local password="$1"
  if [ ${#password} -lt 8 ]; then
    echo "Erro: A senha do banco de dados (parâmetro 6) deve ter pelo menos 8 caracteres."
    list_provided_params
    show_example
    exit 1
  fi
}

# Verificação dos parâmetros com mensagens de erro detalhadas
if [ -z "$1" ]; then
  echo "Erro: O nome do projeto (parâmetro 1) está ausente. Por favor, forneça o primeiro parâmetro com o nome do projeto."
  list_provided_params
  show_example
  exit 1
fi

if [ -z "$2" ]; then
  echo "Erro: O host do banco de dados (parâmetro 2) está ausente. Por favor, forneça o segundo parâmetro com o host do banco de dados."
  list_provided_params
  show_example
  exit 1
else
  validate_ip "$2"  # Validação de IP
fi

if [ -z "$3" ]; then
  echo "Erro: A porta do banco de dados (parâmetro 3) está ausente. Por favor, forneça o terceiro parâmetro com a porta do banco de dados."
  list_provided_params
  show_example
  exit 1
else
  validate_port "$3"  # Validação de porta
fi

if [ -z "$4" ]; then
  echo "Erro: O nome do banco de dados (parâmetro 4) está ausente. Por favor, forneça o quarto parâmetro com o nome do banco de dados."
  list_provided_params
  show_example
  exit 1
fi

if [ -z "$5" ]; then
  echo "Erro: O usuário do banco de dados (parâmetro 5) está ausente. Por favor, forneça o quinto parâmetro com o usuário do banco de dados."
  list_provided_params
  show_example
  exit 1
fi

if [ -z "$6" ]; then
  echo "Erro: A senha do banco de dados (parâmetro 6) está ausente. Por favor, forneça o sexto parâmetro com a senha do banco de dados."
  list_provided_params
  show_example
  exit 1
else
  validate_password "$6"  # Validação de senha
fi

if [ -z "$7" ]; then
  echo "Erro: O caminho de destino para os arquivos (parâmetro 7) está ausente. Por favor, forneça o sétimo parâmetro com o caminho de destino."
  list_provided_params
  show_example
  exit 1
elif [[ ! -d "$7" ]]; then
  echo "Erro: O caminho de destino $7 (parâmetro 7) não existe. Por favor, forneça um caminho válido."
  list_provided_params
  show_example
  exit 1
fi

# Mensagem de sucesso se todos os parâmetros forem válidos
echo ""
echo "Deve gerar o projeto $1"
echo "Deve conectar ao banco de dados (host) $2"
echo "Deve conectar ao banco de dados (port) $3"
echo "Deve conectar ao banco de dados (db) $4"
echo "Deve conectar ao banco de dados (user) $5"
echo "Deve conectar ao banco de dados (password) $6"
echo "Deve copiar os arquivos para $7"
echo ""

# remove os arquivos antigos gerados pelo comando anterior
rm -rf $7

# copia apenas od diretorios do static para o diretorio de destino
# rsync -av --include '*/' --exclude '*' ./static/. $4

# compila o projeto do gerador
npm run build

# executa o gerador de codigo
npx ts-node src/main.ts \
                --app $1 \
                --host $2 \
                --port $3 \
                --database $4 \
                --user $5 \
                --password $6 \
                --outputDir $7 \
                --components "entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource, diagram"


# copia os arquivos estaticos para o diretorio de destino
# cp -r ./static/. $4


# compila o projeto gerado
# cd $4
# npm install
# npm run build
# cd ..
