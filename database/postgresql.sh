#!/bin/bash
# https://hub.docker.com/_/postgres
# https://www.vaultproject.io/docs/secrets/databases/postgresql 
sudo docker stop postgres
sudo docker rm postgres
yes | sudo docker system prune -a
yes | sudo docker system prune --volumes
sudo docker run --name postgres -e POSTGRES_USER=root \
         -e POSTGRES_PASSWORD=rootpassword \
         -d -p 5432:5432 postgres
sleep 15;

// Vagrant install as a dependency
bash /vagrant/hashicorp/vault.sh

echo -e '\e[38;5;198m'"++++ Show users in database"
sudo docker exec postgres psql -U root -c '\du'
echo -e '\e[38;5;198m'"++++ Enable Vault Database PostgreSQL secret engine"
vault secrets enable database
echo -e '\e[38;5;198m'"++++ Configure PostgreSQL "
vault write database/config/postgresql \
    plugin_name=postgresql-database-plugin \
    allowed_roles=postgresql-role \
    connection_url='postgresql://root:rootpassword@localhost:5432/postgres?sslmode=disable'   
echo -e '\e[38;5;198m'"++++ Create a role"
vault write database/roles/postgresql-role db_name=postgresql \
        creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
                             GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
        default_ttl=1h max_ttl=24h     
echo -e '\e[38;5;198m'"++++ Create policy"
vault policy write apps  -<<EOF
# Get credentials from the database secrets engine
path "database/creds/postgresql-role" {
  capabilities = [ "read" ]
}
EOF
echo -e '\e[38;5;198m'"++++ Create new token"
# Create a new token with apps policy attached
# vault token create -policy="apps"
VAULT_TOKEN_APPS=$(vault token create -policy="apps" -field token)
echo -e '\e[38;5;198m'"++++ New Token: $VAULT_TOKEN_APPS"
echo -e '\e[38;5;198m'"++++ Create new connection with token"
VAULT_TOKEN=$VAULT_TOKEN_APPS vault read database/creds/postgresql-role
echo -e '\e[38;5;198m'"++++ Now show users in database again with new user created"
sudo docker exec postgres psql -U root -c '\du'
