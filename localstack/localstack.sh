#!/bin/bash
sudo usermod -aG docker vagrant
sudo -i
export PATH=$PATH:/root/.local/bin
sudo -E -H pip3 install --upgrade awscli-local
sudo -E -H pip3 install --upgrade awscli
sudo -E -H pip3 install --upgrade localstack
sudo -E -H pip3 install --upgrade flask-cors
sudo -i
sudo -E docker stop localstack_main
sudo -E docker rm localstack_main
yes | sudo docker system prune --volumes
sudo -E ENTRYPOINT=-d localstack start --docker
