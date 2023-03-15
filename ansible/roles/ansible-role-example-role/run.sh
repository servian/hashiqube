#!/bin/bash
echo "Set Environment Variables"
export PIP_DISABLE_PIP_VERSION_CHECK=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox:/mnt/c/Windows/System32"
echo "Create Python Virtual Environment"
python -m venv ansible-venv
source ./ansible-venv/bin/activate
echo "Check Python and Pip Versions"
python -V
pip -V
echo "Install Python Pip Packages"
pip install -r requirements.txt --quiet
echo "Running Ansible Lint"
ansible-lint -v || true
echo "Running Ansible Molecule"
molecule destroy
rm -rf ~/.cache/molecule
#molecule create
#molecule converge -- -v --list-tags
molecule converge -- -v
#molecule destroy
#molecule test
