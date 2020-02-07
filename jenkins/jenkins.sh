#!/bin/bash
sudo docker stop jenkins
sudo docker rm jenkins
yes | sudo docker system prune -a
yes | sudo docker system prune --volumes
sudo docker run -d -p 8088:8088 -e JENKINS_OPTS="--httpPort=8088" --restart always --name jenkins -v /var/jenkins_home:/var/jenkins_home jenkins/jenkins:lts
sleep 15
echo -e '\e[38;5;198m'"++++ To use Jenkins please open in your browser"
echo -e '\e[38;5;198m'"++++ http://localhost:8088"
echo -e '\e[38;5;198m'"++++ Login with jenkins:jenkins"
