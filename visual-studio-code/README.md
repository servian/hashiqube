# Visual Studio Code

This page has 2 sections:

* [Visual Studio Code on your laptop](/visual-studio-code/?id=visual-studio-code)
* [Visual Studio Code in your browser](/visual-studio-code/?id=vscode-server-vscode-in-a-browser)

https://code.visualstudio.com/

Visual Studio Code or VSCode is a Code Editor, also referred to as an IDE. It's made by Microsoft, it's completely free, very powerful and run on all Operating Systems and Architectures. 

It has many extensions and plugins and can help you write betetr code faster. 

![VSCode](images/vscode.png?raw=true "VSCode")

## Download and Install VSCode

To use VSCode, please down load it from here: 
https://code.visualstudio.com/Download

## Download and Install Popular VSCode Extensions 

Also install these popular Extensions to help you get started: 

- Azure Terraform Extension
https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform

- Terraform Extension
https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform

- Install Git History Extension
https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory

- Install GitLens Extension
https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens

- YAML Extension
https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml

- Docker Remote Extension (Dev Containers / Remote Containers)
https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers

- AWS Toolkit
https://aws.amazon.com/visualstudiocode/

- AWS CloudFormation Extension
https://marketplace.visualstudio.com/items?itemName=aws-scripting-guy.cform

- Dracula Dark Theme
https://marketplace.visualstudio.com/items?itemName=dracula-theme.theme-dracula

- Live Share Extension 
https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare-pack

## Using Dev Containers also called Remote Containers with VSCode 

https://code.visualstudio.com/docs/devcontainers/containers

The Visual Studio Code Dev Containers extension lets you use a container as a full-featured development environment. It allows you to open any folder inside (or mounted into) a container and take advantage of Visual Studio Code's full feature set. A devcontainer.json file in your project tells VS Code how to access (or create) a development container with a well-defined tool and runtime stack. This container can be used to run an application or to separate tools, libraries, or runtimes needed for working with a codebase.

Workspace files are mounted from the local file system or copied or cloned into the container. Extensions are installed and run inside the container, where they have full access to the tools, platform, and file system. This means that you can seamlessly switch your entire development environment just by connecting to a different container.

## Using Hashiqube as a Dev Container (Development Environment)

- Start Hashiqube with `vagrant up --provision`

- Install the Docker Remote Extension (Dev Containers / Remote Containers)
https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers

- In VSCode Top Menu, click on View -> Command Palette and type in
`Dev Containers: Attach to Running Container...`

![Dev Containers: Attach to Running Container](images/vscode-view-command-palette-attach-to-running-container.png?raw=true "Dev Containers: Attach to Running Container")

- Select the running Hashiqube Container

![Dev Containers: Attach to Running Container](images/vscode-view-command-palette-attach-to-running-container-select-hashiqube-container.png?raw=true "Dev Containers: Attach to Running Container")

- You are now inside Hashiqube Docker container, and you can work locally an interact with Hashiqube

:bulb: Remember to do `su - vagrant` and `cd /vagrant` to become the vagrant user so that you work as the vagrant user, you can then issue `kubectl` or `terraform` commands if you ran the provisioners first from a terminal on your laptop. 

![VSCode](images/vscode-hashiqube-devcontainer.png?raw=true "VSCode")

# VScode Server VSCode in a Browser! 

https://code.visualstudio.com/

https://github.com/coder/code-server

VSCode is a free, open source IDE. Code-server runs an instance of VS code that can then be accessed locally via browser. This allows us to start up a predictable VScode instance in Vagrant. 

![VSCode in a Browser](images/vscode-in-a-browser.png?raw=true "VSCode in a Browser")

## Provision

In order to provision Visual Studio Code Server (Visual Studio IDE in a browser) you need bastetools, docker as dependencies. 

`vagrant up --provision-with basetools,docker,vscode-server`

## Web UI Access

To access the Web UI visit the following address:
```
http://localhost:7777/
```

The default password will be printed to console on start up. Else it can be obtained by the following command:
```
vagrant ssh -c "< ~/.config/code-server/config.yaml head -n "3" | tail -n +"3""
```

## Future plans

In the future there is potential to add an option for starting different code-server instances. Currently it always launches with the default image. Custom images could be setup that have different things preinstalled (e.g. Image with python, usefull libaries and useful extentions pre installed).
