# HashiCorp
http://www.hashicorp.com

## About
HashiCorp delivers consistent workflows to provision, secure, connect, and run any infrastructure for any application.
HashiCorp was founded by Mitchell Hashimoto and Armon Dadgar in 2012 with the goal of revolutionizing datacenter management: application development, delivery, and maintenance. ... IaaS, PaaS, SaaS. ... Our tools manage both physical machines and virtual machines, Windows, and Linux, SaaS ...

## Vagrant
https://www.vagrantup.com/

HashiCorp Vagrant provides the same, easy workflow regardless of your role as a developer, operator, or designer. It leverages a declarative configuration file which describes all your software requirements, packages, operating system configuration, users, and more.

`vagrant up --provision`
```                                                                                 
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: bootstrap (shell)...
    user.local.dev: Running: inline script
    user.local.dev: BEGIN BOOTSTRAP 2020-01-10 00:44:49
    user.local.dev: running vagrant as user
    user.local.dev: Get:1 https://deb.nodesource.com/node_10.x xenial InRelease [4,584 B]
    ...
    user.local.dev: END BOOTSTRAP 2020-01-10 00:45:53
==> user.local.dev: Running provisioner: docker (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35289-lj8d6b.sh
    ...
    user.local.dev: ++++ open http://localhost:8889 in your browser
    user.local.dev: ++++ you can also run below to get apache2 version from the docker container
    user.local.dev: ++++ vagrant ssh -c "docker exec -it apache2 /bin/bash -c 'apache2 -t -v'"
==> user.local.dev: Running provisioner: terraform (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35289-gf77w9.sh
    ...
    user.local.dev: ++++ Terraform v0.12.18 already installed at /usr/local/bin/terraform
==> user.local.dev: Running provisioner: vault (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35289-igtj7e.sh
    ...
    user.local.dev: ++++ Vault already installed and running
    user.local.dev: ++++ Vault http://localhost:8200/ui and enter the following codes displayed below
    ...
==> user.local.dev: Running provisioner: consul (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35289-u3hjac.sh
    user.local.dev: Reading package lists...
    ...
    user.local.dev: ++++ Adding Consul KV data for Fabio Load Balancer Routes
    user.local.dev: Success! Data written to: fabio/config/vault
    user.local.dev: Success! Data written to: fabio/config/nomad
    user.local.dev: Success! Data written to: fabio/config/consul
    user.local.dev: ++++ Consul http://localhost:8500
==> user.local.dev: Running provisioner: nomad (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35289-1s3k8i2.sh
    ...
    user.local.dev: ++++ Nomad already installed at /usr/local/bin/nomad
    user.local.dev: ++++ Nomad v0.10.2 (0d2d6e3dc5a171c21f8f31fa117c8a765eb4fc02)
    user.local.dev: ++++ cni-plugins already installed
    user.local.dev: ==> Loaded configuration from /etc/nomad/server.conf
    user.local.dev: ==> Starting Nomad agent...
    ...
==> user.local.dev: Running provisioner: packer (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35289-18twg6l.sh
    ...
==> user.local.dev: Running provisioner: sentinel (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35289-18qv6vf.sh
    ...
    user.local.dev: ++++ Sentinel Simulator v0.9.2 already installed at /usr/local/bin/sentinel
    user.local.dev: hour = 4
    user.local.dev: main = rule { hour >= 0 and hour < 12 }
    user.local.dev: ++++ cat /tmp/policy.sentinel
    user.local.dev: hour = 4
    user.local.dev: main = rule { hour >= 0 and hour < 12 }
    user.local.dev: ++++ sentinel apply /tmp/policy.sentinel
    user.local.dev: Pass
==> user.local.dev: Running provisioner: localstack (shell)...
    ...
==> user.local.dev: Running provisioner: docsify (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35289-1du0q9e.sh
    ...
    user.local.dev: ++++ Docsify: http://localhost:3333/
```

## Packer
https://www.packer.io

Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration. Packer is lightweight, runs on every major operating system, and is highly performant, creating machine images for multiple platforms in parallel.

We currently create with Packer:

__Linux__

* Docker: Ubuntu configured with Ansible

### Build Ubuntu Docker-image

