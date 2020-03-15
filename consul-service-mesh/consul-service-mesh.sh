#!/bin/bash
#echo -e '\e[38;5;198m'"++++ Install Azure CLI"
#curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
#source /data/.bash_profile
#az login -u ${ARM_CLIENT_ID} --service-principal --tenant ${ARM_TENANT_ID} -p ${ARM_CLIENT_SECRET} --allow-no-subscriptions
echo -e '\e[38;5;198m'"++++ Consul Service Mesh"
echo -e '\e[38;5;198m'"++++ Google Cloud Platform"
echo -e '\e[38;5;198m'"++++ Amazon Web Services"
cd /vagrant/consul-service-mesh/terraform
echo -e '\e[38;5;198m'"++++ terraform init.."
terraform init
echo -e '\e[38;5;198m'"++++ terraform fmt.."
terraform fmt
echo -e '\e[38;5;198m'"++++ terraform validate.."
terraform validate
echo -e '\e[38;5;198m'"++++ terraform plan.."
terraform plan
echo -e '\e[38;5;198m'"++++ terraform apply.."
terraform apply --auto-approve
echo -e '\e[38;5;198m'"++++ terraform destroy.."
#terraform destroy --auto-approve
