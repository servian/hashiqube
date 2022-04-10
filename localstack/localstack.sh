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

sudo -i -u vagrant
pip3 install --upgrade awscli-local
rm awscliv2.zip
# https://aws.amazon.com/blogs/developer/aws-cli-v2-now-available-for-linux-arm/ aarch64
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip" -o "awscliv2.zip"
rm -rf aws
unzip -q awscliv2.zip
yes | sudo ./aws/install --update
echo -e '\e[38;5;198m'"aws --version"
aws --version
python3 -m pip install awscli-local --quiet
python3 -m pip install flask-cors --quiet
sudo -E docker stop localstack_main
yes | sudo docker system prune --volumes
sudo docker run --rm -it -d -p 4566:4566 -p 4571:4571 --rm --privileged --memory 256M --name localstack_main localstack/localstack
sudo docker ps | grep localstack
