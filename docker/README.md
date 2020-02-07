# Docker

## Information

https://docs.docker.com/install/linux/docker-ce/ubuntu/

`vagrant up --provision-with docker`

In this section we will show you how to install docker.io on Ubuntu.
We will also build an Apache2.4 container from a Dockerfile and run it and expose it on your host machine via Vagrant port_forward on http://localhost:8889

## TL;DR

`vagrant up --provision-with docker`

## Setup

When you run `vagrant up --provision-with docker` we will be running the bash commands below, but for more information you can look at the contents below.

```
#/bin/bash
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo -i
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker vagrant
cd /vagrant/docker
docker stop apache2
docker rm apache2
yes | sudo docker system prune -a
yes | sudo docker system prune --volumes
echo "docker build -t apache2 ."
docker build -t apache2 .
echo "docker images --filter reference=apache2"
docker images --filter reference=apache2
echo "docker run -t -d -i -p 8889:80 --name apache2 --rm apache2"
docker run -t -d -i -p 8889:80 --name apache2 --rm apache2
docker ps
echo 'open http://localhost:8889 in your browser'
echo 'vagrant ssh -c "docker exec -it apache2 /bin/bash -c "apache2 -t -v""'
vagrant ssh -c "docker exec -it apache2 /bin/bash -c "apache2 -t -v""
```

## Dockerfile

`Dockerfile`

```
FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && \
 apt-get -y install apache2

# Install apache and write hello world message
RUN echo 'Hello World!' > /var/www/html/index.html

# Configure apache
RUN echo '. /etc/apache2/envvars' > /root/run_apache.sh && \
 echo 'mkdir -p /var/run/apache2' >> /root/run_apache.sh && \
 echo 'mkdir -p /var/lock/apache2' >> /root/run_apache.sh && \
 echo '/usr/sbin/apache2 -D FOREGROUND' >> /root/run_apache.sh && \
 chmod 755 /root/run_apache.sh

EXPOSE 80

CMD /root/run_apache.sh
```

## Running

`vagrant up --provision-with docker`

