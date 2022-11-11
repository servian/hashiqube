from airflow.decorators import dag
from datetime import datetime
from airflow.providers.ssh.operators.ssh import SSHOperator

@dag(
    dag_id="run-dbt",
    schedule_interval=None,     
    start_date=datetime(2022, 1, 1),
    catchup=False,
    )
def run_dbt():
    task_1=SSHOperator(
        task_id="dbt-debug",
        ssh_conn_id='HASHIQUBE',
        command='cd /vagrant/dbt/jaffle_shop; /home/vagrant/.local/bin/dbt debug;',
    )
    task_2=SSHOperator(
        task_id="dbt-seed",
        ssh_conn_id='HASHIQUBE',
        command='cd /vagrant/dbt/jaffle_shop; /home/vagrant/.local/bin/dbt seed;',
    )
    task_3=SSHOperator(
        task_id="dbt-run",
        ssh_conn_id='HASHIQUBE',
        command='cd /vagrant/dbt/jaffle_shop; /home/vagrant/.local/bin/dbt run;',
    )
    task_4=SSHOperator(
        task_id="dbt-test",
        ssh_conn_id='HASHIQUBE',
        command='cd /vagrant/dbt/jaffle_shop; /home/vagrant/.local/bin/dbt test;',
    )
    task_1 >> task_2 >> task_3 >> task_4

run_dbt_dag = run_dbt()
