#!/bin/bash

echo -e "++++ "
echo -e "++++ Check if packer is installed"
echo -e "++++ "
if ! [ -x "$(command -v packer)" ]; then
  echo 'Error: packer is not installed.' >&2
  exit 1
else
  echo "Packer version installed: "$(packer -v) 
fi

echo -e "++++ "
echo -e "++++ Check if ansible is installed"
echo -e "++++ "
scripts/install-ansible.sh

echo -e "++++ "
echo -e "++++ Run Packer"
echo -e "++++ "
# packer build -force -only='docker.ubuntu-2204' all