#!/bin/bash

echo -e "++++ "
echo -e "++++ Set Environment Variables"
echo -e "++++ "
export PIP_DISABLE_PIP_VERSION_CHECK=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export CRYPTOGRAPHY_DONT_BUILD_RUST=1

echo -e "++++ "
echo -e "++++ Create Python Virtual Environment in ../../ansible/ansible-venv"
echo -e "++++ "
python3 -m venv ../../ansible/ansible-venv

echo -e "++++ "
echo -e "++++ Activate Python Virtual Environment in ../../ansible/ansible-venv"
echo -e "++++ "
source ../../ansible/ansible-venv/bin/activate

echo -e "++++ "
echo -e "++++ Check Python and Pip Versions"
echo -e "++++ "
python3 -V
pip3 -V

ANSIBLE_FORCE_COLOR=1 ANSIBLE_LOAD_CALLBACK_PLUGINS=1 PYTHONUNBUFFERED=1 ansible-playbook "$@"