__On your Host computer OR in the VM__ please do: <br />
*~/workspace/hashiqube/hashicorp/packer/linux/ubuntu $* `vagrant ssh -c "cd /vagrant/hashicorp/packer/linux/ubuntu; packer build ubuntu16.04.json"`
```
docker: output will be in this color.

==> docker: Creating a temporary directory for sharing data...
==> docker: Pulling Docker image: ubuntu:16.04
    docker: 16.04: Pulling from library/ubuntu
    docker: 3386e6af03b0: Pulling fs layer
    docker: 49ac0bbe6c8e: Pulling fs layer
    docker: d1983a67e104: Pulling fs layer
    docker: 1a0f3a523f04: Pulling fs layer
    docker: 1a0f3a523f04: Waiting
    docker: 49ac0bbe6c8e: Verifying Checksum
    docker: 49ac0bbe6c8e: Download complete
    docker: d1983a67e104: Verifying Checksum
    docker: d1983a67e104: Download complete
    docker: 1a0f3a523f04: Verifying Checksum
    docker: 1a0f3a523f04: Download complete
    docker: 3386e6af03b0: Verifying Checksum
    docker: 3386e6af03b0: Download complete
    docker: 3386e6af03b0: Pull complete
    docker: 49ac0bbe6c8e: Pull complete
    docker: d1983a67e104: Pull complete
    docker: 1a0f3a523f04: Pull complete
    docker: Digest: sha256:181800dada370557133a502977d0e3f7abda0c25b9bbb035f199f5eb6082a114
    docker: Status: Downloaded newer image for ubuntu:16.04
    docker: docker.io/library/ubuntu:16.04
==> docker: Starting docker container...
    docker: Run command: docker run -v /home/vagrant/.packer.d/tmp020519102:/packer-files -d -i -t --name default ubuntu:16.04 /bin/bash
    docker: Container ID: e377a38c8c09fc55c3ac85a61357c2125323d85a4582ab20814a44771145c0bc
==> docker: Using docker communicator to connect: 172.17.0.7
==> docker: Provisioning with shell script: /tmp/packer-shell695982158
    docker: Get:1 http://security.ubuntu.com/ubuntu xenial-security InRelease [109 kB]
    docker: Get:2 http://archive.ubuntu.com/ubuntu xenial InRelease [247 kB]
    docker: Get:3 http://archive.ubuntu.com/ubuntu xenial-updates InRelease [109 kB]
    docker: Get:4 http://security.ubuntu.com/ubuntu xenial-security/main amd64 Packages [1031 kB]
    docker: Get:5 http://archive.ubuntu.com/ubuntu xenial-backports InRelease [107 kB]
    docker: Get:6 http://security.ubuntu.com/ubuntu xenial-security/restricted amd64 Packages [12.7 kB]
    docker: Get:7 http://security.ubuntu.com/ubuntu xenial-security/universe amd64 Packages [595 kB]
    docker: Get:8 http://security.ubuntu.com/ubuntu xenial-security/multiverse amd64 Packages [6280 B]
    docker: Get:9 http://archive.ubuntu.com/ubuntu xenial/main amd64 Packages [1558 kB]
    docker: Get:10 http://archive.ubuntu.com/ubuntu xenial/restricted amd64 Packages [14.1 kB]
    docker: Get:11 http://archive.ubuntu.com/ubuntu xenial/universe amd64 Packages [9827 kB]
    docker: Get:12 http://archive.ubuntu.com/ubuntu xenial/multiverse amd64 Packages [176 kB]
    docker: Get:13 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 Packages [1408 kB]
    docker: Get:14 http://archive.ubuntu.com/ubuntu xenial-updates/restricted amd64 Packages [13.1 kB]
    docker: Get:15 http://archive.ubuntu.com/ubuntu xenial-updates/universe amd64 Packages [998 kB]
    docker: Get:16 http://archive.ubuntu.com/ubuntu xenial-updates/multiverse amd64 Packages [19.3 kB]
    docker: Get:17 http://archive.ubuntu.com/ubuntu xenial-backports/main amd64 Packages [7942 B]
    docker: Get:18 http://archive.ubuntu.com/ubuntu xenial-backports/universe amd64 Packages [8807 B]
    docker: Fetched 16.2 MB in 19s (842 kB/s)
    docker: Reading package lists...
    docker: Reading package lists...
    docker: Building dependency tree...
    docker: Reading state information...
    docker: The following additional packages will be installed:
    docker:   file libapt-inst2.0 libexpat1 libffi6 libmagic1 libpython-stdlib
    docker:   libpython2.7-minimal libpython2.7-stdlib libsqlite3-0 libssl1.0.0
    docker:   mime-support python-minimal python2.7 python2.7-minimal
    docker: Suggested packages:
    docker:   python-doc python-tk python2.7-doc binutils binfmt-support
    docker: The following NEW packages will be installed:
    docker:   apt-utils file libapt-inst2.0 libexpat1 libffi6 libmagic1 libpython-stdlib
    docker:   libpython2.7-minimal libpython2.7-stdlib libsqlite3-0 libssl1.0.0
    docker:   mime-support python python-minimal python2.7 python2.7-minimal
    docker: 0 upgraded, 16 newly installed, 0 to remove and 0 not upgraded.
    docker: Need to get 5971 kB of archives.
    docker: After this operation, 27.0 MB of additional disk space will be used.
    docker: Get:1 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libpython2.7-minimal amd64 2.7.12-1ubuntu0~16.04.9 [338 kB]
    docker: Get:2 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 python2.7-minimal amd64 2.7.12-1ubuntu0~16.04.9 [1262 kB]
    docker: Get:3 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 python-minimal amd64 2.7.12-1~16.04 [28.1 kB]
    docker: Get:4 http://archive.ubuntu.com/ubuntu xenial/main amd64 mime-support all 3.59ubuntu1 [31.0 kB]
    docker: Get:5 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libexpat1 amd64 2.1.0-7ubuntu0.16.04.5 [71.5 kB]
    docker: Get:6 http://archive.ubuntu.com/ubuntu xenial/main amd64 libffi6 amd64 3.2.1-4 [17.8 kB]
    docker: Get:7 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libsqlite3-0 amd64 3.11.0-1ubuntu1.3 [397 kB]
    docker: Get:8 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libssl1.0.0 amd64 1.0.2g-1ubuntu4.15 [1084 kB]
    docker: Get:9 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libpython2.7-stdlib amd64 2.7.12-1ubuntu0~16.04.9 [1884 kB]
    docker: Get:10 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 python2.7 amd64 2.7.12-1ubuntu0~16.04.9 [224 kB]
    docker: Get:11 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libpython-stdlib amd64 2.7.12-1~16.04 [7768 B]
    docker: Get:12 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 python amd64 2.7.12-1~16.04 [137 kB]
    docker: Get:13 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libapt-inst2.0 amd64 1.2.32 [55.8 kB]
    docker: Get:14 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 apt-utils amd64 1.2.32 [196 kB]
    docker: Get:15 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 libmagic1 amd64 1:5.25-2ubuntu1.3 [216 kB]
    docker: Get:16 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 file amd64 1:5.25-2ubuntu1.3 [21.3 kB]
==> docker: debconf: delaying package configuration, since apt-utils is not installed
    docker: Fetched 5971 kB in 38s (155 kB/s)
    docker: Selecting previously unselected package libpython2.7-minimal:amd64.
    docker: (Reading database ... 4781 files and directories currently installed.)
    docker: Preparing to unpack .../libpython2.7-minimal_2.7.12-1ubuntu0~16.04.9_amd64.deb ...
    docker: Unpacking libpython2.7-minimal:amd64 (2.7.12-1ubuntu0~16.04.9) ...
    docker: Selecting previously unselected package python2.7-minimal.
    docker: Preparing to unpack .../python2.7-minimal_2.7.12-1ubuntu0~16.04.9_amd64.deb ...
    docker: Unpacking python2.7-minimal (2.7.12-1ubuntu0~16.04.9) ...
    docker: Selecting previously unselected package python-minimal.
    docker: Preparing to unpack .../python-minimal_2.7.12-1~16.04_amd64.deb ...
    docker: Unpacking python-minimal (2.7.12-1~16.04) ...
    docker: Selecting previously unselected package mime-support.
    docker: Preparing to unpack .../mime-support_3.59ubuntu1_all.deb ...
    docker: Unpacking mime-support (3.59ubuntu1) ...
    docker: Selecting previously unselected package libexpat1:amd64.
    docker: Preparing to unpack .../libexpat1_2.1.0-7ubuntu0.16.04.5_amd64.deb ...
    docker: Unpacking libexpat1:amd64 (2.1.0-7ubuntu0.16.04.5) ...
    docker: Selecting previously unselected package libffi6:amd64.
    docker: Preparing to unpack .../libffi6_3.2.1-4_amd64.deb ...
    docker: Unpacking libffi6:amd64 (3.2.1-4) ...
    docker: Selecting previously unselected package libsqlite3-0:amd64.
    docker: Preparing to unpack .../libsqlite3-0_3.11.0-1ubuntu1.3_amd64.deb ...
    docker: Unpacking libsqlite3-0:amd64 (3.11.0-1ubuntu1.3) ...
    docker: Selecting previously unselected package libssl1.0.0:amd64.
    docker: Preparing to unpack .../libssl1.0.0_1.0.2g-1ubuntu4.15_amd64.deb ...
    docker: Unpacking libssl1.0.0:amd64 (1.0.2g-1ubuntu4.15) ...
    docker: Selecting previously unselected package libpython2.7-stdlib:amd64.
    docker: Preparing to unpack .../libpython2.7-stdlib_2.7.12-1ubuntu0~16.04.9_amd64.deb ...
    docker: Unpacking libpython2.7-stdlib:amd64 (2.7.12-1ubuntu0~16.04.9) ...
    docker: Selecting previously unselected package python2.7.
    docker: Preparing to unpack .../python2.7_2.7.12-1ubuntu0~16.04.9_amd64.deb ...
    docker: Unpacking python2.7 (2.7.12-1ubuntu0~16.04.9) ...
    docker: Selecting previously unselected package libpython-stdlib:amd64.
    docker: Preparing to unpack .../libpython-stdlib_2.7.12-1~16.04_amd64.deb ...
    docker: Unpacking libpython-stdlib:amd64 (2.7.12-1~16.04) ...
    docker: Processing triggers for libc-bin (2.23-0ubuntu11) ...
    docker: Setting up libpython2.7-minimal:amd64 (2.7.12-1ubuntu0~16.04.9) ...
    docker: Setting up python2.7-minimal (2.7.12-1ubuntu0~16.04.9) ...
    docker: Linking and byte-compiling packages for runtime python2.7...
    docker: Setting up python-minimal (2.7.12-1~16.04) ...
    docker: Selecting previously unselected package python.
    docker: (Reading database ... 5592 files and directories currently installed.)
    docker: Preparing to unpack .../python_2.7.12-1~16.04_amd64.deb ...
    docker: Unpacking python (2.7.12-1~16.04) ...
    docker: Selecting previously unselected package libapt-inst2.0:amd64.
    docker: Preparing to unpack .../libapt-inst2.0_1.2.32_amd64.deb ...
    docker: Unpacking libapt-inst2.0:amd64 (1.2.32) ...
    docker: Selecting previously unselected package apt-utils.
    docker: Preparing to unpack .../apt-utils_1.2.32_amd64.deb ...
    docker: Unpacking apt-utils (1.2.32) ...
    docker: Selecting previously unselected package libmagic1:amd64.
    docker: Preparing to unpack .../libmagic1_1%3a5.25-2ubuntu1.3_amd64.deb ...
    docker: Unpacking libmagic1:amd64 (1:5.25-2ubuntu1.3) ...
    docker: Selecting previously unselected package file.
    docker: Preparing to unpack .../file_1%3a5.25-2ubuntu1.3_amd64.deb ...
    docker: Unpacking file (1:5.25-2ubuntu1.3) ...
    docker: Processing triggers for libc-bin (2.23-0ubuntu11) ...
    docker: Setting up mime-support (3.59ubuntu1) ...
    docker: Setting up libexpat1:amd64 (2.1.0-7ubuntu0.16.04.5) ...
    docker: Setting up libffi6:amd64 (3.2.1-4) ...
    docker: Setting up libsqlite3-0:amd64 (3.11.0-1ubuntu1.3) ...
    docker: Setting up libssl1.0.0:amd64 (1.0.2g-1ubuntu4.15) ...
    docker: debconf: unable to initialize frontend: Dialog
    docker: debconf: (TERM is not set, so the dialog frontend is not usable.)
    docker: debconf: falling back to frontend: Readline
    docker: debconf: unable to initialize frontend: Readline
    docker: debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.22.1 /usr/local/share/perl/5.22.1 /usr/lib/x86_64-linux-gnu/perl5/5.22 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl/5.22 /usr/share/perl/5.22 /usr/local/lib/site_perl /usr/lib/x86_64-linux-gnu/perl-base .) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
    docker: debconf: falling back to frontend: Teletype
    docker: Setting up libpython2.7-stdlib:amd64 (2.7.12-1ubuntu0~16.04.9) ...
    docker: Setting up python2.7 (2.7.12-1ubuntu0~16.04.9) ...
    docker: Setting up libpython-stdlib:amd64 (2.7.12-1~16.04) ...
    docker: Setting up python (2.7.12-1~16.04) ...
    docker: Setting up libapt-inst2.0:amd64 (1.2.32) ...
    docker: Setting up apt-utils (1.2.32) ...
    docker: Setting up libmagic1:amd64 (1:5.25-2ubuntu1.3) ...
    docker: Setting up file (1:5.25-2ubuntu1.3) ...
    docker: Processing triggers for libc-bin (2.23-0ubuntu11) ...
==> docker: Provisioning with Ansible...
==> docker: Executing Ansible: *****a*****n*****s*****i*****b*****l*****e*****-*****p*****l*****a*****y*****b*****o*****o*****k***** *****-*****-*****e*****x*****t*****r*****a*****-*****v*****a*****r*****s***** *****p*****a*****c*****k*****e*****r*****_*****b*****u*****i*****l*****d*****_*****n*****a*****m*****e*****=*****d*****o*****c*****k*****e*****r***** *****p*****a*****c*****k*****e*****r*****_*****b*****u*****i*****l*****d*****e*****r*****_*****t*****y*****p*****e*****=*****d*****o*****c*****k*****e*****r***** *****-*****o***** *****I*****d*****e*****n*****t*****i*****t*****i*****e*****s*****O*****n*****l*****y*****=*****y*****e*****s***** *****-*****i***** *****/*****t*****m*****p*****/*****p*****a*****c*****k*****e*****r*****-*****p*****r*****o*****v*****i*****s*****i*****o*****n*****e*****r*****-*****a*****n*****s*****i*****b*****l*****e*****5*****7*****2*****7*****8*****3*****2*****8*****6***** *****/*****v*****a*****g*****r*****a*****n*****t*****/*****h*****a*****s*****h*****i*****c*****o*****r*****p*****/*****p*****a*****c*****k*****e*****r*****/*****l*****i*****n*****u*****x*****/*****u*****b*****u*****n*****t*****u*****/*****p*****l*****a*****y*****b*****o*****o*****k*****.*****y*****m*****l***** *****-*****e***** *****a*****n*****s*****i*****b*****l*****e*****_*****s*****s*****h*****_*****p*****r*****i*****v*****a*****t*****e*****_*****k*****e*****y*****_*****f*****i*****l*****e*****=*****/*****t*****m*****p*****/*****a*****n*****s*****i*****b*****l*****e*****-*****k*****e*****y*****9*****3*****3*****0*****2*****8*****8*****5*****1***** *****-*****-*****e*****x*****t*****r*****a*****-*****v*****a*****r*****s***** *****a*****n*****s*****i*****b*****l*****e*****_*****h*****o*****s*****t*****=*****d*****e*****f*****a*****u*****l*****t***** *****a*****n*****s*****i*****b*****l*****e*****_*****c*****o*****n*****n*****e*****c*****t*****i*****o*****n*****=*****d*****o*****c*****k*****e*****r*****
    docker:
    docker: PLAY [A demo to run ansible in a docker container] *****************************
    docker:
    docker: TASK [Gathering Facts] *********************************************************
    docker: ok: [default]
    docker:
    docker: TASK [Add a file to root's home dir] *******************************************
    docker: changed: [default]
    docker:
    docker: PLAY RECAP *********************************************************************
    docker: default                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    docker:
==> docker: Killing the container: e377a38c8c09fc55c3ac85a61357c2125323d85a4582ab20814a44771145c0bc
Build 'docker' finished.

==> Builds finished. The artifacts of successful builds are:
--> docker: Exported Docker file:
```

