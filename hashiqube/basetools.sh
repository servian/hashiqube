#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export PATH=$PATH:/root/.local/bin
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes update -o Acquire::CompressionTypes::Order::=gz
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install swapspace rkhunter jq curl unzip software-properties-common bzip2 git make python3.9 python3-pip python3-dev python3-venv python3-virtualenv golang-go apt-utils ntp update-motd toilet figlet nano iputils-ping dnsutils iptables telnet
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 --force
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 --force
python -V
sudo python -V
pip -V
sudo pip -V
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes autoremove
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes clean
sudo rm -rf /var/lib/apt/lists/partial

# set MOTD using toilet-fonts
sudo mkdir -p /etc/update-motd.d

cat <<EOF | sudo tee /etc/update-motd.d/00-header
#!/bin/bash
/usr/bin/toilet --gay -f standard $(hostname) -w 170
printf "%s"
EOF

echo -e '\e[38;5;198m'"END BOOTSTRAP $(date '+%Y-%m-%d %H:%M:%S')"
