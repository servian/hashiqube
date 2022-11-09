#!/bin/bash
# https://kubernetes.io/docs/tasks/tools/install-minikube/
# https://medium.com/@wisegain/minikube-cheat-sheet-a273385e66c9
# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
# https://minikube.sigs.k8s.io/docs/handbook/persistent_volumes/

function minikube-install() {
  # Determine CPU Architecture
  arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
  if [[ $arch == x86_64* ]]; then
    ARCH="amd64"
    HELLO_MINIKUBE_IMAGE="k8s.gcr.io/echoserver:1.4"
  elif  [[ $arch == aarch64 ]]; then
    ARCH="arm64"
    # https://github.com/kubernetes/minikube/issues/11107
    HELLO_MINIKUBE_IMAGE="preslavmihaylov/kubehelloworld:latest"
  fi
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ CPU is $ARCH"
  echo -e '\e[38;5;198m'"++++ "
  
  if [ -f /usr/local/bin/minikube ]; then
    echo -e '\e[38;5;198m'"++++ "
    echo -e '\e[38;5;198m'"++++ Minikube found at /usr/local/bin/minikube"
    echo -e '\e[38;5;198m'"++++ "
  else
    curl -sLo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-$ARCH
    sudo chmod +x minikube
    sudo mkdir -p /usr/local/bin/
    sudo install minikube /usr/local/bin/
  fi

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Delete Minikube"
  echo -e '\e[38;5;198m'"++++ "
  for mkd in $(ps aux | grep -e dashboard -e kubectl | grep -v grep | grep -v nomad | tr -s " " | cut -d " " -f2); do bash -c "sudo kill -9 $mkd || true"; done
  sleep 10;
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Check minikube proccesses"
  echo -e '\e[38;5;198m'"++++ "
  bash -c "ps aux | grep -e dashboard -e kubectl || true"
  sleep 5;

  sudo --preserve-env=PATH -u vagrant minikube delete --all --purge
  sleep 30;
  sudo rm -rf /home/vagrant/.kube
  sudo rm -rf /home/vagrant/.minikube
  # BUG: https://github.com/kubernetes/minikube/issues/7511 - gave me lots of issues
  sudo rm -rf /var/lib/docker/volumes/minikube
  # sudo --preserve-env=PATH -u vagrant mkdir /home/vagrant/.kube
  # sudo chmod -R 777 /home/vagrant/.kube

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ docker system prune -a"
  echo -e '\e[38;5;198m'"++++ "
  yes | sudo docker system prune -a
  yes | sudo docker system prune --volumes
  sudo docker volume prune -f

  # BUG: https://github.com/kubernetes/minikube/issues/7179
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Installing Contrack"
  echo -e '\e[38;5;198m'"++++ "
  sudo apt-get install --assume-yes conntrack ethtool socat

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Launching Minikube"
  echo -e '\e[38;5;198m'"++++ "
  # https://minikube.sigs.k8s.io/docs/commands/start/
  # https://unofficial-kubernetes.readthedocs.io/en/latest/admin/admission-controllers/
  # https://github.com/kubernetes/minikube/issues/604
  sudo --preserve-env=PATH -u vagrant CHANGE_MINIKUBE_NONE_USER=true minikube start --driver=docker --force-systemd=true --insecure-registry="10.9.99.0/24" --cpus=4 --memory=$(expr $(free -m | tr -s " " | grep Mem | cut -d " " -f2) - 2048) --disk-size=2g --mount-string="/vagrant:/vagrant" --mount --extra-config=apiserver.enable-admission-plugins="DefaultStorageClass"
  # --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
  # "ResourceQuota,ServiceAccount,MutatingAdmissionWebhook,LimitRanger,NamespaceExists,NamespaceLifecycle," --kubelet.node-ip=10.9.99.10 --apiserver-name=0.0.0.0 --apiserver-ips=0.0.0.0

  sudo --preserve-env=PATH -u vagrant curl -sLO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/$ARCH/kubectl
  sudo --preserve-env=PATH -u vagrant chmod +x kubectl
  sudo install kubectl /usr/local/bin/

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Installing k8s CLI"
  echo -e '\e[38;5;198m'"++++ "
  sudo curl -sS https://webinstall.dev/k9s | bash
  
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Initially, some services such as the storage-provisioner, may not yet be in a Running state. This is a normal condition during cluster bring-up, and will resolve itself momentarily. For additional insight into your cluster state, minikube bundles the Kubernetes Dashboard, allowing you to get easily acclimated to your new environment:\nSleep 30s.."
  echo -e '\e[38;5;198m'"++++ "
  sleep 30;
  
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Get minikube IP"
  echo -e '\e[38;5;198m'"++++ "
  MINIKUBE_IP=$(sudo --preserve-env=PATH -u vagrant minikube ip)
  sudo --preserve-env=PATH -u vagrant minikube ip

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Enable Minikube Ingress Addon"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant minikube addons enable ingress

  # Docker Registry via Minikube
  # https://minikube.sigs.k8s.io/docs/handbook/registry/
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Enable Minikube Docker Registry Addon"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant minikube addons enable registry
  sleep 30;

  attempts=0
  max_attempts=15
  while ! ( sudo netstat -nlp | grep 5001 ) && (( $attempts < $max_attempts )); do
    attempts=$((attempts+1))
    sleep 10;
    echo -e '\e[38;5;198m'"++++ "
    echo -e '\e[38;5;198m'"++++ kubectl port-forward -n kube-system service/registry 5001:80 --address=\"0.0.0.0\", (${attempts}/${max_attempts}) sleep 10s"
    echo -e '\e[38;5;198m'"++++ "
    sudo --preserve-env=PATH -u vagrant kubectl port-forward -n kube-system service/registry 5001:80 --address="0.0.0.0" > /dev/null 2>&1 &
  done

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Enable Minikube Default Storage Class Addon"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant minikube addons enable default-storageclass

  # https://minikube.sigs.k8s.io/docs/commands/dashboard/
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Starting Minikube dashboard"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant nohup minikube dashboard --url &
  sleep 30;

  # via port-forward
  attempts=0
  max_attempts=15
  while ! ( sudo netstat -nlp | grep 10888 ) && (( $attempts < $max_attempts )); do
    attempts=$((attempts+1))
    sleep 10;
    echo -e '\e[38;5;198m'"++++ "
    echo -e '\e[38;5;198m'"++++ kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 10888:80 --address=\"0.0.0.0\", (${attempts}/${max_attempts}) sleep 10s"
    echo -e '\e[38;5;198m'"++++ "
    sudo --preserve-env=PATH -u vagrant kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 10888:80 --address="0.0.0.0" > /dev/null 2>&1 &
  done

  # via kube proxy
  #sudo --preserve-env=PATH -u vagrant nohup kubectl proxy --address="0.0.0.0" -p 10888 --disable-filter=true --accept-hosts='^*$' &
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Tada! Minikube Dashboard is now available at http://localhost:10888"
  echo -e '\e[38;5;198m'"++++ "
  sleep 10;

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ sudo minikube status"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant minikube status

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ sudo minikube service list"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant minikube service list

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ sudo kubectl get nodes"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl get nodes

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Interact with Minikube"
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ vagrant kubectl get po -A"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl get po -A

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ minikube kubectl -- get po -A"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant minikube kubectl -- get po -A

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Start Minikube Tunnel"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant minikube tunnel > /dev/null 2>&1 &

  # https://kubernetes.io/docs/tutorials/hello-minikube/
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Deploy hello-minikube application"
  echo -e '\e[38;5;198m'"++++ Create a sample deployment and expose it on port 3000:"
  echo -e '\e[38;5;198m'"++++ kubectl create deployment hello-minikube --image=$HELLO_MINIKUBE_IMAGE"
  echo -e '\e[38;5;198m'"++++ kubectl expose deployment hello-minikube --type=NodePort --port=3000"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl create deployment hello-minikube --image=$HELLO_MINIKUBE_IMAGE
  sudo --preserve-env=PATH -u vagrant kubectl expose deployment hello-minikube --type=NodePort --port=3000
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ It may take a moment, but your deployment will soon show up when you run:"
  echo -e '\e[38;5;198m'"++++ kubectl get services hello-minikube"
  echo -e '\e[38;5;198m'"++++ "
  sleep 15;
  sudo --preserve-env=PATH -u vagrant kubectl get services hello-minikube
  
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ The easiest way to access this service is to let kubectl to forward the port:"
  echo -e '\e[38;5;198m'"++++ kubectl port-forward service/hello-minikube 18888:3000"
  echo -e '\e[38;5;198m'"++++ "
  sleep 25;

  attempts=0
  max_attempts=15
  while ! ( sudo netstat -nlp | grep 18888 ) && (( $attempts < $max_attempts )); do
    attempts=$((attempts+1))
    sleep 10;
    echo -e '\e[38;5;198m'"++++ "
    echo -e '\e[38;5;198m'"++++ kubectl port-forward -n default service/hello-minikube 18888:3000 --address=\"0.0.0.0\", (${attempts}/${max_attempts}) sleep 10s"
    echo -e '\e[38;5;198m'"++++ "
    sudo --preserve-env=PATH -u vagrant kubectl port-forward -n default service/hello-minikube 18888:3000 --address="0.0.0.0" > /dev/null 2>&1 &
  done
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Tada! Your application is now available at http://localhost:18888/"
  echo -e '\e[38;5;198m'"++++ Browse the catalog of easily installed Kubernetes services:"
  echo -e '\e[38;5;198m'"++++ minikube addons list"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant minikube addons list

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Get all Pods and Services"
  echo -e '\e[38;5;198m'"++++ kubectl get pod,svc -A"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl get pod,svc -A

  # echo -e '\e[38;5;198m'"View Minikube Config"
  # echo -e '\e[38;5;198m'"kubectl config view"
  # sudo --preserve-env=PATH -u vagrant kubectl config view

  # TODO: uplift below, see issues in hashiqube
  # https://helm.sh/docs/intro/install/#from-script
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Helm not installed, installing.."
  echo -e '\e[38;5;198m'"++++ "
  cd /tmp
  sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  sudo chmod 700 get_helm.sh
  sudo /tmp/get_helm.sh
  cd ~/
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ helm version"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant helm version
  #https://helm.sh/docs/intro/quickstart/#initialize-a-helm-chart-repository
  echo -e '\e[38;5;198m'"++++ Helm add Bitnami repo"
  echo -e '\e[38;5;198m'"++++ helm repo add bitnami https://charts.bitnami.com/bitnami"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant helm repo add bitnami https://charts.bitnami.com/bitnami
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ helm repo update"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant helm repo update
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ helm search repo bitnami"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant helm search repo bitnami

  # https://doc.traefik.io/traefik/getting-started/install-traefik/
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Installing Traefik using Helm Chart"
  echo -e '\e[38;5;198m'"++++ helm repo add traefik https://helm.traefik.io/traefik"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant helm repo add traefik https://helm.traefik.io/traefik
  sudo --preserve-env=PATH -u vagrant helm repo update
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ helm install traefik traefik/traefik"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant helm install traefik traefik/traefik
  sleep 30;
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ kubectl port-forward 18181:9000"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 18181:9000 --address="0.0.0.0" > /dev/null 2>&1 &
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ kubectl port-forward 18080:9000"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 18080:9000 --address="0.0.0.0" > /dev/null 2>&1 &
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Get all Pods and Services"
  echo -e '\e[38;5;198m'"++++ kubectl get pod,svc -A"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl get pod,svc -A
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Docker stats"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant docker stats --no-stream -a

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Minikube Dashboard: http://localhost:10888"
  echo -e '\e[38;5;198m'"++++ Minikube Documentation: http://localhost:3333/#/minikube/README"
  echo -e '\e[38;5;198m'"++++ Hello Minikube application: http://localhost:18888"
  echo -e '\e[38;5;198m'"++++ Traefik Dashboard: http://localhost:18181/dashboard/"
  echo -e '\e[38;5;198m'"++++ Traefik Loadbalancer: http://localhost:18080"
  echo -e '\e[38;5;198m'"++++ Traefik Documentation: http://localhost:3333/#/minikube/README?id=traefik-on-minikube"
  echo -e '\e[38;5;198m'"++++ "
}

minikube-install
