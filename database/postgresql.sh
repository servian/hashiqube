#!/bin/bash
# https://hub.docker.com/_/postgres
# https://www.vaultproject.io/docs/secrets/databases/postgresql
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Cleanup"
echo -e '\e[38;5;198m'"++++ "
sudo docker stop postgres
sudo docker rm postgres
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

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Ensure postgres docker container is running"
echo -e '\e[38;5;198m'"++++ "
sudo docker run --name postgres -e POSTGRES_USER=root \
         -e POSTGRES_PASSWORD=rootpassword \
         -d -p 5432:5432 postgres

sleep 15;

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Ensure postgresql-client is installed"
echo -e '\e[38;5;198m'"++++ "
sudo apt-get install -y postgresql-client libpq-dev python3.9-dev

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Source /etc/environment"
echo -e '\e[38;5;198m'"++++ "
source /etc/environment

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Show users in database"
echo -e '\e[38;5;198m'"++++ "
sudo docker exec postgres psql -U root -c '\du'

sleep 15;

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Vault token lookup"
echo -e '\e[38;5;198m'"++++ "
vault token lookup

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Enable Vault Database PostgreSQL secret engine"
echo -e '\e[38;5;198m'"++++ "
vault secrets enable database

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Configure PostgreSQL "
echo -e '\e[38;5;198m'"++++ "
vault write database/config/postgresql \
    plugin_name=postgresql-database-plugin \
    allowed_roles=postgresql-role \
    connection_url='postgresql://root:rootpassword@localhost:5432/postgres?sslmode=disable'

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create a role"
echo -e '\e[38;5;198m'"++++ "
vault write database/roles/postgresql-role db_name=postgresql \
        creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
                             GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
        default_ttl=1h max_ttl=24h

echo -e '\e[38;5;198m'"++++ "  
echo -e '\e[38;5;198m'"++++ Create policy"
echo -e '\e[38;5;198m'"++++ "
vault policy write apps  -<<EOF
# Get credentials from the database secrets engine
path "database/creds/postgresql-role" {
  capabilities = [ "read" ]
}
EOF

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create a new token with apps policy attached"
echo -e '\e[38;5;198m'"++++ "
VAULT_TOKEN_APPS=$(vault token create -policy="apps" -field token)

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ New Token: $VAULT_TOKEN_APPS"
echo -e '\e[38;5;198m'"++++ "

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create new connection with token"
echo -e '\e[38;5;198m'"++++ "
VAULT_TOKEN=$VAULT_TOKEN_APPS vault read database/creds/postgresql-role

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Now show users in database again with new user created"
echo -e '\e[38;5;198m'"++++ "
sudo docker exec postgres psql -U root -c '\du'
