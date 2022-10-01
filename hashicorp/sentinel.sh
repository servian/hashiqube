#!/bin/bash

function sentinel-install() {
  arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
  if [[ $arch == x86_64* ]]; then
    ARCH="amd64"
  elif  [[ $arch == aarch64 ]]; then
    ARCH="arm64"
  fi
  echo -e '\e[38;5;198m'"CPU is $ARCH"

  sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
  if [ -f /usr/local/bin/sentinel ]; then
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/sentinel version` already installed at /usr/local/bin/sentinel"
  else
    LATEST_URL=$(curl --silent https://releases.hashicorp.com/index.json | jq '{sentinel}' | egrep "linux.*$ARCH" | sort -rh | head -1 | awk -F[\"] '{print $4}')
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
echo -e '\e[38;5;198m'"++++ Let's test some more advanced Sentinel Policies"
# https://github.com/hashicorp/tfe-policies-example
# https://docs.hashicorp.com/sentinel/language/
echo -e '\e[38;5;198m'"++++ https://github.com/hashicorp/tfe-policies-example"
echo -e '\e[38;5;198m'"++++ https://docs.hashicorp.com/sentinel/language/"
cd /vagrant/hashicorp/sentinel/
echo -e '\e[38;5;198m'"++++ sentinel test aws-block-allow-all-cidr.sentinel"
sentinel test aws-block-allow-all-cidr.sentinel || true
echo -e '\e[38;5;198m'"++++ sentinel apply -config ./test/aws-block-allow-all-cidr/pass.json aws-block-allow-all-cidr.sentinel"
sentinel apply -config ./test/aws-block-allow-all-cidr/pass.json aws-block-allow-all-cidr.sentinel
echo -e '\e[38;5;198m'"++++ sentinel apply -config ./test/aws-block-allow-all-cidr/fail.json aws-block-allow-all-cidr.sentinel"
sentinel apply -config ./test/aws-block-allow-all-cidr/fail.json aws-block-allow-all-cidr.sentinel || true
echo -e '\e[38;5;198m'"++++ sentinel test aws-alb-redirect.sentinel"
sentinel test aws-alb-redirect.sentinel || true
echo -e '\e[38;5;198m'"++++ sentinel apply -config ./test/aws-alb-redirect/fail.json aws-alb-redirect.sentinel"
sentinel apply -config ./test/aws-alb-redirect/fail.json aws-alb-redirect.sentinel || true
echo -e '\e[38;5;198m'"++++ sentinel apply -config ./test/aws-alb-redirect/pass.json aws-alb-redirect.sentinel"
sentinel apply -config ./test/aws-alb-redirect/pass.json aws-alb-redirect.sentinel
}

sentinel-install
