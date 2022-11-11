#!/bin/bash
set -e

# Common arguments and functions.
source /vagrant/dbt/common.sh

############################
# installs the odbc drivers required and 
# sets the pip versions for MSSQL 
install-dbt-mssql () {

  echo "Installing dbt core.  Version: ${dbt_sqlserver}"
  python -m pip install --no-cache "git+https://github.com/dbt-labs/dbt-core@v${dbt_sqlserver}#egg=dbt-postgres&subdirectory=plugins/postgres"

  # Install ODBC headers for MSSQL support
  if ! [[ "18.04 20.04 22.04" == *"$(lsb_release -rs)"* ]];
  then
      echo "Ubuntu $(lsb_release -rs) is not currently supported.";
      exit;
  fi

  # sudo su
  sudo /bin/bash -c 'curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -'

  sudo /bin/bash -c 'curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list'

  # exit
  sudo apt-get update
  sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18 postgresql-client
  # optional: for bcp and sqlcmd
  sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18 postgresql-client
  echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
  source ~/.bashrc
  # optional: for unixODBC development headers
  sudo apt-get install -y unixodbc-dev postgresql-client

  pip install -U dbt-sqlserver==$dbt_sqlserver
  pip install -U dbt-synapse==$dbt_synapse

}

#####################################3
#####################################3
# Install DBT with some non MSSQL adapters
function install-dbt () {

  echo -e '\e[38;5;198m'"++++ installing postgres adapter"
  python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_postgres_ref}#egg=dbt-postgres&subdirectory=plugins/postgres"
}

#####################################3
function install-dbt-redshift () {
  echo -e '\e[38;5;198m'"++++ installing redshift adapater"
  python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_redshift_ref}#egg=dbt-redshift"
}

#####################################3
function install-dbt-bigquery () {
  echo -e '\e[38;5;198m'"++++ installing bigquery adapater"
  python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_bigquery_ref}#egg=dbt-bigquery"
}

#####################################3
function install-dbt-snowflake () {
  echo -e '\e[38;5;198m'"++++ installing snowflake adapater"
  python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_snowflake_ref}#egg=dbt-snowflake"
}

#####################################3
function install-dbt-spark () {
  echo -e '\e[38;5;198m'"++++ installing spark adapter"
  python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_spark_ref}#egg=dbt-spark[${dbt_spark_version}]"
}

#####################################3
function install-dbt-databricks () {
  echo -e '\e[38;5;198m'"++++ installing databricks adapter"
  python -m pip install --no-cache "dbt_databricks==${dbt_databricks}"
}

############################
# Add vagrant .local folder to path if missing
if [[ ":$PATH:" == *":/home/vagrant/.local/bin:"* ]]; then
  echo "PATH is correctly set"
else
  echo "PATH is missing /home/vagrant/.local/bin, adding into PATH"
  export PATH="$PATH:/home/vagrant/.local/bin"
fi

############################
# Python stuff
python --version
# Ensure pip is upgraded and Print pip version 
python -m pip install --upgrade pip
pip --version

# Cleanup any existing dbt packages.
[ $(pip list | grep dbt | wc -l) -gt 0 ] && pip list | grep dbt | xargs pip uninstall -y

echo $DBT_WITH
DBT_WITH="${DBT_WITH:=postgres}"; echo $DBT_WITH

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ The chosen dbt adapter is ${DBT_WITH}"
echo -e '\e[38;5;198m'"++++ "

case $DBT_WITH in

  postgres)
  install-dbt
  ;;
  
  redshift)
  install-dbt-redshift
  ;;

  bigquery)
  install-dbt-bigquery
  ;;

  snowflake)
  install-dbt-snowflake
  ;;

  spark)
  install-dbt-spark
  ;;

  mssql)
  install-dbt-mssql
  ;;

  databricks)
  install-dbt-databricks
  ;;

  all)
  install-dbt
  install-dbt-redshift
  install-dbt-bigquery
  install-dbt-snowflake
  install-dbt-spark
  install-dbt-snowflake
  install-dbt-databricks
  ;;

  #default to postgres
  *)
  install-dbt
  ;;
esac

dbt --version

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ dbt-core is ready with adapter ${DBT_WITH}. Installed at $(which dbt) which is now in your PATH, type 'dbt' to get started"
echo -e '\e[38;5;198m'"++++ "

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Now let's use a practical example from DBT Labs - https://github.com/dbt-labs/jaffle_shop"
echo -e '\e[38;5;198m'"++++ "

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Ensure postgresql-client is installed"
echo -e '\e[38;5;198m'"++++ "
sudo apt-get install -y postgresql-client libpq-dev python3.9-dev
python3.9 -m pip install --force-reinstall psycopg2==2.9.4

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create database jaffle_shop"
echo -e '\e[38;5;198m'"++++ "
PGPASSWORD=rootpassword psql --username=root --host=localhost --port=5432 -c 'create database jaffle_shop' || true

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Cloning https://github.com/dbt-labs/jaffle_shop into /vagrant/dbt/jaffle_shop"
echo -e '\e[38;5;198m'"++++ "

rm -rf /vagrant/dbt/jaffle_shop
git clone https://github.com/dbt-labs/jaffle_shop.git /vagrant/dbt/jaffle_shop

cd /vagrant/dbt

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ dbt init jaffle_shop"
echo -e '\e[38;5;198m'"++++ "
dbt init jaffle_shop

cd jaffle_shop

# https://docs.getdbt.com/dbt-cli/configure-your-profile#connecting-to-your-warehouse-using-the-command-line

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ creating /vagrant/dbt/jaffle_shop/profiles.yml for user $(whoami)"
echo -e '\e[38;5;198m'"++++ "

cat <<EOF | tee /home/vagrant/.dbt/profiles.yml
# example profiles.yml file
# credentials comes from database/postgresql.sh
jaffle_shop:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: root
      password: rootpassword
      port: 5432
      dbname: jaffle_shop
      schema: dbt_alice
      threads: 4
EOF

cat /home/vagrant/.dbt/profiles.yml

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ dbt debug"
echo -e '\e[38;5;198m'"++++ "
dbt debug

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ dbt seed"
echo -e '\e[38;5;198m'"++++ "
dbt seed

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ dbt run"
echo -e '\e[38;5;198m'"++++ "
dbt run

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ dbt test"
echo -e '\e[38;5;198m'"++++ "
dbt test

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ dbt docs generate"
echo -e '\e[38;5;198m'"++++ "
dbt docs generate

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ dbt docs serve"
echo -e '\e[38;5;198m'"++++ "
if pgrep -x "dbt" >/dev/null
then
  sudo kill -9 $(pgrep dbt)
fi
nohup dbt docs serve --port 28080 > /vagrant/dbt/jaffle_shop/logs/dbt-docs-serve.log 2>&1 &
sh -c 'sudo tail -f /vagrant/dbt/jaffle_shop/logs/dbt-docs-serve.log | { sed "/Press Ctrl+C to exit/ q" && kill $$ ;}' || true

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ You can now access the DBT Doc Server at http://localhost:28080/#!/overview"
echo -e '\e[38;5;198m'"++++ Documentation can be found at http://localhost:3333/#/dbt/README"
echo -e '\e[38;5;198m'"++++ "