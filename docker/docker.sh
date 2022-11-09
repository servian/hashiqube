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
# BUG: error reopening /dev/null https://bugs.launchpad.net/ubuntu/+source/docker.io/+bug/1950071 so we pin docker-ce=5:20.10.16~3-0~ubuntu-focal and containerd.io=1.5.11-1
# BUG: https://github.com/containerd/containerd/issues/6203
# INFO: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error reopening /dev/null inside container: open /dev/null: operation not permitted: unknown
sudo DEBIAN_FRONTEND=noninteractive apt-get install --allow-downgrades --assume-yes docker-ce=5:20.10.9~3-0~ubuntu-focal docker-ce-cli containerd.io=1.5.11-1 docker-compose-plugin
sudo usermod -aG docker vagrant
sudo mkdir -p /etc/docker
sudo echo '{
  "metrics-addr": "0.0.0.0:9323",
  "experimental": true,
  "storage-driver": "overlay2",
  "insecure-registries": ["10.9.99.10:5001", "10.9.99.10:5002", "localhost:5001", "localhost:5002"]
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
# https://docs.docker.com/registry/deploying/#customize-the-published-port
docker run -d --restart=always \
  --name registry \
  -v "$(pwd)"/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5002 \
  --memory 256M -p 5002:5002 registry:2

cat <<EOF | sudo tee /etc/docker/auth.json
{
  "username": "admin",
  "password": "password",
  "email": "admin@localhost"
}
EOF

echo "Docker Login to Registry"
sleep 10;
sudo --preserve-env=PATH -u vagrant docker login -u="admin" -p="password" http://10.9.99.10:5002

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
