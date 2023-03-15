#!/bin/bash
# https://hub.docker.com/_/microsoft-mssql-server
# https://www.vaultproject.io/docs/secrets/databases/mssql.html
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Cleanup"
echo -e '\e[38;5;198m'"++++ "
sudo docker stop mssql
sudo docker rm mssql
yes | sudo docker system prune -a
yes | sudo docker system prune --volumes
if pgrep -x "vault" >/dev/null
then
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Vault is running"
  echo -e '\e[38;5;198m'"++++ "
else
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Ensure Vault is running.."
  echo -e '\e[38;5;198m'"++++ "
  sudo bash /vagrant/hashicorp/vault.sh
fi
export VAULT_ADDR=http://127.0.0.1:8200
vault status

# yes | sudo docker system prune -a
# yes | sudo docker system prune --volumes
sudo docker run \
  --name mssql \
  -e ACCEPT_EULA=Y -e SA_PASSWORD=P@ssw0rd -e MSSQL_PID=Express \
  -p 1433:1433 \
  -d mcr.microsoft.com/mssql/server:2017-CU8-ubuntu
echo -e '\e[38;5;198m'"++++ Instructions"
echo -e '\e[38;5;198m'"++++ vagrant ssh"
echo -e '\e[38;5;198m'"++++ docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd -Q \"CREATE DATABASE mssql\""
echo -e '\e[38;5;198m'"++++ docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd -Q \"SELECT name, database_id, create_date FROM sys.databases\""
echo -e '\e[38;5;198m'"++++ vault secrets enable database"
echo -e '\e[38;5;198m'"++++ vault write database/config/mssql \ \n  plugin_name=mssql-database-plugin \ \n  connection_url='sqlserver://{{username}}:{{password}}@localhost:1433' \ \n  allowed_roles=\"mssql\" \ \n  username=\"sa\" \ \n  password=\"P@ssw0rd\""
echo -e '\e[38;5;198m'"++++ docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@ssw0rd -Q \"SELECT * FROM sysusers\""
echo -e '\e[38;5;198m'"++++ vault write database/roles/mssql \ \n  db_name=mssql \ \n  creation_statements=\"CREATE LOGIN [{{name}}] WITH PASSWORD = '{{password}}'; \ \n  CREATE USER [{{name}}] FOR LOGIN [{{name}}]; \ \n  GRANT SELECT ON SCHEMA::dbo TO [{{name}}];\" \ \n  default_ttl=\"1h\" \ \n  max_ttl=\"24h\""
echo -e '\e[38;5;198m'"++++ vault read database/creds/mssql"
# TODO: above it not working as expected, I am getting errors
#  - * 1 error occurred:
# 	 * "my-role" is not an allowed role
#  - * 1 error occurred:
# 	 * mssql: Incorrect syntax near 'A1a'.
