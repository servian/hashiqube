# DBT

[data build tool](https://www.getdbt.com/)

dbt is a data transformation tool that enables data analysts and engineers to transform, test and document data in the cloud data warehouse.

![alt](https://www.getdbt.com/ui/img/png/analytics-engineering-dbt.png)

## Getting Started

Review the dbt and adapter versions located in [common.sh](./common.sh)

To control which adapter and version you would like to install with dbt, change the variable `DBT_WITH` to an accepted value

```sh
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
```

Next lets provision Hashiqube with basetools and dbt:

```sh
vagrant up --provision-with basetools,docsify,docker,postgresql,dbt
```

## Next steps with practicle example from DBT Labs 
https://github.com/dbt-labs/jaffle_shop#running-this-project

1. Run `vagrant up --provision-with basetools,docsify,docker,postgresql,dbt`

2. We have already cloned https://github.com/dbt-labs/jaffle_shop into `/vagrant/dbt/jaffle_shop`
and we will be following the tutorial at https://github.com/dbt-labs/jaffle_shop#running-this-project

3. See the output and now try to follow the tutorial at https://github.com/dbt-labs/jaffle_shop

4. Enter Hashiqube ssh session using `vagrant ssh` this project can be found in `/vagrant/dbt`

## Next steps if you have your own project

1. Enter Hashiqube ssh session using `vagrant ssh`

2. If you have an existing dbt project under your home directory, you can navigate to your dbt project via the `/osdata` volume which is mapped to your home directory.

3. Update your `profile.yml` with the correct credentials of your target database. Use `dbt debug` to test connection.

4. `dbt run` and be awesome.

<br>

# Supported databases

## MSSQL and Synapse

These adapters require a previous version of dbt (not latest).

`dbt --version` will output:

```
Core:
  - installed: 1.1.0
  - latest:    1.2.1 - Update available!

  Your version of dbt-core is out of date!
  You can find instructions for upgrading here:
  https://docs.getdbt.com/docs/installation

Plugins:
  - postgres:  1.1.0 - Update available!
  - synapse:   1.1.0 - Up to date!
  - sqlserver: 1.1.0 - Up to date!
```

Example 2 with other adapters:

```
Core:
  - installed: 1.2.1
  - latest:    1.2.1 - Up to date!

Plugins:
  - spark:     1.2.0 - Up to date!
  - postgres:  1.2.1 - Up to date!
  - snowflake: 1.2.0 - Up to date!
  - redshift:  1.2.1 - Up to date!
  - bigquery:  1.2.0 - Up to date!
```

# DBT Jaffle-Shop
For a practical example we are going to use https://github.com/dbt-labs/jaffle_shop 

Jaffle shop will automatically cloned down, and instantiated. It will seed to the PosgreSQL database which we provisioned with `postgresql` in the command `vagrant up --provision-with basetools,docsify,docker,postgresql,dbt`

# DBT Serv Web Interface
Once the provisioner is done you will be able to access the DBT Web interface at http://localhost:28080/

# DBT Project
![DBT](images/dbt_project.png?raw=true "DBT")

# DBT Database
![DBT](images/dbt_database.png?raw=true "DBT")

# DBT Lineage Graph
![DBT](images/dbt_lineage_graph.png?raw=true "DBT")

# Tips
When the dbt project grows, DBT RUN and DBT TEST become expensive. An alternative to reduce the cost of running the project is to have the content of the folder .dbt/targeton persistent storage to reuse later

Use DBT RUN and DBT TEST with deferring parameters: $ dbt run --select [...] --defer --state path/to/artifacts and

`dbt test --select [...] --defer --state path/to/artifacts`

In this way, if we have already run the model, the next RUN and TEST will execute exclusively what is new on the code and reuse what has been run previously.

This would open space as well to implement cool stuff, such as running the model over a pull request. 