```
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: docker (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200104-30138-45gz.sh
    user.local.dev: Reading package lists...
    user.local.dev: Building dependency tree...
    user.local.dev:
    user.local.dev: Reading state information...
    user.local.dev: apt-transport-https is already the newest version (1.2.32).
    user.local.dev: ca-certificates is already the newest version (20170717~16.04.2).
    user.local.dev: curl is already the newest version (7.47.0-1ubuntu2.14).
    user.local.dev: gnupg-agent is already the newest version (2.1.11-6ubuntu2.1).
    user.local.dev: software-properties-common is already the newest version (0.96.20.9).
    user.local.dev: 0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    user.local.dev: mesg:
    user.local.dev: ttyname failed
    user.local.dev: :
    user.local.dev: Inappropriate ioctl for device
    user.local.dev: OK
    user.local.dev: Hit:1 https://deb.nodesource.com/node_10.x xenial InRelease
    user.local.dev: Hit:2 https://download.docker.com/linux/ubuntu xenial InRelease
    user.local.dev: Hit:3 http://security.ubuntu.com/ubuntu xenial-security InRelease
    user.local.dev: Hit:4 http://archive.ubuntu.com/ubuntu xenial InRelease
    user.local.dev: Hit:5 http://archive.ubuntu.com/ubuntu xenial-updates InRelease
    user.local.dev: Hit:6 http://archive.ubuntu.com/ubuntu xenial-backports InRelease
    user.local.dev: Reading package lists...
    user.local.dev: Reading package lists...
    user.local.dev: Building dependency tree...
    user.local.dev:
    user.local.dev: Reading state information...
    user.local.dev: containerd.io is already the newest version (1.2.10-3).
    user.local.dev: docker-ce-cli is already the newest version (5:19.03.5~3-0~ubuntu-xenial).
    user.local.dev: docker-ce is already the newest version (5:19.03.5~3-0~ubuntu-xenial).
    user.local.dev: 0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    user.local.dev: apache2
    user.local.dev: Error: No such container: apache2
    user.local.dev: WARNING! This will remove:
    user.local.dev:   - all stopped containers
    user.local.dev:   - all networks not used by at least one container
    user.local.dev:   - all images without at least one container associated to them
    user.local.dev:   - all build cache
    user.local.dev:
    user.local.dev: Are you sure you want to continue? [y/N]
    user.local.dev: Deleted Images:
    user.local.dev: untagged: apache2:latest
    user.local.dev: deleted: sha256:e8f1b99bf5e2d52e791f20b2e879371e5fa4914257d250edd362ff907ff7c6d0
    user.local.dev: deleted: sha256:84b18da4dd52b676b7ddbd7f870480d86bf4ea5a4eaae12cefcb607a751e92d5
    user.local.dev: deleted: sha256:1443178aebf9d5e7b212fb52b1e574daa30779cb8aaaedc1fcd6aa9b638c2648
    user.local.dev: deleted: sha256:e88f72fd8c8fb5b260e320f7bc72a05e6abc74145c95fa9780f248016fbe110f
    user.local.dev: deleted: sha256:c0099ac2a71e59a1f2cc20c7729234845d59d2e4ce878ab011f281098f133864
    user.local.dev: deleted: sha256:75b34825c7874fb7b2eae56717a686f2c752c2d2d908a916b1ff44b87708148d
    user.local.dev: deleted: sha256:107f6b90eaa2bb6823c538e8b5937b163b543b49ce74749b81b9c7a748071693
    user.local.dev: deleted: sha256:267c00fc09d52c8e64eaa156162159cf3b8592caa7203804f37c654a8e2f9725
    user.local.dev: untagged: ubuntu:18.04
    user.local.dev: untagged: ubuntu@sha256:250cc6f3f3ffc5cdaa9d8f4946ac79821aafb4d3afc93928f0de9336eba21aa4
    user.local.dev: deleted: sha256:549b9b86cb8d75a2b668c21c50ee092716d070f129fd1493f95ab7e43767eab8
    user.local.dev: deleted: sha256:7c52cdc1e32d67e3d5d9f83c95ebe18a58857e68bb6985b0381ebdcec73ff303
    user.local.dev: deleted: sha256:a3c2e83788e20188bb7d720f36ebeef2f111c7b939f1b19aa1b4756791beece0
    user.local.dev: deleted: sha256:61199b56f34827cbab596c63fd6e0ac0c448faa7e026e330994818190852d479
    user.local.dev: deleted: sha256:2dc9f76fb25b31e0ae9d36adce713364c682ba0d2fa70756486e5cedfaf40012
    user.local.dev: Total reclaimed space: 188.3MB
    user.local.dev: WARNING! This will remove:
    user.local.dev:   - all stopped containers
    user.local.dev:   - all networks not used by at least one container
    user.local.dev:   - all volumes not used by at least one container
    user.local.dev:   - all dangling images
    user.local.dev:   - all dangling build cache
    user.local.dev:
    user.local.dev: Are you sure you want to continue? [y/N]
    user.local.dev: Total reclaimed space: 0B
    user.local.dev: docker build -t apache2 .
    user.local.dev: Sending build context to Docker daemon  5.632kB
    user.local.dev: Step 1/6 : FROM ubuntu:18.04
    user.local.dev: 18.04: Pulling from library/ubuntu
    user.local.dev: 2746a4a261c9:
    user.local.dev: Pulling fs layer
    user.local.dev: 4c1d20cdee96: Pulling fs layer
    user.local.dev: 0d3160e1d0de: Pulling fs layer
    user.local.dev: c8e37668deea: Pulling fs layer
    user.local.dev: c8e37668deea: Waiting
    user.local.dev: 0d3160e1d0de: Verifying Checksum
    user.local.dev: 0d3160e1d0de: Download complete
    user.local.dev: 4c1d20cdee96: Verifying Checksum
    user.local.dev: 4c1d20cdee96: Download complete
    user.local.dev: c8e37668deea: Verifying Checksum
    user.local.dev: c8e37668deea: Download complete
    user.local.dev: 2746a4a261c9: Verifying Checksum
    user.local.dev: 2746a4a261c9: Download complete
    user.local.dev: 2746a4a261c9:
    user.local.dev: Pull complete
    user.local.dev: 4c1d20cdee96: Pull complete
    user.local.dev: 0d3160e1d0de: Pull complete
    user.local.dev: c8e37668deea: Pull complete
    user.local.dev: Digest: sha256:250cc6f3f3ffc5cdaa9d8f4946ac79821aafb4d3afc93928f0de9336eba21aa4
    user.local.dev: Status: Downloaded newer image for ubuntu:18.04
    user.local.dev:  ---> 549b9b86cb8d
    user.local.dev: Step 2/6 : RUN apt-get update &&  apt-get -y install apache2
    user.local.dev:  ---> Running in 9d39f5b6482c
    user.local.dev: Get:1 http://archive.ubuntu.com/ubuntu bionic InRelease [242 kB]
    user.local.dev: Get:2 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
    user.local.dev: Get:3 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
    user.local.dev: Get:4 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
    user.local.dev: Get:5 http://security.ubuntu.com/ubuntu bionic-security/multiverse amd64 Packages [6781 B]
    user.local.dev: Get:6 http://archive.ubuntu.com/ubuntu bionic/main amd64 Packages [1344 kB]
    user.local.dev: Get:7 http://security.ubuntu.com/ubuntu bionic-security/main amd64 Packages [761 kB]
    user.local.dev: Get:8 http://archive.ubuntu.com/ubuntu bionic/restricted amd64 Packages [13.5 kB]
    user.local.dev: Get:9 http://archive.ubuntu.com/ubuntu bionic/universe amd64 Packages [11.3 MB]
    user.local.dev: Get:10 http://security.ubuntu.com/ubuntu bionic-security/restricted amd64 Packages [19.2 kB]
    user.local.dev: Get:11 http://security.ubuntu.com/ubuntu bionic-security/universe amd64 Packages [795 kB]
    user.local.dev: Get:12 http://archive.ubuntu.com/ubuntu bionic/multiverse amd64 Packages [186 kB]
    user.local.dev: Get:13 http://archive.ubuntu.com/ubuntu bionic-updates/multiverse amd64 Packages [10.5 kB]
    user.local.dev: Get:14 http://archive.ubuntu.com/ubuntu bionic-updates/restricted amd64 Packages [32.7 kB]
    user.local.dev: Get:15 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 Packages [1057 kB]
    user.local.dev: Get:16 http://archive.ubuntu.com/ubuntu bionic-updates/universe amd64 Packages [1322 kB]
    user.local.dev: Get:17 http://archive.ubuntu.com/ubuntu bionic-backports/universe amd64 Packages [4244 B]
    user.local.dev: Get:18 http://archive.ubuntu.com/ubuntu bionic-backports/main amd64 Packages [2496 B]
    user.local.dev: Fetched 17.4 MB in 26s (675 kB/s)
    user.local.dev: Reading package lists...
    user.local.dev: Reading package lists...
    user.local.dev: Building dependency tree...
    user.local.dev:
    user.local.dev: Reading state information...
    user.local.dev: The following additional packages will be installed:
    user.local.dev:   apache2-bin apache2-data apache2-utils file libapr1 libaprutil1
    user.local.dev:   libaprutil1-dbd-sqlite3 libaprutil1-ldap libasn1-8-heimdal libexpat1
    user.local.dev:   libgdbm-compat4 libgdbm5 libgssapi3-heimdal libhcrypto4-heimdal
    user.local.dev:   libheimbase1-heimdal libheimntlm0-heimdal libhx509-5-heimdal libicu60
    user.local.dev:   libkrb5-26-heimdal libldap-2.4-2 libldap-common liblua5.2-0 libmagic-mgc
    user.local.dev:   libmagic1 libnghttp2-14 libperl5.26 libroken18-heimdal libsasl2-2
    user.local.dev:   libsasl2-modules libsasl2-modules-db libsqlite3-0 libssl1.1 libwind0-heimdal
    user.local.dev:   libxml2 mime-support netbase openssl perl perl-modules-5.26 ssl-cert
    user.local.dev:   xz-utils
    user.local.dev: Suggested packages:
    user.local.dev:   www-browser apache2-doc apache2-suexec-pristine | apache2-suexec-custom ufw
    user.local.dev:   gdbm-l10n libsasl2-modules-gssapi-mit | libsasl2-modules-gssapi-heimdal
    user.local.dev:   libsasl2-modules-ldap libsasl2-modules-otp libsasl2-modules-sql
    user.local.dev:   ca-certificates perl-doc libterm-readline-gnu-perl
    user.local.dev:   | libterm-readline-perl-perl make openssl-blacklist
    user.local.dev: The following NEW packages will be installed:
    user.local.dev:   apache2 apache2-bin apache2-data apache2-utils file libapr1 libaprutil1
    user.local.dev:   libaprutil1-dbd-sqlite3 libaprutil1-ldap libasn1-8-heimdal libexpat1
    user.local.dev:   libgdbm-compat4 libgdbm5 libgssapi3-heimdal libhcrypto4-heimdal
    user.local.dev:   libheimbase1-heimdal libheimntlm0-heimdal libhx509-5-heimdal libicu60
    user.local.dev:   libkrb5-26-heimdal libldap-2.4-2 libldap-common liblua5.2-0 libmagic-mgc
    user.local.dev:   libmagic1 libnghttp2-14 libperl5.26 libroken18-heimdal libsasl2-2
    user.local.dev:   libsasl2-modules libsasl2-modules-db libsqlite3-0 libssl1.1 libwind0-heimdal
    user.local.dev:   libxml2 mime-support netbase openssl perl perl-modules-5.26 ssl-cert
    user.local.dev:   xz-utils
    user.local.dev: 0 upgraded, 42 newly installed, 0 to remove and 0 not upgraded.
    user.local.dev: Need to get 21.0 MB of archives.
    user.local.dev: After this operation, 99.4 MB of additional disk space will be used.
    user.local.dev: Get:1 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 perl-modules-5.26 all 5.26.1-6ubuntu0.3 [2763 kB]
    user.local.dev: Get:2 http://archive.ubuntu.com/ubuntu bionic/main amd64 libgdbm5 amd64 1.14.1-6 [26.0 kB]
    user.local.dev: Get:3 http://archive.ubuntu.com/ubuntu bionic/main amd64 libgdbm-compat4 amd64 1.14.1-6 [6084 B]
    user.local.dev: Get:4 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libperl5.26 amd64 5.26.1-6ubuntu0.3 [3527 kB]
    user.local.dev: Get:5 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 perl amd64 5.26.1-6ubuntu0.3 [201 kB]
    user.local.dev: Get:6 http://archive.ubuntu.com/ubuntu bionic/main amd64 mime-support all 3.60ubuntu1 [30.1 kB]
    user.local.dev: Get:7 http://archive.ubuntu.com/ubuntu bionic/main amd64 libapr1 amd64 1.6.3-2 [90.9 kB]
    user.local.dev: Get:8 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libexpat1 amd64 2.2.5-3ubuntu0.2 [80.5 kB]
    user.local.dev: Get:9 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libssl1.1 amd64 1.1.1-1ubuntu2.1~18.04.5 [1300 kB]
    user.local.dev: Get:10 http://archive.ubuntu.com/ubuntu bionic/main amd64 libaprutil1 amd64 1.6.1-2 [84.4 kB]
    user.local.dev: Get:11 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libsqlite3-0 amd64 3.22.0-1ubuntu0.2 [498 kB]
    user.local.dev: Get:12 http://archive.ubuntu.com/ubuntu bionic/main amd64 libaprutil1-dbd-sqlite3 amd64 1.6.1-2 [10.6 kB]
    user.local.dev: Get:13 http://archive.ubuntu.com/ubuntu bionic/main amd64 libroken18-heimdal amd64 7.5.0+dfsg-1 [41.3 kB]
    user.local.dev: Get:14 http://archive.ubuntu.com/ubuntu bionic/main amd64 libasn1-8-heimdal amd64 7.5.0+dfsg-1 [175 kB]
    user.local.dev: Get:15 http://archive.ubuntu.com/ubuntu bionic/main amd64 libheimbase1-heimdal amd64 7.5.0+dfsg-1 [29.3 kB]
    user.local.dev: Get:16 http://archive.ubuntu.com/ubuntu bionic/main amd64 libhcrypto4-heimdal amd64 7.5.0+dfsg-1 [85.9 kB]
    user.local.dev: Get:17 http://archive.ubuntu.com/ubuntu bionic/main amd64 libwind0-heimdal amd64 7.5.0+dfsg-1 [47.8 kB]
    user.local.dev: Get:18 http://archive.ubuntu.com/ubuntu bionic/main amd64 libhx509-5-heimdal amd64 7.5.0+dfsg-1 [107 kB]
    user.local.dev: Get:19 http://archive.ubuntu.com/ubuntu bionic/main amd64 libkrb5-26-heimdal amd64 7.5.0+dfsg-1 [206 kB]
    user.local.dev: Get:20 http://archive.ubuntu.com/ubuntu bionic/main amd64 libheimntlm0-heimdal amd64 7.5.0+dfsg-1 [14.8 kB]
    user.local.dev: Get:21 http://archive.ubuntu.com/ubuntu bionic/main amd64 libgssapi3-heimdal amd64 7.5.0+dfsg-1 [96.5 kB]
    user.local.dev: Get:22 http://archive.ubuntu.com/ubuntu bionic/main amd64 libsasl2-modules-db amd64 2.1.27~101-g0780600+dfsg-3ubuntu2 [14.8 kB]
    user.local.dev: Get:23 http://archive.ubuntu.com/ubuntu bionic/main amd64 libsasl2-2 amd64 2.1.27~101-g0780600+dfsg-3ubuntu2 [49.2 kB]
    user.local.dev: Get:24 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libldap-common all 2.4.45+dfsg-1ubuntu1.4 [16.9 kB]
    user.local.dev: Get:25 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libldap-2.4-2 amd64 2.4.45+dfsg-1ubuntu1.4 [155 kB]
    user.local.dev: Get:26 http://archive.ubuntu.com/ubuntu bionic/main amd64 libaprutil1-ldap amd64 1.6.1-2 [8764 B]
    user.local.dev: Get:27 http://archive.ubuntu.com/ubuntu bionic/main amd64 liblua5.2-0 amd64 5.2.4-1.1build1 [108 kB]
    user.local.dev: Get:28 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnghttp2-14 amd64 1.30.0-1ubuntu1 [77.8 kB]
    user.local.dev: Get:29 http://archive.ubuntu.com/ubuntu bionic/main amd64 libicu60 amd64 60.2-3ubuntu3 [8054 kB]
    user.local.dev: Get:30 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libxml2 amd64 2.9.4+dfsg1-6.1ubuntu1.2 [663 kB]
    user.local.dev: Get:31 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 apache2-bin amd64 2.4.29-1ubuntu4.11 [1071 kB]
    user.local.dev: Get:32 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 apache2-utils amd64 2.4.29-1ubuntu4.11 [83.9 kB]
    user.local.dev: Get:33 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 apache2-data all 2.4.29-1ubuntu4.11 [160 kB]
    user.local.dev: Get:34 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 apache2 amd64 2.4.29-1ubuntu4.11 [95.1 kB]
    user.local.dev: Get:35 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libmagic-mgc amd64 1:5.32-2ubuntu0.3 [184 kB]
    user.local.dev: Get:36 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libmagic1 amd64 1:5.32-2ubuntu0.3 [68.7 kB]
    user.local.dev: Get:37 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 file amd64 1:5.32-2ubuntu0.3 [22.1 kB]
    user.local.dev: Get:38 http://archive.ubuntu.com/ubuntu bionic/main amd64 netbase all 5.4 [12.7 kB]
    user.local.dev: Get:39 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 openssl amd64 1.1.1-1ubuntu2.1~18.04.5 [613 kB]
    user.local.dev: Get:40 http://archive.ubuntu.com/ubuntu bionic/main amd64 xz-utils amd64 5.2.2-1.3 [83.8 kB]
    user.local.dev: Get:41 http://archive.ubuntu.com/ubuntu bionic/main amd64 libsasl2-modules amd64 2.1.27~101-g0780600+dfsg-3ubuntu2 [48.7 kB]
    user.local.dev: Get:42 http://archive.ubuntu.com/ubuntu bionic/main amd64 ssl-cert all 1.0.39 [17.0 kB]
    user.local.dev: debconf: delaying package configuration, since apt-utils is not installed
    user.local.dev:
    user.local.dev: Fetched 21.0 MB in 1min 14s (285 kB/s)
    user.local.dev: Selecting previously unselected package perl-modules-5.26.
    user.local.dev: (Reading database ...
(Reading database ... 75% (Reading database ... 5%
(Reading database ... 4046 files and directories currently installed.)
    user.local.dev: Preparing to unpack .../00-perl-modules-5.26_5.26.1-6ubuntu0.3_all.deb ...
    user.local.dev: Unpacking perl-modules-5.26 (5.26.1-6ubuntu0.3) ...
    user.local.dev: Selecting previously unselected package libgdbm5:amd64.
    user.local.dev: Preparing to unpack .../01-libgdbm5_1.14.1-6_amd64.deb ...
    user.local.dev: Unpacking libgdbm5:amd64 (1.14.1-6) ...
    user.local.dev: Selecting previously unselected package libgdbm-compat4:amd64.
    user.local.dev: Preparing to unpack .../02-libgdbm-compat4_1.14.1-6_amd64.deb ...
    user.local.dev: Unpacking libgdbm-compat4:amd64 (1.14.1-6) ...
    user.local.dev: Selecting previously unselected package libperl5.26:amd64.
    user.local.dev: Preparing to unpack .../03-libperl5.26_5.26.1-6ubuntu0.3_amd64.deb ...
    user.local.dev: Unpacking libperl5.26:amd64 (5.26.1-6ubuntu0.3) ...
    user.local.dev: Selecting previously unselected package perl.
    user.local.dev: Preparing to unpack .../04-perl_5.26.1-6ubuntu0.3_amd64.deb ...
    user.local.dev: Unpacking perl (5.26.1-6ubuntu0.3) ...
    user.local.dev: Selecting previously unselected package mime-support.
    user.local.dev: Preparing to unpack .../05-mime-support_3.60ubuntu1_all.deb ...
    user.local.dev: Unpacking mime-support (3.60ubuntu1) ...
    user.local.dev: Selecting previously unselected package libapr1:amd64.
    user.local.dev: Preparing to unpack .../06-libapr1_1.6.3-2_amd64.deb ...
    user.local.dev: Unpacking libapr1:amd64 (1.6.3-2) ...
    user.local.dev: Selecting previously unselected package libexpat1:amd64.
    user.local.dev: Preparing to unpack .../07-libexpat1_2.2.5-3ubuntu0.2_amd64.deb ...
    user.local.dev: Unpacking libexpat1:amd64 (2.2.5-3ubuntu0.2) ...
    user.local.dev: Selecting previously unselected package libssl1.1:amd64.
    user.local.dev: Preparing to unpack .../08-libssl1.1_1.1.1-1ubuntu2.1~18.04.5_amd64.deb ...
    user.local.dev: Unpacking libssl1.1:amd64 (1.1.1-1ubuntu2.1~18.04.5) ...
    user.local.dev: Selecting previously unselected package libaprutil1:amd64.
    user.local.dev: Preparing to unpack .../09-libaprutil1_1.6.1-2_amd64.deb ...
    user.local.dev: Unpacking libaprutil1:amd64 (1.6.1-2) ...
    user.local.dev: Selecting previously unselected package libsqlite3-0:amd64.
    user.local.dev: Preparing to unpack .../10-libsqlite3-0_3.22.0-1ubuntu0.2_amd64.deb ...
    user.local.dev: Unpacking libsqlite3-0:amd64 (3.22.0-1ubuntu0.2) ...
    user.local.dev: Selecting previously unselected package libaprutil1-dbd-sqlite3:amd64.
    user.local.dev: Preparing to unpack .../11-libaprutil1-dbd-sqlite3_1.6.1-2_amd64.deb ...
    user.local.dev: Unpacking libaprutil1-dbd-sqlite3:amd64 (1.6.1-2) ...
    user.local.dev: Selecting previously unselected package libroken18-heimdal:amd64.
    user.local.dev: Preparing to unpack .../12-libroken18-heimdal_7.5.0+dfsg-1_amd64.deb ...
    user.local.dev: Unpacking libroken18-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Selecting previously unselected package libasn1-8-heimdal:amd64.
    user.local.dev: Preparing to unpack .../13-libasn1-8-heimdal_7.5.0+dfsg-1_amd64.deb ...
    user.local.dev: Unpacking libasn1-8-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Selecting previously unselected package libheimbase1-heimdal:amd64.
    user.local.dev: Preparing to unpack .../14-libheimbase1-heimdal_7.5.0+dfsg-1_amd64.deb ...
    user.local.dev: Unpacking libheimbase1-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Selecting previously unselected package libhcrypto4-heimdal:amd64.
    user.local.dev: Preparing to unpack .../15-libhcrypto4-heimdal_7.5.0+dfsg-1_amd64.deb ...
    user.local.dev: Unpacking libhcrypto4-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Selecting previously unselected package libwind0-heimdal:amd64.
    user.local.dev: Preparing to unpack .../16-libwind0-heimdal_7.5.0+dfsg-1_amd64.deb ...
    user.local.dev: Unpacking libwind0-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Selecting previously unselected package libhx509-5-heimdal:amd64.
    user.local.dev: Preparing to unpack .../17-libhx509-5-heimdal_7.5.0+dfsg-1_amd64.deb ...
    user.local.dev: Unpacking libhx509-5-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Selecting previously unselected package libkrb5-26-heimdal:amd64.
    user.local.dev: Preparing to unpack .../18-libkrb5-26-heimdal_7.5.0+dfsg-1_amd64.deb ...
    user.local.dev: Unpacking libkrb5-26-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Selecting previously unselected package libheimntlm0-heimdal:amd64.
    user.local.dev: Preparing to unpack .../19-libheimntlm0-heimdal_7.5.0+dfsg-1_amd64.deb ...
    user.local.dev: Unpacking libheimntlm0-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Selecting previously unselected package libgssapi3-heimdal:amd64.
    user.local.dev: Preparing to unpack .../20-libgssapi3-heimdal_7.5.0+dfsg-1_amd64.deb ...
    user.local.dev: Unpacking libgssapi3-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Selecting previously unselected package libsasl2-modules-db:amd64.
    user.local.dev: Preparing to unpack .../21-libsasl2-modules-db_2.1.27~101-g0780600+dfsg-3ubuntu2_amd64.deb ...
    user.local.dev: Unpacking libsasl2-modules-db:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2) ...
    user.local.dev: Selecting previously unselected package libsasl2-2:amd64.
    user.local.dev: Preparing to unpack .../22-libsasl2-2_2.1.27~101-g0780600+dfsg-3ubuntu2_amd64.deb ...
    user.local.dev: Unpacking libsasl2-2:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2) ...
    user.local.dev: Selecting previously unselected package libldap-common.
    user.local.dev: Preparing to unpack .../23-libldap-common_2.4.45+dfsg-1ubuntu1.4_all.deb ...
    user.local.dev: Unpacking libldap-common (2.4.45+dfsg-1ubuntu1.4) ...
    user.local.dev: Selecting previously unselected package libldap-2.4-2:amd64.
    user.local.dev: Preparing to unpack .../24-libldap-2.4-2_2.4.45+dfsg-1ubuntu1.4_amd64.deb ...
    user.local.dev: Unpacking libldap-2.4-2:amd64 (2.4.45+dfsg-1ubuntu1.4) ...
    user.local.dev: Selecting previously unselected package libaprutil1-ldap:amd64.
    user.local.dev: Preparing to unpack .../25-libaprutil1-ldap_1.6.1-2_amd64.deb ...
    user.local.dev: Unpacking libaprutil1-ldap:amd64 (1.6.1-2) ...
    user.local.dev: Selecting previously unselected package liblua5.2-0:amd64.
    user.local.dev: Preparing to unpack .../26-liblua5.2-0_5.2.4-1.1build1_amd64.deb ...
    user.local.dev: Unpacking liblua5.2-0:amd64 (5.2.4-1.1build1) ...
    user.local.dev: Selecting previously unselected package libnghttp2-14:amd64.
    user.local.dev: Preparing to unpack .../27-libnghttp2-14_1.30.0-1ubuntu1_amd64.deb ...
    user.local.dev: Unpacking libnghttp2-14:amd64 (1.30.0-1ubuntu1) ...
    user.local.dev: Selecting previously unselected package libicu60:amd64.
    user.local.dev: Preparing to unpack .../28-libicu60_60.2-3ubuntu3_amd64.deb ...
    user.local.dev: Unpacking libicu60:amd64 (60.2-3ubuntu3) ...
    user.local.dev: Selecting previously unselected package libxml2:amd64.
    user.local.dev: Preparing to unpack .../29-libxml2_2.9.4+dfsg1-6.1ubuntu1.2_amd64.deb ...
    user.local.dev: Unpacking libxml2:amd64 (2.9.4+dfsg1-6.1ubuntu1.2) ...
    user.local.dev: Selecting previously unselected package apache2-bin.
    user.local.dev: Preparing to unpack .../30-apache2-bin_2.4.29-1ubuntu4.11_amd64.deb ...
    user.local.dev: Unpacking apache2-bin (2.4.29-1ubuntu4.11) ...
    user.local.dev: Selecting previously unselected package apache2-utils.
    user.local.dev: Preparing to unpack .../31-apache2-utils_2.4.29-1ubuntu4.11_amd64.deb ...
    user.local.dev: Unpacking apache2-utils (2.4.29-1ubuntu4.11) ...
    user.local.dev: Selecting previously unselected package apache2-data.
    user.local.dev: Preparing to unpack .../32-apache2-data_2.4.29-1ubuntu4.11_all.deb ...
    user.local.dev: Unpacking apache2-data (2.4.29-1ubuntu4.11) ...
    user.local.dev: Selecting previously unselected package apache2.
    user.local.dev: Preparing to unpack .../33-apache2_2.4.29-1ubuntu4.11_amd64.deb ...
    user.local.dev: Unpacking apache2 (2.4.29-1ubuntu4.11) ...
    user.local.dev: Selecting previously unselected package libmagic-mgc.
    user.local.dev: Preparing to unpack .../34-libmagic-mgc_1%3a5.32-2ubuntu0.3_amd64.deb ...
    user.local.dev: Unpacking libmagic-mgc (1:5.32-2ubuntu0.3) ...
    user.local.dev: Selecting previously unselected package libmagic1:amd64.
    user.local.dev: Preparing to unpack .../35-libmagic1_1%3a5.32-2ubuntu0.3_amd64.deb ...
    user.local.dev: Unpacking libmagic1:amd64 (1:5.32-2ubuntu0.3) ...
    user.local.dev: Selecting previously unselected package file.
    user.local.dev: Preparing to unpack .../36-file_1%3a5.32-2ubuntu0.3_amd64.deb ...
    user.local.dev: Unpacking file (1:5.32-2ubuntu0.3) ...
    user.local.dev: Selecting previously unselected package netbase.
    user.local.dev: Preparing to unpack .../37-netbase_5.4_all.deb ...
    user.local.dev: Unpacking netbase (5.4) ...
    user.local.dev: Selecting previously unselected package openssl.
    user.local.dev: Preparing to unpack .../38-openssl_1.1.1-1ubuntu2.1~18.04.5_amd64.deb ...
    user.local.dev: Unpacking openssl (1.1.1-1ubuntu2.1~18.04.5) ...
    user.local.dev: Selecting previously unselected package xz-utils.
    user.local.dev: Preparing to unpack .../39-xz-utils_5.2.2-1.3_amd64.deb ...
    user.local.dev: Unpacking xz-utils (5.2.2-1.3) ...
    user.local.dev: Selecting previously unselected package libsasl2-modules:amd64.
    user.local.dev: Preparing to unpack .../40-libsasl2-modules_2.1.27~101-g0780600+dfsg-3ubuntu2_amd64.deb ...
    user.local.dev: Unpacking libsasl2-modules:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2) ...
    user.local.dev: Selecting previously unselected package ssl-cert.
    user.local.dev: Preparing to unpack .../41-ssl-cert_1.0.39_all.deb ...
    user.local.dev: Unpacking ssl-cert (1.0.39) ...
    user.local.dev: Setting up libapr1:amd64 (1.6.3-2) ...
    user.local.dev: Setting up libexpat1:amd64 (2.2.5-3ubuntu0.2) ...
    user.local.dev: Setting up libicu60:amd64 (60.2-3ubuntu3) ...
    user.local.dev: Setting up libnghttp2-14:amd64 (1.30.0-1ubuntu1) ...
    user.local.dev: Setting up mime-support (3.60ubuntu1) ...
    user.local.dev: Setting up libldap-common (2.4.45+dfsg-1ubuntu1.4) ...
    user.local.dev: Setting up libsasl2-modules-db:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2) ...
    user.local.dev: Setting up libsasl2-2:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2) ...
    user.local.dev: Setting up apache2-data (2.4.29-1ubuntu4.11) ...
    user.local.dev: Setting up libroken18-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Setting up perl-modules-5.26 (5.26.1-6ubuntu0.3) ...
    user.local.dev: Setting up libgdbm5:amd64 (1.14.1-6) ...
    user.local.dev: Setting up libxml2:amd64 (2.9.4+dfsg1-6.1ubuntu1.2) ...
    user.local.dev: Setting up libmagic-mgc (1:5.32-2ubuntu0.3) ...
    user.local.dev: Setting up libmagic1:amd64 (1:5.32-2ubuntu0.3) ...
    user.local.dev: Setting up libssl1.1:amd64 (1.1.1-1ubuntu2.1~18.04.5) ...
    user.local.dev: debconf: unable to initialize frontend: Dialog
    user.local.dev: debconf: (TERM is not set, so the dialog frontend is not usable.)
    user.local.dev: debconf: falling back to frontend: Readline
    user.local.dev: Setting up xz-utils (5.2.2-1.3) ...
    user.local.dev: update-alternatives: using /usr/bin/xz to provide /usr/bin/lzma (lzma) in auto mode
    user.local.dev: update-alternatives: warning:
    user.local.dev: skip creation of /usr/share/man/man1/lzma.1.gz because associated file /usr/share/man/man1/xz.1.gz (of link group lzma) doesn't exist
    user.local.dev: update-alternatives: warning: skip creation of /usr/share/man/man1/unlzma.1.gz because associated file /usr/share/man/man1/unxz.1.gz (of link group lzma) doesn't exist
    user.local.dev: update-alternatives: warning:
    user.local.dev: skip creation of /usr/share/man/man1/lzcat.1.gz because associated file /usr/share/man/man1/xzcat.1.gz (of link group lzma) doesn't exist
    user.local.dev: update-alternatives: warning:
    user.local.dev: skip creation of /usr/share/man/man1/lzmore.1.gz because associated file /usr/share/man/man1/xzmore.1.gz (of link group lzma) doesn't exist
    user.local.dev: update-alternatives: warning:
    user.local.dev: skip creation of /usr/share/man/man1/lzless.1.gz because associated file /usr/share/man/man1/xzless.1.gz (of link group lzma) doesn't exist
    user.local.dev: update-alternatives: warning: skip creation of /usr/share/man/man1/lzdiff.1.gz because associated file /usr/share/man/man1/xzdiff.1.gz (of link group lzma) doesn't exist
    user.local.dev: update-alternatives: warning:
    user.local.dev: skip creation of /usr/share/man/man1/lzcmp.1.gz because associated file /usr/share/man/man1/xzcmp.1.gz (of link group lzma) doesn't exist
    user.local.dev: update-alternatives: warning:
    user.local.dev: skip creation of /usr/share/man/man1/lzgrep.1.gz because associated file /usr/share/man/man1/xzgrep.1.gz (of link group lzma) doesn't exist
    user.local.dev: update-alternatives: warning: skip creation of /usr/share/man/man1/lzegrep.1.gz because associated file /usr/share/man/man1/xzegrep.1.gz (of link group lzma) doesn't exist
    user.local.dev: update-alternatives: warning:
    user.local.dev: skip creation of /usr/share/man/man1/lzfgrep.1.gz because associated file /usr/share/man/man1/xzfgrep.1.gz (of link group lzma) doesn't exist
    user.local.dev: Setting up libaprutil1:amd64 (1.6.1-2) ...
    user.local.dev: Setting up libheimbase1-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Setting up openssl (1.1.1-1ubuntu2.1~18.04.5) ...
    user.local.dev: Setting up libsqlite3-0:amd64 (3.22.0-1ubuntu0.2) ...
    user.local.dev: Setting up liblua5.2-0:amd64 (5.2.4-1.1build1) ...
    user.local.dev: Setting up libgdbm-compat4:amd64 (1.14.1-6) ...
    user.local.dev: Setting up libsasl2-modules:amd64 (2.1.27~101-g0780600+dfsg-3ubuntu2) ...
    user.local.dev: Setting up netbase (5.4) ...
    user.local.dev: Setting up libwind0-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Setting up libaprutil1-dbd-sqlite3:amd64 (1.6.1-2) ...
    user.local.dev: Setting up apache2-utils (2.4.29-1ubuntu4.11) ...
    user.local.dev: Setting up libasn1-8-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Setting up libhcrypto4-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Setting up ssl-cert (1.0.39) ...
    user.local.dev: debconf: unable to initialize frontend: Dialog
    user.local.dev: debconf: (TERM is not set, so the dialog frontend is not usable.)
    user.local.dev: debconf: falling back to frontend: Readline
    user.local.dev: Setting up file (1:5.32-2ubuntu0.3) ...
    user.local.dev: Setting up libhx509-5-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Setting up libperl5.26:amd64 (5.26.1-6ubuntu0.3) ...
    user.local.dev: Setting up libkrb5-26-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Setting up libheimntlm0-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Setting up perl (5.26.1-6ubuntu0.3) ...
    user.local.dev: Setting up libgssapi3-heimdal:amd64 (7.5.0+dfsg-1) ...
    user.local.dev: Setting up libldap-2.4-2:amd64 (2.4.45+dfsg-1ubuntu1.4) ...
    user.local.dev: Setting up libaprutil1-ldap:amd64 (1.6.1-2) ...
    user.local.dev: Setting up apache2-bin (2.4.29-1ubuntu4.11) ...
    user.local.dev: Setting up apache2 (2.4.29-1ubuntu4.11) ...
    user.local.dev: Enabling module mpm_event.
    user.local.dev: Enabling module authz_core.
    user.local.dev: Enabling module authz_host.
    user.local.dev: Enabling module authn_core.
    user.local.dev: Enabling module auth_basic.
    user.local.dev: Enabling module access_compat.
    user.local.dev: Enabling module authn_file.
    user.local.dev: Enabling module authz_user.
    user.local.dev: Enabling module alias.
    user.local.dev: Enabling module dir.
    user.local.dev: Enabling module autoindex.
    user.local.dev: Enabling module env.
    user.local.dev: Enabling module mime.
    user.local.dev: Enabling module negotiation.
    user.local.dev: Enabling module setenvif.
    user.local.dev: Enabling module filter.
    user.local.dev: Enabling module deflate.
    user.local.dev: Enabling module status.
    user.local.dev: Enabling module reqtimeout.
    user.local.dev: Enabling conf charset.
    user.local.dev: Enabling conf localized-error-pages.
    user.local.dev: Enabling conf other-vhosts-access-log.
    user.local.dev: Enabling conf security.
    user.local.dev: Enabling conf serve-cgi-bin.
    user.local.dev: Enabling site 000-default.
    user.local.dev: invoke-rc.d: could not determine current runlevel
    user.local.dev: invoke-rc.d: policy-rc.d denied execution of start.
    user.local.dev: Processing triggers for libc-bin (2.27-3ubuntu1) ...
    user.local.dev: Removing intermediate container 9d39f5b6482c
    user.local.dev:  ---> d10da026d1e1
    user.local.dev: Step 3/6 : RUN echo 'Hello World!' > /var/www/html/index.html
    user.local.dev:  ---> Running in a592b08e2f2a
    user.local.dev: Removing intermediate container a592b08e2f2a
    user.local.dev:  ---> 948674a97617
    user.local.dev: Step 4/6 : RUN echo '. /etc/apache2/envvars' > /root/run_apache.sh &&  echo 'mkdir -p /var/run/apache2' >> /root/run_apache.sh &&  echo 'mkdir -p /var/lock/apache2' >> /root/run_apache.sh &&  echo '/usr/sbin/apache2 -D FOREGROUND' >> /root/run_apache.sh &&  chmod 755 /root/run_apache.sh
    user.local.dev:  ---> Running in a04fdfc48b34
    user.local.dev: Removing intermediate container a04fdfc48b34
    user.local.dev:  ---> 2fa47618c2a0
    user.local.dev: Step 5/6 : EXPOSE 80
    user.local.dev:  ---> Running in 26c439230655
    user.local.dev: Removing intermediate container 26c439230655
    user.local.dev:  ---> 639c77b83c2a
    user.local.dev: Step 6/6 : CMD /root/run_apache.sh
    user.local.dev:  ---> Running in 52bf1830aaf5
    user.local.dev: Removing intermediate container 52bf1830aaf5
    user.local.dev:  ---> 88f848245013
    user.local.dev: Successfully built 88f848245013
    user.local.dev: Successfully tagged apache2:latest
    user.local.dev: docker images --filter reference=apache2
    user.local.dev: REPOSITORY
    user.local.dev:
    user.local.dev:
    user.local.dev: TAG
    user.local.dev:
    user.local.dev:
    user.local.dev:
    user.local.dev: IMAGE ID
    user.local.dev:
    user.local.dev:
    user.local.dev: CREATED
    user.local.dev:
    user.local.dev:
    user.local.dev:
    user.local.dev: SIZE
    user.local.dev: apache2
    user.local.dev:
    user.local.dev:
    user.local.dev: latest
    user.local.dev:
    user.local.dev:
    user.local.dev: 88f848245013
    user.local.dev:
    user.local.dev: Less than a second ago
    user.local.dev:
    user.local.dev: 188MB
    user.local.dev: docker run -t -d -i -p 8889:80 --name apache2 --rm apache2
    user.local.dev: 366966a34ebf6a71f6b5e8bad9e00b4984e2e95f9c9c9cfe3cef19d43453490d
    user.local.dev: CONTAINER ID        IMAGE                                     COMMAND                  CREATED                  STATUS                  PORTS                          NAMES
    user.local.dev: 366966a34ebf        apache2                                   "/bin/sh -c /root/ru…"   Less than a second ago   Up Less than a second   0.0.0.0:8889->80/tcp   apache2
    user.local.dev: open http://localhost:8889 in your browser
    user.local.dev: vagrant ssh -c "docker exec -it apache2 /bin/bash -c "apache2 -t -v""
```
