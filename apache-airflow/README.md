# Apache Airflow
https://airflow.apache.org/

Airflow is a platform created by the community to programmatically author, schedule and monitor workflows


![Airflow](images/airflow-logo.png?raw=true "Airflow")

## Provision

In order to provision apache airflow you need bastetools, docker, minikube as dependencies. 

```bash
vagrant up --provision-with basetools,docker,minikube,postgresql,dbt,apache-airflow
```

## Web UI Access

To access the web UI visit http://localhost:18889. 
Default login is:
```
Username: admin
Password: admin
```

# Further Info
Airflow is deployed on Minikube (Kubernetes) using Helm, and additional values are supplied in the values.yaml file.

Example DAGs are supplied in the dags folder and they are mounted into the airflow scheduler pod, see the details in the values.yaml file
 
# Airflow Information
In the dags folder you will find 2 dags
- example-dag.py
- test-ssh.py

The `example-dag.py` runs dbt commands by using the SSHOperator and ssh'ing into Hashiqube. 
The `test-ssh.py` just ssh into hashiqube to test the connection

# Airflow DAGs
![Airflow](images/airflow_dags.png?raw=true "Airflow")

# Airflow Connections
![Airflow](images/airflow_connections.png?raw=true "Airflow")

# Airflow DAG run
![Airflow](images/airflow_dag_run_dbt.png?raw=true "Airflow")

# Airflow Task Instance
![Airflow](images/airflow_task_instance.png?raw=true "Airflow")

# Airflow Task Instance Result
![Airflow](images/airflow_task_result.png?raw=true "Airflow")

# Links and further reading
- https://artifacthub.io/packages/helm/airflow-helm/airflow/8.3.1
- https://airflow.apache.org/docs/helm-chart/stable/index.html
- https://airflow.apache.org/docs/helm-chart/stable/adding-connections-and-variables.html
- https://airflow.readthedocs.io/_/downloads/en/1.10.2/pdf/
- https://airflow.apache.org/docs/helm-chart/stable/parameters-ref.html