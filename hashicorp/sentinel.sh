#!/bin/bash

function sentinel-install() {
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
  if [ -f /usr/local/bin/sentinel ]; then
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/sentinel version` already installed at /usr/local/bin/sentinel"
  else
    LATEST_URL=$(curl --silent https://releases.hashicorp.com/index.json | jq '{sentinel}' | egrep "linux_amd.*64" | sort -rh | head -1 | awk -F[\"] '{print $4}')
    wget -q $LATEST_URL -O /tmp/sentinel.zip
    mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/sentinel.zip)

    echo -e '\e[38;5;198m'"++++ Installed: `/usr/local/bin/sentinel version`"
  fi
  # add basic configuration settings for Vault to /etc/vault/config.hcl file
  cat <<EOF | sudo tee /tmp/policy.sentinel
hour = 4
main = rule { hour >= 0 and hour < 12 }
EOF
echo -e '\e[38;5;198m'"++++ cat /tmp/policy.sentinel"
cat /tmp/policy.sentinel
echo -e '\e[38;5;198m'"++++ sentinel apply /tmp/policy.sentinel"
sentinel apply /tmp/policy.sentinel
}

sentinel-install
