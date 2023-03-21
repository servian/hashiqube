# Defined common parameters for dbt-core in this file

########################################
# DEFINE WHICH ADAPTER TO USE
DBT_WITH=postgres

# AVAILABLE OPTIONS ARE:
# postgres
# redshift
# bigquery
# snowflake
# mssql
# ^^ with mssql being SQL Server and Synapase
# spark
# all 
# ^^ will install all adapters excluding mssql 
########################################

dbt_postgres_ref=dbt-core@v1.2.5 # postgres adapter is part of core now
dbt_redshift_ref=dbt-redshift@v1.2.1
dbt_bigquery_ref=dbt-bigquery@v1.2.0
dbt_snowflake_ref=dbt-snowflake@v1.2.0
dbt_spark_ref=dbt-spark@v1.2.0
dbt_databricks=1.2.1

######################################
# Are you targeting Synapse or MSSQL??
# dbt-core must be the same version as the adapter.
# Versions as per https://github.com/dbt-msft/dbt-sqlserver/

dbt_sqlserver=1.1.0
dbt_synapse=1.1.0
