#!/bin/bash
# https://hub.docker.com/_/mysql
# https://www.vaultproject.io/docs/secrets/mysql/index.html
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Cleanup"
echo -e '\e[38;5;198m'"++++ "
sudo docker stop mysql
sudo docker rm mysql
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
echo -e '\e[38;5;198m'"++++ Bring up a MySQL database on Docker"
echo -e '\e[38;5;198m'"++++ "
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install mysql-client
sudo docker run \
  --memory 512M \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=mysqldb \
  -p 3306:3306 \
  -d mysql:latest \
  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
sleep 60;
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Show databases"
echo -e '\e[38;5;198m'"++++ "
mysql -h 127.0.0.1 -u root -ppassword -e "show databases;"
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create Vault MySQL user"
echo -e '\e[38;5;198m'"++++ "
mysql -h 127.0.0.1 -u root -ppassword -e "CREATE USER 'vault'@'%' IDENTIFIED BY 'password';"
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Grant MySQL user \"vault\" acces"
echo -e '\e[38;5;198m'"++++ "
mysql -h 127.0.0.1 -u root -ppassword -e "GRANT ALL PRIVILEGES ON *.* TO 'vault'@'%' WITH GRANT OPTION;"
mysql -h 127.0.0.1 -u root -ppassword -e "GRANT CREATE USER ON *.* to 'vault'@'%';"
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Enable Vault secrets database engine"
echo -e '\e[38;5;198m'"++++ "
vault secrets enable database
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create Vault database mysqldb config"
echo -e '\e[38;5;198m'"++++ "
vault write database/config/mysqldb plugin_name=mysql-database-plugin connection_url='{{username}}:{{password}}@tcp(localhost:3306)/' allowed_roles='mysql-role' username='vault' password='password'
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create Vault role"
echo -e '\e[38;5;198m'"++++ "
vault write database/roles/mysql-role db_name=mysqldb creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL PRIVILEGES ON mysqldb.* TO '{{name}}'@'%';" default_ttl='5m' max_ttl='5m'
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Show MySQL users"
echo -e '\e[38;5;198m'"++++ "
mysql -h 127.0.0.1 -u root -ppassword -e "SELECT User, Host from mysql.user;"
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Ask Vault to create MySQL user with access"
echo -e '\e[38;5;198m'"++++ "
vault read database/creds/mysql-role
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Now show MySQL users again, with new Vault user created"
echo -e '\e[38;5;198m'"++++ "
mysql -h 127.0.0.1 -u root -ppassword -e "SELECT User, Host from mysql.user;"
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Instructions"
echo -e '\e[38;5;198m'"++++ mysql -h 127.0.0.1 -u root -ppassword"
echo -e '\e[38;5;198m'"++++ "
