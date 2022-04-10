#/bin/bash
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo -i
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#PROCESSOR_ARCHITECTURE=$(lscpu | grep "Architecture" | awk '{print $NF}') >> /etc/environment
#echo -e '\e[38;5;198m'"CPU is $PROCESSOR_ARCHITECTURE"
arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
if [[ $arch == x86_64* ]]; then
    ARCH="amd64"
elif  [[ $arch == aarch64 ]]; then
    ARCH="arm64"
fi
echo -e '\e[38;5;198m'"CPU is $ARCH"
sudo add-apt-repository "deb [arch=$ARCH] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker vagrant
sudo mkdir -p /etc/docker
sudo echo '{
  "metrics-addr": "0.0.0.0:9323",
  "experimental": true,
  "storage-driver": "overlay2"
}
' >/etc/docker/daemon.json
sudo service docker restart
cd /vagrant/docker
docker stop registry
docker rm registry
docker stop apache2
docker rm apache2
yes | sudo docker system prune -a
yes | sudo docker system prune --volumes
echo "Creating Private Docker Registry"
docker run -d -p 5001:5001 --restart=always --name registry --memory 16M registry:2
echo -e '\e[38;5;198m'"++++ docker build -t apache2 ."
docker build -t apache2 .
echo -e '\e[38;5;198m'"++++ docker images --filter reference=apache2"
docker images --filter reference=apache2
echo -e '\e[38;5;198m'"++++ docker run -t -d -i -p 8889:80 --name apache2 --rm apache2"
docker run -t -d -i -p 8889:80 --name apache2 --memory 16M --rm apache2
docker ps
echo -e '\e[38;5;198m'"++++ Docker stats"
docker stats --no-stream -a
echo -e '\e[38;5;198m'"++++ open http://localhost:8889 in your browser"
echo -e '\e[38;5;198m'"++++ you can also run below to get apache2 version from the docker container"
echo -e '\e[38;5;198m'"++++ vagrant ssh -c \"docker ps; docker exec -it apache2 /bin/bash -c 'apache2 -t -v; ps aux'\""
