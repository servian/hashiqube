#!/bin/bash
# https://learn.hashicorp.com/tutorials/boundary/getting-started-install
# https://learn.hashicorp.com/tutorials/boundary/getting-started-dev

function boundary-install() {
  sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
  yes | sudo docker system prune -a
  yes | sudo docker system prune --volumes
  # check if waypoint is installed, start and exit
  if [ -f /usr/local/bin/boundary ]; then
    echo -e '\e[38;5;198m'"++++ Bundary already installed at /usr/local/bin/boundary"
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/boundary version`"
  else
  # if boundary is not installed, download and install
    echo -e '\e[38;5;198m'"++++ Boundary not installed, installing.."
    LATEST_URL=$(curl -sL https://releases.hashicorp.com/boundary/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep 'linux.*amd64' | sort -V | tail -n 1)
    wget -q $LATEST_URL -O /tmp/boundary.zip
    mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/boundary.zip)
    echo -e '\e[38;5;198m'"++++ Installed `/usr/local/bin/boundary version`"
  fi
  mkdir -p /etc/boundary
  cat <<EOF | sudo tee /etc/boundary/server.conf
listener "tcp" {
  purpose = "api"
  address = "0.0.0.0:19200"
}
EOF
  echo -e '\e[38;5;198m'"++++ Starting Boundary in dev mode"
  pkill boundary
  sleep 10
  pkill boundary
  nohup boundary dev -api-listen-address 0.0.0.0:19200 > /var/log/boundary.log 2>&1 &
  sh -c 'sudo tail -f /var/log/boundary.log | { sed "/worker successfully authed/ q" && kill $$ ;}'
  echo -e '\e[38;5;198m'"++++ Boundary Server started at http://localhost:19200"
  echo -e '\e[38;5;198m'"++++ Login with admin:password"
  # TODO: read token and test login
  # boundary authenticate password -login-name=admin -password password -auth-method-id=ampw_1234567890 -addr=http://127.0.0.1:19200
}

boundary-install
