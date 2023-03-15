# Ansible
https://www.ansible.com/

## About
Ansible is an open-source software provisioning, configuration management, and application-deployment tool. It runs on many Unix-like systems, and can configure both Unix-like systems as well as Microsoft Windows. It includes its own declarative language to describe system configuration.

## Molecule 
https://molecule.readthedocs.io/en/latest/

Molecule project is designed to aid in the development and testing of Ansible roles and can speed up local development of Ansible roles and playbooks in magnetude!

Molecule provides support for testing with multiple instances, operating systems and distributions, virtualization providers, test frameworks and testing scenarios.

Molecule encourages an approach that results in consistently developed roles that are well-written, easily understood and maintained.

Molecule supports only the latest two major versions of Ansible (N/N-1), meaning that if the latest version is 2.9.x, we will also test our code with 2.8.x.

## Practicle example
Molecule sue providers such as docker or virtualbox to create the target instances to run the playbook against. 

The Targets are configured in molecule/molecule.yml

For this example we will use: 
- Ubuntu 22.04
- Windows 2019

### Run Molecule (From your local Laptop)

From the Hashiqube Cloned repo do: 
`cd ansible/roles/ansible-role-example-role && ./run.sh`

## Gotcha's (Sorry!!)
- M1 and M2 Mac Architectures are NOT supported at this stage
- Hyper-V is not supported at this stage
- Your Vagrant version on Windows and in WSL *MUST* be the same 
- Installing WSL could give error: `Catastrophic failure`
``` 
PS C:\Windows\system32> wsl --install
Installing: Windows Subsystem for Linux
Catastrophic failure
```
Restart laptop, run this installation command again, and make sure nothing is downloading in the background at the same time when running the command.


- WSL Ubuntu Install could give error: `An error occurred during installation. Distribution Name: 'Ubuntu' Error Code: 0x8000ffff`
```
PS C:\WINDOWS\system32> wsl --install -d ubuntu
Installing: Ubuntu
An error occurred during installation. Distribution Name: 'Ubuntu' Error Code: 0x8000ffff
```
Follow this link: https://askubuntu.com/questions/1434150/wsl-ubuntu-installation-fails-with-the-error-please-restart-wsl-with-the-follo and 
https://learn.microsoft.com/en-us/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package

Note : Run ``` wsl --install -d Ubuntu ``` in **non administrative** mode in powershell

## Ansible Role Example Role
An example Ansible Role that you can use which covers, Red Hat, Centos, Ubuntu, Debian and Windows Targets. 

Further reading see: [__Ansible Role Example Role__](ansible/roles/ansible-role-example-role/#ansible-role-example-role) 

## Ansible Galaxy Roles
Ansible Galaxy is the Ansible's official community hub for sharing Ansible roles. It is a community and a shared resource hub where people can download roles or Playbooks

To download community roles and playbooks from remote repositories you need a requirements.txt file foe example

```
- src: 'https://github.com/ansible-lockdown/RHEL8-CIS'
  version: '1.3.0'
  scm: 'git'

- src: 'https://github.com/ansible-lockdown/RHEL7-CIS'
  version: '1.1.0'
  scm: 'git'

- src: 'https://github.com/ansible-lockdown/UBUNTU22-CIS'
  version: 'main'
  scm: 'git'

- src: 'https://github.com/ansible-lockdown/UBUNTU20-CIS'
  version: '1.1.0'
  scm: 'git'

- src: 'https://github.com/ansible-lockdown/UBUNTU18-CIS'
  version: '1.3.0'
  scm: 'git'

- src: 'https://github.com/ansible-lockdown/Windows-2016-CIS'
  version: '1.2.1'
  scm: 'git'

- src: 'https://github.com/ansible-lockdown/Windows-2019-CIS'
  version: '1.1.1'
  scm: 'git'

- src: 'https://github.com/star3am/ansible-role-win_openssh'
  version: 'ssh-playbook-test'
  scm: 'git'

- src: 'https://github.com/elastic/ansible-elasticsearch'
  version: 'v7.17.0'
  scm: 'git'
```

You can then download them by using this command: 
`ansible-galaxy install -f -r ansible/galaxy/requirements.yml -p ansible/galaxy/roles/`
