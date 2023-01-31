#!/bin/bash

# https://github.com/ansible/awx-operator#basic-install
# https://docs.ansible.com/ansible-tower/latest/html/towercli/index.html
# https://github.com/ansible/awx/blob/17.0.1/INSTALL.md
# https://github.com/ansible/awx/blob/devel/tools/docker-compose/README.md
# https://github.com/ansible/awx
# https://blog.palark.com/ready-to-use-commands-and-tips-for-kubectl/
# https://techfrontier.me.uk/post/finally-my-own-awx-server/

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Add ~/.local/bin to PATH"
echo -e '\e[38;5;198m'"++++ "
export PATH="/home/vagrant/.local/bin:$PATH"
sudo --preserve-env=PATH -u vagrant env | grep PATH

# https://github.com/ansible/awx/blob/17.0.1/INSTALL.md#clone-the-repo
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Clone https://github.com/ansible/awx.git into /opt/awx"
echo -e '\e[38;5;198m'"++++ "
sudo rm -rf /opt/awx
sudo mkdir -p /opt/awx
sudo chown -R vagrant:vagrant /opt/awx
sudo --preserve-env=PATH -u vagrant git clone https://github.com/ansible/awx.git /opt/awx --depth 1 --branch 21.7.0

cd /opt/awx

# https://github.com/ansible/awx/blob/17.0.1/INSTALL.md#prerequisites
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Install Ansible and AWX dependencies with pip"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant python -m pip install docker --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install docker-compose --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install ansible --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install ansible-lint --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install wheel --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install pywinrm --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install requests --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install docker --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install molecule --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install junit_xml --quiet
sudo --preserve-env=PATH -u vagrant python -m pip install awxkit --quiet

# BUG: https://techfrontier.me.uk/post/finally-my-own-awx-server/
# Back-off pulling image "quay.io/ansible/awx-ee:latest"
# This looks to relate image "quay.io/ansible/awx-ee:latest" being large and not pulling quick enough, so we manually intervene and get it into our docker library by hand.
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Pull quay.io/ansible/awx-ee:latest to avoid Back-off pulling image later"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant minikube ssh docker pull quay.io/ansible/awx-ee:latest

# https://github.com/ansible/awx-operator#basic-install
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create kustomization.yaml"
echo -e '\e[38;5;198m'"++++ "
cat <<EOF | sudo --preserve-env=PATH -u vagrant tee ./kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # Find the latest tag here: https://github.com/ansible/awx-operator/releases
  - github.com/ansible/awx-operator/config/default?ref=1.1.4

# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 1.1.4

# Specify a custom namespace in which to install AWX
namespace: awx
EOF

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create awx.yaml with kubectl kustomize > awx.yaml"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant kubectl kustomize > awx.yaml
cat awx.yaml

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create AWX resources using kubectl apply -f awx.yaml"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant kubectl apply -f awx.yaml

# https://github.com/ansible/awx/blob/17.0.1/INSTALL.md#post-install-1
attempts=0
max_attempts=20
while ! ( sudo --preserve-env=PATH -u vagrant kubectl get pods --namespace awx | grep controller | tr -s " " | cut -d " " -f3 | grep Running ) && (( $attempts < $max_attempts )); do
  attempts=$((attempts+1))
  sleep 60;
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Waiting for AWX Controller to become available, (${attempts}/${max_attempts}) sleep 60s"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl get po --namespace awx
  sudo --preserve-env=PATH -u vagrant kubectl get events | grep -e Memory -e OOM
done

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create awx-demo.yaml and add to kustomization.yaml"
echo -e '\e[38;5;198m'"++++ "
cat <<EOF | sudo --preserve-env=PATH -u vagrant tee ./awx-demo.yaml
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-demo
spec:
  ee_images:
    - name: quay.io/ansible/awx-ee:latest
      image: quay.io/ansible/awx-ee:latest
  service_type: nodeport
  # default nodeport_port is 30080
  nodeport_port: 30080
EOF

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Add awx-demo.yaml to kustomization.yaml"
echo -e '\e[38;5;198m'"++++ "
cat <<EOF | sudo --preserve-env=PATH -u vagrant tee ./kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # Find the latest tag here: https://github.com/ansible/awx-operator/releases
  - github.com/ansible/awx-operator/config/default?ref=1.1.4
  - awx-demo.yaml

# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 1.1.4

