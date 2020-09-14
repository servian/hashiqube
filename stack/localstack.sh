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
# BUG: https://github.com/servian/hashiqube/issues/1
#sudo -E ENTRYPOINT=-d localstack start --docker
sudo docker run -it -d -e DEFAULT_REGION="us-east-1" -e TEST_AWS_ACCOUNT_ID="000000000000" -e LOCALSTACK_HOSTNAME="localhost" -p 7443:443 -p 4566:4566 --rm --privileged --name localstack_main -p 8080:8080 -p 8081:8081  -p 4567-4617:4567-4617 -v "/tmp/localstack:/tmp/localstack" -v "/var/run/docker.sock:/var/run/docker.sock" -e DOCKER_HOST="unix:///var/run/docker.sock" -e HOST_TMP_FOLDER="/tmp/localstack" "localstack/localstack"
