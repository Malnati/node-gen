# /gen.sh
echo ""
echo "Deve gerar o projeto $1"
echo "Deve conectar ao banco de dados $2"
echo "Deve copiar os arquivos para $4"
echo ""

# remove os arquivos antigos gerados pelo comando anterior
# rm -rf $4

# copia apenas od diretorios do static para o diretorio de destino
# rsync -av --include '*/' --exclude '*' ./static/. $4

# compila o projeto do gerador (gen/)
npm run build

if [ "${DB_TYPE}" = "sqlite" ]; then
  sqlite3 "$2" < test/db/database.sqlite.ddl
  sqlite3 "$2" < test/db/database.sqlite.sql
elif [ "${DB_TYPE}" = "mysql" ]; then
  mysql -u "$2" -p"$3" -e "CREATE DATABASE IF NOT EXISTS $2;"
  mysql -u "$2" -p"$3" "$2" < test/db/database.mysql.ddl
  mysql -u "$2" -p"$3" "$2" < test/db/database.mysql.sql
elif [ "${DB_TYPE}" = "sqlserver" ]; then
  sqlcmd -S "$4" -U "$2" -P "$3" -Q "IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'$2') CREATE DATABASE [$2]"
  sqlcmd -S "$4" -U "$2" -P "$3" -d "$2" -i test/db/database.mysql.ddl
  sqlcmd -S "$4" -U "$2" -P "$3" -d "$2" -i test/db/database.mysql.sql
fi

# executa o gerador de codigo (gen/)
(cd gen && npx ts-node src/main.ts \
                 --app "$1" \
                 --dbType "${DB_TYPE:-postgres}" \
                 --host "localhost" \
                 --port "5432" \
                 --database "$2" \
                 --user "$2" \
                 --password "$3" \
                 --outputDir "$4" \
                 --components "entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource, diagram")


# copia os arquivos estaticos para o diretorio de destino
# cp -r ./static/. $4


# compila o projeto gerado
# cd $4
# npm install
# npm run build
# cd ..
