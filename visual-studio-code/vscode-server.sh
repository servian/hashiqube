
# Run cleanup 
echo -e '\e[38;5;198m'"++++ Running cleanup"
sudo docker stop code-server
sudo docker rm code-server
yes | sudo docker system prune -a
yes | sudo docker system prune --volumes

echo -e '\e[38;5;198m'"++++ Installing Visual Studio Code Server from codercom's container https://hub.docker.com/r/codercom/code-server"
mkdir -p ~/.config
docker run -d --name code-server -p 0.0.0.0:7777:8080 \
  -v "$HOME/.config:/home/coder/.config" \
  -v "$PWD:/home/coder/project" \
  -v "/:/home/coder/vagrant_root"\
  -u "$(id -u):$(id -g)" \
  -e "DOCKER_USER=$USER" \
  codercom/code-server:latest

echo -e '\e[38;5;198m'"++++ Your VSCode instance should now be avaliable at http://localhost:7777/"
echo -e '\e[38;5;198m'"++++ Login info is:"
sleep 5
echo -e '\e[38;5;198m'"++++ "$(< ~/.config/code-server/config.yaml head -n "3" | tail -n +"3")""