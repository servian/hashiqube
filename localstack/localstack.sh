#!/bin/bash
# https://docs.localstack.cloud/get-started/

sudo usermod -aG docker vagrant
export PATH=$PATH:/root/.local/bin
rm awscliv2.zip
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
rm -rf aws
unzip -q awscliv2.zip
yes | sudo ./aws/install --update
echo -e '\e[38;5;198m'"aws --version"
aws --version
python3 -m pip install awscli-local --quiet
python3 -m pip install flask-cors --quiet
sudo -E docker stop localstack_main
yes | sudo docker system prune --volumes
sudo docker run --rm -it -d -p 4566:4566 -p 4571:4571 --rm --privileged --name localstack_main localstack/localstack
sudo docker ps | grep localstack
