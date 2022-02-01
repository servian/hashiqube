#!/bin/bash
sudo docker stop ldap
sudo docker rm ldap
yes | sudo docker system prune -a
yes | sudo docker system prune --volumes
sudo docker run --privileged -d -p 389:389 --name ldap rroemhild/test-openldap
echo -e '\e[38;5;198m'"++++ To use this in Vault please do"
echo -e '\e[38;5;198m'"++++ vault auth enable ldap"
echo -e '\e[38;5;198m'"++++ vault write auth/ldap/config url=\"ldap://localhost:389\" userdn=\"ou=people,dc=planetexpress,dc=com\" groupdn=\"ou=people,dc=planetexpress,dc=com\" groupattr=\"cn\" insecure_tls=true userattr=uid starttls=false binddn=\"cn=admin,dc=planetexpress,dc=com\" bindpass='GoodNewsEveryone'"
echo -e '\e[38;5;198m'"++++ vault login -method=ldap username=hermes (password: hermes)"
