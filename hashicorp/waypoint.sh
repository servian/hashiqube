#!/bin/bash

# BUG: https://github.com/kubernetes/minikube/issues/7511 - gave me lots of issues
# https://www.waypointproject.io/docs/server/install#nomad-platform
# https://www.waypointproject.io/docs/getting-started
# https://learn.hashicorp.com/tutorials/waypoint/get-started-nomad?in=waypoint/get-started-nomad

function waypoint-install() {
  arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
  if [[ $arch == x86_64* ]]; then
    ARCH="amd64"
  elif  [[ $arch == aarch64 ]]; then
    ARCH="arm64"
  fi
  echo -e '\e[38;5;198m'"CPU is $ARCH"

  sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
  yes | sudo docker system prune -a
  yes | sudo docker system prune --volumes

  echo -e '\e[38;5;198m'"Waypoint Install"
  # check if waypoint is installed, start and exit
  if [ -f /usr/local/bin/waypoint ]; then
    echo -e '\e[38;5;198m'"++++ Waypoint already installed at /usr/local/bin/waypoint"
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/waypoint version`"
  else
  # if waypoint is not installed, download and install
    echo -e '\e[38;5;198m'"++++ Waypoint not installed, installing.."
    LATEST_URL=$(curl -sL https://releases.hashicorp.com/waypoint/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep "linux.*$ARCH" | sort -V | tail -n 1)
    wget -q $LATEST_URL -O /tmp/waypoint.zip
    mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/waypoint.zip)
    echo -e '\e[38;5;198m'"++++ Installed `/usr/local/bin/waypoint version`"
  fi
}

function waypoint-kubernetes-minikube() {
  
  if pgrep -x "minikube" >/dev/null
  then
    echo "Minikube is running"
  else
    echo -e '\e[38;5;198m'"++++ Ensure Minikube is running"
    sudo bash /vagrant/minikube/minikube.sh
  fi

  echo -e '\e[38;5;198m'"++++ Waypoint Delete and Cleanup"
  # https://www.waypointproject.io/docs/troubleshooting#waypoint-server-in-kubernetes
  sudo --preserve-env=PATH -u vagrant kubectl config get-contexts
  sudo --preserve-env=PATH -u vagrant kubectl delete statefulset waypoint-server
  sudo --preserve-env=PATH -u vagrant kubectl delete pvc data-waypoint-server-0
  sudo --preserve-env=PATH -u vagrant kubectl delete svc waypoint
  sudo --preserve-env=PATH -u vagrant kubectl delete deployments waypoint-runner
  # sudo --preserve-env=PATH -u vagrant waypoint server uninstall
  sudo pkill $(sudo netstat -nlp | grep 19702 | tr -s " " | cut -d " " -f7 | cut -d "/" -f1)
  sudo pkill $(sudo netstat -nlp | grep 19701 | tr -s " " | cut -d " " -f7 | cut -d "/" -f1)
  sudo --preserve-env=PATH -u vagrant helm uninstall waypoint
  echo -e '\e[38;5;198m'"++++ Waypoint Context Clear"
  sudo --preserve-env=PATH -u vagrant waypoint context clear
  # sudo --preserve-env=PATH -u vagrant waypoint context delete minikube
  sudo --preserve-env=PATH -u vagrant waypoint context list

  # https://www.waypointproject.io/docs/troubleshooting#waypoint-server-in-kubernetes
  echo -e '\e[38;5;198m'"++++ Waypoint Install on Platform Kubernetes (Minikube)"
  # sudo --preserve-env=PATH -u vagrant waypoint install -platform=kubernetes -k8s-context=minikube -context-create=minikube -accept-tos # -k8s-storageclassname=standard -k8s-helm-version=v0.1.8
  # https://github.com/hashicorp/waypoint-helm
  # https://www.waypointproject.io/docs/kubernetes/install#installing-the-waypoint-server-with-helm
  sudo --preserve-env=PATH -u vagrant helm repo add hashicorp https://helm.releases.hashicorp.com
  sudo --preserve-env=PATH -u vagrant helm install waypoint hashicorp/waypoint --set server.resources.requests.memory=1024Mi --set server.resources.requests.cpu=750m --set runner.enabled=false
  sudo --preserve-env=PATH -u vagrant kubectl get all
  # eval $(sudo --preserve-env=PATH -u vagrant minikube docker-env)

  attempts=0
  max_attempts=15
  while ! ( sudo --preserve-env=PATH -u vagrant kubectl get po | grep waypoint-server | tr -s " " | cut -d " " -f3 | grep Running ) && (( $attempts < $max_attempts )); do
    attempts=$((attempts+1))
    sleep 60;
    echo -e '\e[38;5;198m'"++++ Waiting for Waypoint to become available, (${attempts}/${max_attempts}) sleep 60s"
    sudo --preserve-env=PATH -u vagrant kubectl get po
    sudo --preserve-env=PATH -u vagrant kubectl get events | grep -e Memory -e OOM
  done

  echo -e '\e[38;5;198m'"++++ Kubectl port-forward for Waypoint"
  attempts=0
  max_attempts=15
  while ! ( sudo netstat -nlp | grep 19701 ) && (( $attempts < $max_attempts )); do
    attempts=$((attempts+1))
    sleep 10;
    echo -e '\e[38;5;198m'"++++ kubectl port-forward -n default service/waypoint-server 19701:9701 --address=\"0.0.0.0\", (${attempts}/${max_attempts}) sleep 10s"
    sudo --preserve-env=PATH -u vagrant kubectl port-forward -n default service/waypoint-server 19701:9701 --address="0.0.0.0" > /dev/null 2>&1 &
  done

  attempts=0
  max_attempts=15
  while ! ( sudo netstat -nlp | grep 19702 ) && (( $attempts < $max_attempts )); do
    attempts=$((attempts+1))
    sleep 10;
    echo -e '\e[38;5;198m'"++++ kubectl port-forward -n default service/waypoint-server 19702:9702 --address=\"0.0.0.0\", (${attempts}/${max_attempts}) sleep 10s"
    sudo --preserve-env=PATH -u vagrant kubectl port-forward -n default service/waypoint-server 19702:9702 --address="0.0.0.0" > /dev/null 2>&1 &
  done
  
  echo -e '\e[38;5;198m'"++++ Waypoint Login from on Platform Kubernetes (Minikube)"
  sudo --preserve-env=PATH -u vagrant waypoint login -from-kubernetes -server-tls-skip-verify https://10.9.99.10:19701
  echo -e '\e[38;5;198m'"++++ Waypoint Context Rename"
  sudo --preserve-env=PATH -u vagrant waypoint context rename $(sudo --preserve-env=PATH -u vagrant waypoint context list | grep login | tr -s " " | cut -d " " -f3) minikube
  sudo --preserve-env=PATH -u vagrant waypoint context list
  sudo --preserve-env=PATH -u vagrant waypoint context verify minikube

  echo -e '\e[38;5;198m'"++++ Set Waypoint Context Kubernetes (Minikube)"
  # export WAYPOINT_TOKEN_MINIKUBE=$(sudo --preserve-env=PATH -u vagrant kubectl get secret waypoint-server-token -o jsonpath="{.data.token}" | base64 --decode)
  export WAYPOINT_TOKEN_MINIKUBE=$(sudo --preserve-env=PATH -u vagrant grep auth_token /home/vagrant/.config/waypoint/context/minikube.hcl | cut -d '"' -f2)
  echo -e '\e[38;5;198m'"++++ Waypoint Server https://localhost:19702 and enter the following Token displayed below"
  echo $WAYPOINT_TOKEN_MINIKUBE
  echo -e '\e[38;5;198m'"++++ Waypoint Context"
  sudo --preserve-env=PATH -u vagrant waypoint context list
  sudo --preserve-env=PATH -u vagrant waypoint context verify minikube
  echo -e '\e[38;5;198m'"++++ Waypoint Init and Up T-Rex Nodejs Example"
  echo -e '\e[38;5;198m'"++++ Found here /vagrant/hashicorp/waypoint/custom-examples/kubernetes-trex-nodejs"
  cd /vagrant/hashicorp/waypoint/custom-examples/kubernetes-trex-nodejs
  echo -e '\e[38;5;198m'"++++ Waypoint Config /vagrant/hashicorp/waypoint/custom-examples/kubernetes-trex-nodejs/waypoint.hcl"
  echo -e '\e[38;5;198m'"++++ Waypoint Init"
  sudo --preserve-env=PATH -u vagrant waypoint init
  echo -e '\e[38;5;198m'"++++ Waypoint Up"
  sudo --preserve-env=PATH -u vagrant waypoint up
  echo -e '\e[38;5;198m'"++++ Waypoint Deploy"
  sudo --preserve-env=PATH -u vagrant waypoint deploy
  echo -e '\e[38;5;198m'"++++ Waypoint Server https://localhost:19702 and enter the following Token displayed below"
  echo $WAYPOINT_TOKEN_MINIKUBE
}

function waypoint-nomad() {
  if pgrep -x "nomad" >/dev/null
  then
    echo "Nomad is running"
  else
    echo -e '\e[38;5;198m'"++++ Ensure Nomad is running"
    sudo bash /vagrant/hashicorp/nomad.sh
  fi

  echo -e '\e[38;5;198m'"++++ Docker pull Waypoint Server container"
  docker pull hashicorp/waypoint:latest
  docker stop waypoint-server
  docker rm waypoint-server
  echo -e '\e[38;5;198m'"++++ Waypoint Job stop"
  for i in $(nomad job status | grep -e trex -e waypoint | tr -s " " | cut -d " " -f1); do nomad job stop $i; done
  echo -e '\e[38;5;198m'"++++ Nomad System GC"
  sudo --preserve-env=PATH -u vagrant nomad system gc
  echo -e '\e[38;5;198m'"++++ Waypoint Job Status"
  sudo --preserve-env=PATH -u vagrant nomad job status
  echo -e '\e[38;5;198m'"++++ Waypoint Context Clear"
  sudo --preserve-env=PATH -u vagrant waypoint context list
  sudo --preserve-env=PATH -u vagrant waypoint context clear
  # remove the previous waypoint db so that new context can be created
  sudo rm -rf /opt/nomad/data/volume/waypoint/*
  echo -e '\e[38;5;198m'"++++ Waypoint Install on Platform Hashicorp Nomad"
  export NOMAD_ADDR='http://localhost:4646'
  sudo --preserve-env=PATH -u vagrant waypoint install -platform=nomad -nomad-dc=dc1 -accept-tos -nomad-host-volume=waypoint -nomad-consul-service=true -context-create=nomad -runner=false
  sleep 60;
  nomad job status
  nomad status
  echo -e '\e[38;5;198m'"++++ Set Waypoint Context Nomad"
  sudo --preserve-env=PATH -u vagrant waypoint context use nomad
  export WAYPOINT_TOKEN_NOMAD=$(sudo --preserve-env=PATH -u vagrant waypoint user token)
  echo -e '\e[38;5;198m'"++++ Waypoint Server https://localhost:9702 and enter the following Token displayed below"
  echo $WAYPOINT_TOKEN_NOMAD
  echo -e '\e[38;5;198m'"++++ Waypoint Context"
  sudo --preserve-env=PATH -u vagrant waypoint context list
  sudo --preserve-env=PATH -u vagrant waypoint context verify
  echo -e '\e[38;5;198m'"++++ Waypoint Init and Up T-Rex Nodejs Example"
  echo -e '\e[38;5;198m'"++++ Found here /vagrant/hashicorp/waypoint/custom-examples/nomad-trex-nodejs"
  cd /vagrant/hashicorp/waypoint/custom-examples/nomad-trex-nodejs
  echo -e '\e[38;5;198m'"++++ Waypoint config /vagrant/hashicorp/waypoint/custom-examples/nomad-trex-nodejs/waypoint.hcl"
  echo -e '\e[38;5;198m'"++++ Waypoint Init"
  sudo --preserve-env=PATH -u vagrant waypoint init
  echo -e '\e[38;5;198m'"++++ Waypoint Up"
  sudo --preserve-env=PATH -u vagrant waypoint up
  echo -e '\e[38;5;198m'"++++ Waypoint Deploy"
  sudo --preserve-env=PATH -u vagrant waypoint deploy
  echo -e '\e[38;5;198m'"++++ Waypoint Server https://localhost:9702 and enter the following Token displayed below"
  echo $WAYPOINT_TOKEN_NOMAD
  echo -e '\e[38;5;198m'"++++ Waypoint Documentation http://localhost:3333/#/hashicorp/README?id=waypoint"
  echo -e '\e[38;5;198m'"++++ Nomad http://localhost:4646"
}

waypoint-install
$1