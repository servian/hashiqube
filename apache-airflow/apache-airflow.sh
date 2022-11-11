#!/bin/bash

# https://airflow.apache.org/docs/apache-airflow/stable/installation/index.html
# https://airflow.apache.org/docs/helm-chart/stable/index.html
# https://github.com/apache/airflow/tree/main/chart
# https://github.com/apache/airflow/blob/main/chart/values.yaml
# https://github.com/airflow-helm/charts/blob/main/charts/airflow/docs/guides/quickstart.md
# https://airflow.apache.org/docs/helm-chart/stable/adding-connections-and-variables.html
# https://airflow.readthedocs.io/_/downloads/en/1.10.2/pdf/
# https://airflow.apache.org/docs/helm-chart/stable/parameters-ref.html
# https://artifacthub.io/packages/helm/airflow-helm/airflow/

cd ~/
# Determine CPU Architecture
arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
if [[ $arch == x86_64* ]]; then
  ARCH="amd64"
elif [[ $arch == aarch64 ]]; then
  ARCH="arm64"
fi
echo -e '\e[38;5;198m'"CPU is $ARCH"

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Cleanup"
echo -e '\e[38;5;198m'"++++ "
for i in $(ps aux | grep kubectl | grep -ve sudo -ve grep -ve bin | grep -e airflow | tr -s " " | cut -d " " -f2); do kill -9 $i; done
sudo --preserve-env=PATH -u vagrant helm delete airflow --namespace airflow
sudo --preserve-env=PATH -u vagrant kubectl delete -f /vagrant/apache-airflow/airflow-dag-pvc.yaml
sudo --preserve-env=PATH -u vagrant kubectl delete namespace airflow

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create Namespace airflow for Airflow"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant kubectl create namespace airflow

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create PVC for Airflow DAGs in /vagrant/apache-airflow/dags"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant kubectl apply -f /vagrant/apache-airflow/airflow-dag-pvc.yaml

# Install with helm
# https://airflow.apache.org/docs/helm-chart/stable/index.html
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Installing Apache Airflow using Helm Chart in namespace airflow"
echo -e '\e[38;5;198m'"++++ "

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ helm repo add apache-airflow https://airflow.apache.org"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant helm repo add apache-airflow https://airflow.apache.org
sudo --preserve-env=PATH -u vagrant helm repo update

# https://github.com/airflow-helm/charts/blob/main/charts/airflow/docs/guides/quickstart.md
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ helm install airflow apache-airflow/airflow"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant helm upgrade --install airflow apache-airflow/airflow --namespace airflow --create-namespace \
  --values /vagrant/apache-airflow/values.yaml \
  --set dags.persistence.enabled=true \
  --set dags.persistence.existingClaim=airflow-dags \
  --set dags.gitSync.enabled=false

attempts=0
max_attempts=15
while ! ( sudo --preserve-env=PATH -u vagrant kubectl get pods --namespace airflow | grep web | tr -s " " | cut -d " " -f3 | grep Running ) && (( $attempts < $max_attempts )); do
  attempts=$((attempts+1))
  sleep 60;
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Waiting for Apache Airflow to become available, (${attempts}/${max_attempts}) sleep 60s"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl get po --namespace airflow
  sudo --preserve-env=PATH -u vagrant kubectl get events | grep -e Memory -e OOM
done

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ kubectl port-forward 18889:8080"
echo -e '\e[38;5;198m'"++++ "
attempts=0
max_attempts=15
while ! ( sudo netstat -nlp | grep 18889 ) && (( $attempts < $max_attempts )); do
  attempts=$((attempts+1))
  sleep 60;
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ kubectl port-forward service/airflow-webserver 18889:8080 --namespace airflow --address=\"0.0.0.0\", (${attempts}/${max_attempts}) sleep 60s"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl port-forward service/airflow-webserver 18889:8080 --namespace airflow --address="0.0.0.0" > /dev/null 2>&1 &
done

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Add SSH Connection for Hashiqube"
echo -e '\e[38;5;198m'"++++ "
kubectl exec airflow-worker-0 -n airflow -- /bin/bash -c '/home/airflow/.local/bin/airflow connections add HASHIQUBE --conn-description "hashiqube ssh connection" --conn-host "10.9.99.10" --conn-login "vagrant" --conn-password "vagrant" --conn-port "22" --conn-type "ssh"'

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Docker stats"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant docker stats --no-stream -a

echo -e '\e[38;5;198m'"++++ Apache Airflow Web UI: http://localhost:18889"
echo -e '\e[38;5;198m'"++++ Username: admin; Password: admin"