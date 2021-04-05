#!/bin/bash
# https://www.waypointproject.io/docs/getting-started
# https://learn.hashicorp.com/tutorials/waypoint/get-started-nomad?in=waypoint/get-started-nomad

function waypoint-install() {
  sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
  yes | sudo docker system prune -a
  yes | sudo docker system prune --volumes
  # check if waypoint is installed, start and exit
  if [ -f /usr/local/bin/waypoint ]; then
    echo -e '\e[38;5;198m'"++++ Waypoint already installed at /usr/local/bin/waypoint"
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/waypoint version`"
  else
  # if waypoint is not installed, download and install
    echo -e '\e[38;5;198m'"++++ Waypoint not installed, installing.."
    LATEST_URL=$(curl -sL https://releases.hashicorp.com/waypoint/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep 'linux.*amd64' | sort -V | tail -n 1)
    wget -q $LATEST_URL -O /tmp/waypoint.zip
    mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/waypoint.zip)
    echo -e '\e[38;5;198m'"++++ Installed `/usr/local/bin/waypoint version`"
  fi
  echo -e '\e[38;5;198m'"++++ Docker pull Waypoint Server container"
  docker pull hashicorp/waypoint:latest
  docker stop waypoint-server
  docker rm waypoint-server
  echo -e '\e[38;5;198m'"++++ Waypoint Server starting"
  export NOMAD_ADDR='http://localhost:4646'
  waypoint install -platform=nomad -nomad-dc=dc1 -accept-tos
  nomad status
  echo -e '\e[38;5;198m'"++++ Git Clone Waypoint examples"
  rm -rf /vagrant/hashicorp/waypoint/examples
  mkdir -p /vagrant/hashicorp/waypoint
  git clone https://github.com/hashicorp/waypoint-examples.git /vagrant/hashicorp/waypoint/examples
  cd /vagrant/hashicorp/waypoint/examples/docker/nodejs
  sed -i '/<\/h1>/a <p>The files are located in \/vagrant\/hashicorp\/waypoint\/examples\/docker\/nodejs, and this file is views/pages/index.ejs<\/p>' /vagrant/hashicorp/waypoint/examples/docker/nodejs/views/pages/index.ejs
  echo -e '\e[38;5;198m'"++++ Write /vagrant/hashicorp/waypoint/examples/docker/nodejs/waypoint.hcl"
  rm -rf /vagrant/hashicorp/waypoint/examples/docker/nodejs/waypoint.hcl
  cat <<EOF | sudo tee /vagrant/hashicorp/waypoint/examples/docker/nodejs/waypoint.hcl
project = "example-nodejs"
app "example-nodejs" {
  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "nodejs-example"
        tag = "1"
        local = true
      }
    }
  }
  deploy {
    use "nomad" {
      datacenter = "dc1"
    }
  }
}
EOF
  echo -e '\e[38;5;198m'"++++ Stop the Nodejs example job if running"
  nomad job stop $(nomad job status | grep running | grep example | cut -d ' ' -f1)
  waypoint init
  waypoint up
  echo -e '\e[38;5;198m'"++++ Waypoint Server https://10.9.99.10:9702 and enter the following Token displayed below"
  sudo waypoint token new
  echo -e '\e[38;5;198m'"++++ Nomad http://localhost:4646"

}

waypoint-install