# Specify a custom namespace in which to install AWX
namespace: awx
EOF

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create awx.yaml with kubectl kustomize > awx.yaml"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant kubectl kustomize > awx.yaml

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create AWX resources using kubectl apply -f awx.yaml"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant kubectl apply -f awx.yaml

attempts=0
max_attempts=20
while ! ( sudo --preserve-env=PATH -u vagrant kubectl get pods --namespace awx | grep demo | grep -v postgres | tr -s " " | cut -d " " -f3 | grep Running ) && (( $attempts < $max_attempts )); do
  attempts=$((attempts+1))
  sleep 60;
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Waiting for AWX Demo to become available, (${attempts}/${max_attempts}) sleep 60s"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl get po --namespace awx
  sudo --preserve-env=PATH -u vagrant kubectl get events | grep -e Memory -e OOM
done

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Get the AWX password"
echo -e '\e[38;5;198m'"++++ "
AWX_ADMIN_PASSWORD=$(kubectl get secret awx-demo-admin-password -n awx -o jsonpath="{.data.password}" | base64 --decode)
echo "AWX Admin Password: $AWX_ADMIN_PASSWORD"

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Check that AWX Ansible Tower web interface is available"
echo -e '\e[38;5;198m'"++++ "
attempts=0
max_attempts=20
while ! ( kubectl exec $(kubectl get po -n awx | grep -v operator | grep -v postgres | grep awx | tr -s " " | cut -d " " -f1) --container="redis" -n awx -- /bin/bash -c "apt-get -qqq update && apt-get -qqq install -y procps curl net-tools && netstat -nlp | grep 8052" ) && (( $attempts < $max_attempts )); do
  attempts=$((attempts+1))
  sleep 60;
  echo -e '\e[38;5;198m'"++++ Waiting for AWX Ansible Tower web interface to become ready, (${attempts}/${max_attempts}) sleep 60s"
  kubectl exec $(kubectl get po -n awx | grep -v operator | grep -v postgres | grep awx | tr -s " " | cut -d " " -f1) --container="redis" -n awx -- /bin/bash -c "ps aux; netstat -nlp"
done

attempts=0
max_attempts=20
while ! ( sudo netstat -nlp | grep 8043 ) && (( $attempts < $max_attempts )); do
  attempts=$((attempts+1))
  sleep 60;
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ kubectl port-forward -n awx service/awx-demo-service 8043:80 --address=\"0.0.0.0\", (${attempts}/${max_attempts}) sleep 60s"
  echo -e '\e[38;5;198m'"++++ "
  sudo --preserve-env=PATH -u vagrant kubectl port-forward -n awx service/awx-demo-service 8043:80 --address="0.0.0.0" > /dev/null 2>&1 &
done

# https://docs.ansible.com/ansible-tower/latest/html/towercli/index.html
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Export AWX_COMMON variables"
echo -e '\e[38;5;198m'"++++ "
export AWX_COMMON="--conf.format human --conf.insecure --conf.host http://localhost:8043 --conf.username admin --conf.password $AWX_ADMIN_PASSWORD"

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Adding /home/vagrant/.tower_cli.cfg and doing awx-cli login"
echo -e '\e[38;5;198m'"++++ "
cat <<EOF | sudo --preserve-env=PATH -u vagrant tee /home/vagrant/.tower_cli.cfg
[general]
verify_ssl = False
insecure = True
description_on = False
host = http://localhost:8043
color = True
oauth_token =
certificate =
use_token = False
format = human
username = admin
verbose = True
password = $AWX_ADMIN_PASSWORD
EOF

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-organizations-list
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Check if Default organisation exists"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx organizations list --wait $AWX_COMMON | grep -q "Default"
if [ $? -eq 1 ]; then
  echo -e '\e[38;5;198m'"++++ Organization 'Default' doesn't exist, creating"
  sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx organizations create --name "Default" --description "Default" --wait $AWX_COMMON
else
  echo -e '\e[38;5;198m'"++++ Organization 'Default' exists"
fi

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-inventory-list
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Check if 'Demo Inventory' exists"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx inventory list --wait $AWX_COMMON | grep -q 'Demo Inventory'
if [ $? -eq 1 ]; then
  echo -e '\e[38;5;198m'"++++ 'Demo Inventory' doesn't exist, creating"
  sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx inventory create --name 'Demo Inventory' --description 'Demo Inventory' --organization 'Default' --wait $AWX_COMMON
else
  echo -e '\e[38;5;198m'"++++ 'Demo Inventory' exists"
