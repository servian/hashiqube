#!/bin/bash

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes nodejs
sudo npm i docsify-cli -g --loglevel=error
cd /vagrant
# This generates SUMMARY.md which is the menu for Docsify
# Example output
# find . -maxdepth 2 -name '*.md' | grep -v SUMMARY | grep -v "\./README" | cut -d "/" -f2 | sort | awk 'BEGIN { print "* [Home](README.md)\n" } { FS=" "} { print "  * ["toupper(substr($0,0,1))tolower(substr($0,2))"]("$1"/README.md)" }'
# * [Home](README.md)
#
#   * [Ansible](ansible/README.md)
#   ...
#   * [Prometheus-grafana](prometheus-grafana/README.md)
#   * [Sonarqube](sonarqube/README.md)
sudo find . -maxdepth 2 -name '*.md' | grep -v SUMMARY | grep -v "\./README" | cut -d "/" -f2 | sort | awk 'BEGIN { print "* [Home](README.md)\n" } { FS=" "} { print "  * ["toupper(substr($0,0,1))tolower(substr($0,2))"]("$1"/README.md)" }' > SUMMARY.md
sudo pkill node
sleep 3
sudo sh -c "echo \"16384\" > /proc/sys/fs/inotify/max_user_watches"
sudo touch /var/log/docsify.log
sudo chmod 777 /var/log/docsify.log
sudo nohup docsify serve --port 3333 . > /var/log/docsify.log 2>&1 &
echo -e '\e[38;5;198m'"++++ Docsify: http://localhost:3333/"
