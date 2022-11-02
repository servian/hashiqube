#!/bin/bash
# https://docs.localstack.cloud/get-started/

sudo usermod -aG docker vagrant
export PATH=$PATH:/root/.local/bin

arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
if [[ $arch == x86_64* ]]; then
  ARCH="amd64"
elif  [[ $arch == aarch64 ]]; then
  ARCH="arm64"
fi
echo -e '\e[38;5;198m'"CPU is $ARCH"

if [[ ! -f /usr/local/bin/terraform ]];
then
  echo -e '\e[38;5;198m'"++++ Ensure Terraform is not installed, installing"
  sudo bash /vagrant/hashicorp/terraform.sh
else
  echo -e '\e[38;5;198m'"++++ Terraform is installed"
fi

pip3 install --upgrade awscli-local
sudo rm -rf awscliv2.zip
# https://aws.amazon.com/blogs/developer/aws-cli-v2-now-available-for-linux-arm/ aarch64
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip" -o "awscliv2.zip"
sudo rm -rf aws
sudo unzip -q awscliv2.zip
yes | sudo ./aws/install --update
echo -e '\e[38;5;198m'"aws --version"
aws --version
python3 -m pip install awscli-local --quiet
python3 -m pip install flask-cors --quiet
sudo -E docker stop localstack_main
yes | sudo docker system prune --volumes
sudo docker run --rm -it -d -p 4566:4566 -p 4571:4571 --rm --privileged --memory 256M --name localstack_main localstack/localstack
sudo docker ps | grep localstack

cd /vagrant/localstack/
export PATH=$HOME/.local/bin:$PATH
echo -e '\e[38;5;198m'"++++ removing previous state files.."
rm -rf ./terraform.tfstate*
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
echo -e '\e[38;5;198m'"++++ awslocal s3 ls.."
awslocal s3 ls || true
echo -e '\e[38;5;198m'"++++ terraform destroy.."
terraform destroy --auto-approve