## Terraform
https://www.terraform.io/

Terraform is an open-source infrastructure as code software tool created by HashiCorp. It enables users to define and provision a datacenter infrastructure using a high-level configuration language known as Hashicorp Configuration Language, or optionally JSON.

`terraform plan`
```
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

null_resource.ec2_instance_disk_allocations_indexed["3"]: Refreshing state... [id=8937245650602921629]
null_resource.ec2_instance_disk_allocations_indexed["5"]: Refreshing state... [id=7730763927227710655]
null_resource.ec2_instance_disk_allocations_indexed["1"]: Refreshing state... [id=2667993646128215089]
null_resource.ec2_instance_disk_allocations_indexed["2"]: Refreshing state... [id=2799175647628082337]
null_resource.ec2_instance_disk_allocations_indexed["4"]: Refreshing state... [id=3516596870015825764]
null_resource.ec2_instance_disk_allocations_indexed["0"]: Refreshing state... [id=2638599405833480007]
aws_s3_bucket.localstack-s3-bucket: Refreshing state... [id=localstack-s3-bucket]

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.localstack-s3-bucket will be created
  + resource "aws_s3_bucket" "localstack-s3-bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "public-read"
      + arn                         = (known after apply)
      + bucket                      = "localstack-s3-bucket"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

## Vault
https://www.vaultproject.io/

Manage Secrets and Protect Sensitive Data.
Secure, store and tightly control access to tokens, passwords, certificates, encryption keys for protecting secrets and other sensitive data using a UI, CLI, or HTTP API.

`vagrant up --provision-with vault`  
```                                                                     
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: vault (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35357-1112dsr.sh
    user.local.dev: Reading package lists...
    user.local.dev: Building dependency tree...
    user.local.dev:
    user.local.dev: Reading state information...
    user.local.dev: unzip is already the newest version (6.0-20ubuntu1).
    user.local.dev: curl is already the newest version (7.47.0-1ubuntu2.14).
    user.local.dev: jq is already the newest version (1.5+dfsg-1ubuntu0.1).
    user.local.dev: 0 upgraded, 0 newly installed, 0 to remove and 4 not upgraded.
    user.local.dev: sed: -e expression #1, char 34: unknown option to `s'
    user.local.dev: ++++ Vault already installed and running
    user.local.dev: ++++ Vault http://localhost:8200/ui and enter the following codes displayed below
    user.local.dev: ++++ Auto unseal vault
    user.local.dev: Key             Value
    user.local.dev: ---             ----
    user.local.dev: -
    user.local.dev: Seal Type       shamir
    user.local.dev: Initialize
    user.local.dev: d     true
    user.local.dev: Sealed          false
    user.local.dev: Total Shares    5
    user.local.dev: Threshold       3
    user.local.dev: Version         1.3.1
    user.local.dev: Cluster Name    vault
    user.local.dev: Cluster ID      11fa4aed
    user.local.dev: -dc06-2d64-5429-7fadc5d8473a
    user.local.dev: HA Enabled      false
    user.local.dev: Key             Value
    user.local.dev: ---             -----
    user.local.dev: Seal Type       shamir
    user.local.dev: Initialized
    user.local.dev:   true
    user.local.dev: Sealed          false
    user.local.dev: Total
    user.local.dev: Shares    5
    user.local.dev: Threshold       3
    user.local.dev: Version         1.3.1
    user.local.dev: Cluster Name    vault
    user.local.dev: Cluster ID      11fa4aed-dc06-2d6
    user.local.dev: Unseal Key 1: XsVFkqDcG7JCXaAYHEUcg1VrKE6uO7Zs90FV9XqL7S1X
    user.local.dev: Unseal Key 2: eUNVAQbFxbGTkQ0rdT1RRp1E/hdgMVmOXCTyddsYOzOV
    user.local.dev: Unseal Key 3: eaIbXrTA+VA/g7/Tm1iCdfzajjRSx6k1xfIUHvd/IiKp
    user.local.dev: Unseal Key 4: 7lcRnPqLaQiopY3NFCcRAfUHc9shxHTqmUXjzsxAQdbr
    user.local.dev: Unseal Key 5: l9GpctLEhzOS1O9K2qk09B3vFU85PUC1s8KWHKNYplj8
    user.local.dev:
    user.local.dev: Initial Root Token: s.rrftkbzQ8XBKVTijFyxaRWkH
    user.local.dev:
    user.local.dev: Vault initialized with 5 key shares and a key threshold of 3. Please securely
    user.local.dev: distribute the key shares printed above. When the Vault is re-sealed,
    user.local.dev: restarted, or stopped, you must supply at least 3 of these keys to unseal it
    user.local.dev: before it can start servicing requests.
    user.local.dev:
    user.local.dev: Vault does not store the generated master key. Without at least 3 key to
    user.local.dev: reconstruct the master key, Vault will remain permanently sealed!
    user.local.dev:
    user.local.dev: It is possible to generate new unseal keys, provided you have a quorum of
    user.local.dev: existing unseal keys shares. See "vault operator rekey" for more information.
```
![Vault](images/vault.png?raw=true "Vault")

## Nomad
https://www.nomadproject.io/

Nomad is a highly available, distributed, data-center aware cluster and application scheduler designed to support the modern datacenter with support for

`vagrant up --provision-with nomad`
```                                                                        
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: A newer version of the box 'ubuntu/xenial64' for provider 'virtualbox' is
==> user.local.dev: available! You currently have version '20190918.0.0'. The latest is version
==> user.local.dev: '20200108.0.0'. Run `vagrant box update` to update.
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: nomad (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35617-1o32nkl.sh
    ...
    user.local.dev: ++++ Nomad already installed at /usr/local/bin/nomad
    user.local.dev: ++++ Nomad v0.10.2 (0d2d6e3dc5a171c21f8f31fa117c8a765eb4fc02)
    user.local.dev: ++++ cni-plugins already installed
    user.local.dev: ==> Loaded configuration from /etc/nomad/server.conf
    user.local.dev: ==> Starting Nomad agent...
    user.local.dev: ==> Nomad agent configuration:
    user.local.dev:
    user.local.dev:        Advertise Addrs: HTTP: 10.9.99.10:4646; RPC: 10.9.99.10:4647; Serf: 10.9.99.10:5648
    user.local.dev:             Bind Addrs: HTTP: 0.0.0.0:4646; RPC: 0.0.0.0:4647; Serf: 0.0.0.0:4648
    user.local.dev:                 Client: true
    user.local.dev:              Log Level: DEBUG
    user.local.dev:                 Region: global (DC: dc1)
    user.local.dev:                 Server: true
    user.local.dev:                Version: 0.10.2
    user.local.dev:
    user.local.dev: ==> Nomad agent started! Log data will stream in below:
    ...
    user.local.dev: ==> Evaluation "8d2f35bc" finished with status "complete"
    user.local.dev: + Job: "fabio"
    user.local.dev: + Task Group: "fabio" (1 create)
    user.local.dev:   + Task: "fabio" (forces create)
    user.local.dev: Scheduler dry-run:
    user.local.dev: - All tasks successfully allocated.
    user.local.dev: Job Modify Index: 0
    user.local.dev: To submit the job with version verification run:
    user.local.dev:
    user.local.dev: nomad job run -check-index 0 fabio.nomad
    user.local.dev:
    user.local.dev: When running the job with the check-index flag, the job will only be run if the
    user.local.dev: server side version matches the job modify index returned. If the index has
    user.local.dev: changed, another user has modified the job and the plan's results are
    user.local.dev: potentially invalid.
    user.local.dev: ==> Monitoring evaluation "4f53b332"
    user.local.dev:     Evaluation triggered by job "fabio"
    user.local.dev:     Allocation "636be5f5" created: node "63efd16b", group "fabio"
    user.local.dev:     Evaluation status changed: "pending" -> "complete"
    user.local.dev: ==> Evaluation "4f53b332" finished with status "complete"
    user.local.dev: ++++ Nomad http://localhost:4646
```
![Nomad](images/nomad.png?raw=true "Nomad")

## Consul
https://www.consul.io/

Consul is a service networking solution to connect and secure services across any runtime platform and public or private cloud

### Consul DNS
To use Consul as a DNS resolver from your laptop, you can create the following file<br />
`/etc/resolver/consul`
```
nameserver 10.9.99.10
port 8600
```
Now names such as `nomad.service.consul` and `fabio.service.consul` will work

`vagrant up --provision-with consul`                                                                      
```
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: consul (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35654-11zwf6z.sh
    user.local.dev: Reading package lists...
    user.local.dev: Building dependency tree...
    user.local.dev: Reading state information...
    user.local.dev: unzip is already the newest version (6.0-20ubuntu1).
    user.local.dev: curl is already the newest version (7.47.0-1ubuntu2.14).
    user.local.dev: jq is already the newest version (1.5+dfsg-1ubuntu0.1).
    user.local.dev: 0 upgraded, 0 newly installed, 0 to remove and 4 not upgraded.
    user.local.dev: primary_datacenter = "dc1"
    user.local.dev: client_addr = "10.9.99.10 127.0.0.1 ::1"
    user.local.dev: bind_addr = "0.0.0.0"
    user.local.dev: data_dir = "/var/lib/consul"
    user.local.dev: datacenter = "dc1"
    user.local.dev: disable_host_node_id = true
    user.local.dev: disable_update_check = true
    user.local.dev: leave_on_terminate = true
    user.local.dev: log_level = "INFO"
    user.local.dev: ports = {
    user.local.dev:   grpc  = 8502
    user.local.dev:   dns   = 8600
    user.local.dev:   https = -1
    user.local.dev: }
    user.local.dev: protocol = 3
    user.local.dev: raft_protocol = 3
    user.local.dev: recursors = [
    user.local.dev:   "8.8.8.8",
    user.local.dev:   "8.8.4.4",
    user.local.dev: ]
    user.local.dev: server_name = "consul.service.consul"
    user.local.dev: ui = true
    user.local.dev: ++++ Consul already installed at /usr/local/bin/consul
    user.local.dev: ++++ Consul v1.6.2
    user.local.dev: Protocol 2 spoken by default, understands 2 to 3 (agent will automatically use protocol >2 when speaking to compatible agents)
    user.local.dev: ==> Starting Consul agent...
    user.local.dev:            Version: 'v1.6.2'
    user.local.dev:            Node ID: '3e943a0a-d73e-5797-cb3e-f3dc2e6df832'
    user.local.dev:          Node name: 'user'
    user.local.dev:         Datacenter: 'dc1' (Segment: '<all>')
    user.local.dev:             Server: true (Bootstrap: false)
    user.local.dev:        Client Addr: [0.0.0.0] (HTTP: 8500, HTTPS: -1, gRPC: 8502, DNS: 8600)
    user.local.dev:       Cluster Addr: 10.9.99.10 (LAN: 8301, WAN: 8302)
    user.local.dev:            Encrypt: Gossip: false, TLS-Outgoing: false, TLS-Incoming: false, Auto-Encrypt-TLS: false
    user.local.dev:
    user.local.dev: ==> Log data will now stream in as it occurs:
    user.local.dev:
    user.local.dev:     2020/01/10 04:13:07 [INFO]  raft: Initial configuration (index=1): [{Suffrage:Voter ID:3e943a0a-d73e-5797-cb3e-f3dc2e6df832 Address:10.9.99.10:8300}]
    user.local.dev:     2020/01/10 04:13:07 [INFO] serf: EventMemberJoin: user.dc1 10.9.99.10
    user.local.dev:     2020/01/10 04:13:07 [INFO] serf: EventMemberJoin: user 10.9.99.10
    user.local.dev:     2020/01/10 04:13:07 [INFO]  raft: Node at 10.9.99.10:8300 [Follower] entering Follower state (Leader: "")
    user.local.dev:     2020/01/10 04:13:07 [INFO] consul: Handled member-join event for server "user.dc1" in area "wan"
    user.local.dev:     2020/01/10 04:13:07 [INFO] consul: Adding LAN server user (Addr: tcp/10.9.99.10:8300) (DC: dc1)
    user.local.dev:     2020/01/10 04:13:07 [INFO] agent: Started DNS server 0.0.0.0:8600 (udp)
    user.local.dev:     2020/01/10 04:13:07 [INFO] agent: Started DNS server 0.0.0.0:8600 (tcp)
    user.local.dev:     2020/01/10 04:13:07 [INFO] agent: Started HTTP server on [::]:8500 (tcp)
    user.local.dev:     2020/01/10 04:13:07 [INFO] agent: Started gRPC server on [::]:8502 (tcp)
    user.local.dev:     2020/01/10 04:13:07 [INFO] agent: started state syncer
    user.local.dev: ==> Consul agent running!
    user.local.dev:     2020/01/10 04:13:07 [WARN]  raft: Heartbeat timeout from "" reached, starting election
    user.local.dev:     2020/01/10 04:13:07 [INFO]  raft: Node at 10.9.99.10:8300 [Candidate] entering Candidate state in term 2
    user.local.dev:     2020/01/10 04:13:07 [INFO]  raft: Election won. Tally: 1
    user.local.dev:     2020/01/10 04:13:07 [INFO]  raft: Node at 10.9.99.10:8300 [Leader] entering Leader state
    user.local.dev:     2020/01/10 04:13:07 [INFO] consul: cluster leadership acquired
    user.local.dev:     2020/01/10 04:13:07 [INFO] consul: New leader elected: user
    user.local.dev:     2020/01/10 04:13:07 [INFO] connect: initialized primary datacenter CA with provider "consul"
    user.local.dev:     2020/01/10 04:13:07 [INFO] consul: member 'user' joined, marking health alive
    user.local.dev:     2020/01/10 04:13:07 [INFO] agent: Synced service "_nomad-server-4rgldggulg5f54ypvl4pfyqeijtqd3u4"
    user.local.dev: /tmp/vagrant-shell: line 4: 19556 Terminated              sh -c 'sudo tail -f /var/log/consul.log | { sed "/agent: Synced/ q" && kill $$ ;}'
    user.local.dev: Node        Address          Status  Type    Build  Protocol  DC   Segment
    user.local.dev: user  10.9.99.10:8301  alive   server  1.6.2  3         dc1  <all>
    user.local.dev: agent:
    user.local.dev: 	check_monitors = 0
    user.local.dev: 	check_ttls = 1
    user.local.dev: 	checks = 11
    user.local.dev: 	services = 11
    user.local.dev: build:
    user.local.dev: 	prerelease =
    user.local.dev: 	revision = 1200f25e
    user.local.dev: 	version = 1.6.2
    user.local.dev: consul:
    user.local.dev: 	acl = disabled
    user.local.dev: 	bootstrap = false
    user.local.dev: 	known_datacenters = 1
    user.local.dev: 	leader = true
    user.local.dev: 	leader_addr = 10.9.99.10:8300
    user.local.dev: 	server = true
    user.local.dev: raft:
    user.local.dev: 	applied_index = 24
    user.local.dev: 	commit_index = 24
    user.local.dev: 	fsm_pending = 0
    user.local.dev: 	last_contact = 0
    user.local.dev: 	last_log_index = 24
    user.local.dev: 	last_log_term = 2
    user.local.dev: 	last_snapshot_index = 0
    user.local.dev: 	last_snapshot_term = 0
    user.local.dev: 	latest_configuration = [{Suffrage:Voter ID:3e943a0a-d73e-5797-cb3e-f3dc2e6df832 Address:10.9.99.10:8300}]
    user.local.dev: 	latest_configuration_index = 1
    user.local.dev: 	num_peers = 0
    user.local.dev: 	protocol_version = 3
    user.local.dev: 	protocol_version_max = 3
    user.local.dev: 	protocol_version_min = 0
    user.local.dev: 	snapshot_version_max = 1
    user.local.dev: 	snapshot_version_min = 0
    user.local.dev: 	state = Leader
    user.local.dev: 	term = 2
    user.local.dev: runtime:
    user.local.dev: 	arch = amd64
    user.local.dev: 	cpu_count = 2
    user.local.dev: 	goroutines = 115
    user.local.dev:
    user.local.dev: 	max_procs = 2
    user.local.dev: 	os = linux
    user.local.dev: 	version = go1.12.13
    user.local.dev: serf_lan:
    user.local.dev: 	coordinate_resets = 0
    user.local.dev: 	encrypted = false
    user.local.dev: 	event_queue = 1
    user.local.dev: 	event_time = 2
    user.local.dev: 	failed = 0
    user.local.dev: 	health_score = 0
    user.local.dev: 	intent_queue = 0
    user.local.dev: 	left = 0
    user.local.dev: 	member_time = 1
    user.local.dev: 	members = 1
    user.local.dev: 	query_queue = 0
    user.local.dev: 	query_time = 1
    user.local.dev: serf_wan:
    user.local.dev: 	coordinate_resets = 0
    user.local.dev: 	encrypted = false
    user.local.dev: 	event_queue = 0
    user.local.dev: 	event_time = 1
    user.local.dev: 	failed = 0
    user.local.dev: 	health_score = 0
    user.local.dev: 	intent_queue = 0
    user.local.dev: 	left = 0
    user.local.dev: 	member_time = 1
    user.local.dev: 	members = 1
    user.local.dev: 	query_queue = 0
    user.local.dev: 	query_time = 1
    user.local.dev: ++++ Adding Consul KV data for Fabio Load Balancer Routes
    user.local.dev: Success! Data written to: fabio/config/vault
    user.local.dev: Success! Data written to: fabio/config/nomad
    user.local.dev: Success! Data written to: fabio/config/consul
    user.local.dev: ++++ Consul http://localhost:8500
```    
![Consul](images/consul.png?raw=true "Consul")

## Sentinel
https://docs.hashicorp.com/sentinel/

Sentinel is a language and framework for policy built to be embedded in existing software to enable fine-grained, logic-based policy decisions. A policy describes under what circumstances certain behaviors are allowed. Sentinel is an enterprise-only feature of HashiCorp Consul, Nomad, Terraform, and Vault.

`vagrant up --provision-with sentinel`  
```                                                              
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: sentinel (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-35792-1ejlarj.sh
    user.local.dev: Reading package lists...
    user.local.dev: Building dependency tree...
    user.local.dev:
    user.local.dev: Reading state information...
    user.local.dev: unzip is already the newest version (6.0-20ubuntu1).
    user.local.dev: curl is already the newest version (7.47.0-1ubuntu2.14).
    user.local.dev: jq is already the newest version (1.5+dfsg-1ubuntu0.1).
    user.local.dev: 0 upgraded, 0 newly installed, 0 to remove and 4 not upgraded.
    user.local.dev: ++++ Sentinel Simulator v0.9.2 already installed at /usr/local/bin/sentinel
    user.local.dev: hour = 4
    user.local.dev: main = rule { hour >= 0 and hour < 12 }
    user.local.dev: ++++ cat /tmp/policy.sentinel
    user.local.dev: hour = 4
    user.local.dev: main = rule { hour >= 0 and hour < 12 }
    user.local.dev: ++++ sentinel apply /tmp/policy.sentinel
    user.local.dev: Pass
```

## Terraform Enterprise
https://www.terraform.io/docs/enterprise/index.html

Terraform Enterprise is our self-hosted distribution of Terraform Cloud. It offers enterprises a private instance of the Terraform Cloud application, with no resource limits and with additional enterprise-grade architectural features like audit logging and SAML single sign-on.

Terraform Cloud is an application that helps teams use Terraform together. It manages Terraform runs in a consistent and reliable environment, and includes easy access to shared state and secret data, access controls for approving changes to infrastructure, a private registry for sharing Terraform modules, detailed policy controls for governing the contents of Terraform configurations, and more.

For independent teams and small to medium-sized businesses, Terraform Cloud is also available as a hosted service at https://app.terraform.io.

![Terraform Enterprise](images/terraform-enterprise.png?raw=true "Terraform Enterprise")
![Terraform Enterprise](images/terraform-enterprise_logged_in.png?raw=true "Terraform Enterprise")
`vagrant up --provision-with terraform-enterprise`
```
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 consul-user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 vault-user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 nomad-user.local.dev
==> user.local.dev: Running provisioner: terraform-enterprise (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20191118-33309-16vz6hz.sh
    ...
    user.local.dev: Installing replicated-operator service
    user.local.dev: Starting replicated-operator service
    user.local.dev:
    user.local.dev: Operator installation successful
    user.local.dev: To continue the installation, visit the following URL in your browser:
    user.local.dev:
    user.local.dev:   http://10.9.99.10:8800
```

## Fabio Load Balancer
https://github.com/fabiolb/fabio <br />
https://fabiolb.net

Fabio is an HTTP and TCP reverse proxy that configures itself with data from Consul.

Traditional load balancers and reverse proxies need to be configured with a config file. The configuration contains the hostnames and paths the proxy is forwarding to upstream services. This process can be automated with tools like consul-template that generate config files and trigger a reload.

Fabio works differently since it updates its routing table directly from the data stored in Consul as soon as there is a change and without restart or reloading.

When you register a service in Consul all you need to add is a tag that announces the paths the upstream service accepts, e.g. urlprefix-/user or urlprefix-/order and fabio will do the rest.

`http://localhost:9999/` and `http://localhost:9998`

![Fabio Load Balancer](images/fabio.png?raw=true "Fabio Load Balancer")
`vagrant up --provision-with nomad`

Fabio runs as a Nomad job, see `hashicorp/nomad/jobs/fabio.nomad`
Some routes are added via Consul, see `hashicorp/consul.sh`