fi

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-projects-create
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create projects ansible-role-example-role"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx projects create --organization 'Default' --scm_update_on_launch true --scm_url https://github.com/star3am/ansible-role-example-role --scm_type git --name ansible-role-example-role --description ansible-role-example-role --wait $AWX_COMMON

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-job-templates-create
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Create job_templates ansible-role-example-role"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx job_templates create --name ansible-role-example-role --description ansible-role-example-role --job_type run --inventory 'Demo Inventory' --project 'ansible-role-example-role' --become_enabled true --ask_limit_on_launch true --ask_tags_on_launch true --playbook site.yml --ask_limit_on_launch true --ask_tags_on_launch true --ask_variables_on_launch true --wait $AWX_COMMON

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-credentials-create
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Add credentials ansible"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx credentials create --credential_type 'Machine' --organization 'Default' --name 'ansible' --inputs '{"username": "vagrant", "password": "vagrant"}' $AWX_COMMON

# # https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-job-templates
# echo -e '\e[38;5;198m'"++++ "
# echo -e '\e[38;5;198m'"++++ Associate credential with job_templates Demo Job Template"
# echo -e '\e[38;5;198m'"++++ "
# sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx job_templates disassociate --credential "Demo Credential" --name "Demo Job Template" --wait $AWX_COMMON || true
# sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx job_templates associate --credential "ansible" --name "Demo Job Template" --wait $AWX_COMMON || true

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-job-templates
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Associate credential with job_templates ansible-role-example-role"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx job_templates associate --credential "ansible" --name "ansible-role-example-role" $AWX_COMMON

# # https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-projects-update
# echo -e '\e[38;5;198m'"++++ "
# echo -e '\e[38;5;198m'"++++ Update the project"
# echo -e '\e[38;5;198m'"++++ "
# sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx projects update "Demo Project" --wait $AWX_COMMON

# # https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-projects-modify
# echo -e '\e[38;5;198m'"++++ "
# echo -e '\e[38;5;198m'"++++ Disable project update"
# echo -e '\e[38;5;198m'"++++ "
# sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx projects modify 'Demo Project' --scm_update_on_launch false --wait $AWX_COMMON

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-workflow-job-templates-modify
# echo -e '\e[38;5;198m'"++++ "
# echo -e '\e[38;5;198m'"++++ Modify job_templates Demo Job Template"
# echo -e '\e[38;5;198m'"++++ "
# sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx job_templates modify "Demo Job Template" --name "Demo Job Template" --ask_limit_on_launch true --ask_tags_on_launch true $AWX_COMMON

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Configure SSH to allow login with password"
echo -e '\e[38;5;198m'"++++ "
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo systemctl reload ssh

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-hosts-create
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Add VM host to Ansible Tower inventory"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx hosts create --id 10.9.99.10 --description $(hostname) --inventory 1 --enabled true --name 10.9.99.10 $AWX_COMMON

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-job-templates-launch
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Run Ansible Tower job_template"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx job_templates launch ansible-role-example-role \
  --limit 10.9.99.10 \
  --monitor \
  --filter status $AWX_COMMON \
  --job_tags "day1,always" \
  --extra_vars "{\"vm_name\":\"$(hostname)\", \"vm_ip\":\"10.9.99.10\"}"

# https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-hosts-delete
echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ Remove VM host from Ansible Tower inventory"
echo -e '\e[38;5;198m'"++++ "
sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx hosts delete --id "$(sudo --preserve-env=PATH -u vagrant /home/vagrant/.local/bin/awx hosts list $AWX_COMMON | grep "10.9.99.10" | cut -d ' ' -f1)" $AWX_COMMON

# echo -e '\e[38;5;198m'"++++ "
# echo -e '\e[38;5;198m'"++++ DEBUG with kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager -n awx"
# echo -e '\e[38;5;198m'"++++ "
# sudo --preserve-env=PATH -u vagrant kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager -n awx

echo -e '\e[38;5;198m'"++++ "
echo -e '\e[38;5;198m'"++++ You can now access the AWX Ansible Web Interface at http://localhost:8043"
echo -e '\e[38;5;198m'"++++ Login with Username: admin and Password: $AWX_ADMIN_PASSWORD"
echo -e '\e[38;5;198m'"++++ Documentation can be found at http://localhost:3333/#/ansible-tower/README"
echo -e '\e[38;5;198m'"++++ "
