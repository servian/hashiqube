# HashiQube Overview
HashiQube is a VM with a Docker daemon inside. It runs all HashiCorp products. __Vault, Terraform, Nomad, Consul, Vagrant, Packer and Sentinel.__
It also runs a host of other popular Open Source DevOps / DevSecOps applications showcasing how simple integration with HashiCorp products can result in tangible learnings and benefits for all its users
Once the Qube is up an internet connection is no longer needed meaning sales pitches and demos for potential and existing customers is greatly aided.

## Links
HashiCorp blog post about HashiQube: https://www.hashicorp.com/resources/hashiqube-a-development-lab-using-all-the-hashicorp-products <br />
HashiQube website: https://servian.github.io/hashiqube <br />
HashiQube github: https://github.com/servian/hashiqube <br />
HashiQube youtube: https://www.youtube.com/watch?v=6jGDAGWaFiw

## HashiQube runs all HashiCorp's products 
![HashiQube](images/thestack.png?raw=true "HashiQube")

## Purpose
HashiQube has been created to enable anyone who is interested in secure automation pipelines the ability to run a suite of ‘best in class’ tools their local machines at the cost of a small amount of system resources.
The Qube gives all interested parties the empowerment  to  deploy these tools in a way covers multiple use cases effectively providing a ‘concept to completion’ test bed using open source HashiCorp products.
The original use case was born the desire to demystify DevSecOps utilising Terraform, Vault, Consul, Sentinel and Nomad as well as some other well know open source CI/CD tools by providing a ‘hands-on’ environment that demonstrates the value of secret and credential management in standard software development pipeline.

Thanks to the flexibility of the HashiCorp products there is no need wonder how to achieve the goals of bringing software to market in a more secure and timely fashion, just Vagrant up!

## Instructions
* Please download __Virtualbox__ from https://www.virtualbox.org/wiki/Downloads and __Vagrant__ from https://www.vagrantup.com/downloads.html and install
* Using `git` - clone this repo `git clone $repo .` [__What is Git?__](git/#git)
* Inside the local repo folder, do `vagrant up --provision` - This will setup, Vault, Nomad, Consul, Terraform, Localstack and Docker as well as giving you access the docsify website at http://localhost:3333
* Open in your browser http://localhost:3333 for Documentation

## Consul DNS
__Local DNS via Consul__ <br />
Add on our local Macbook a file __/etc/resolver/consul__ with below contents
```
nameserver 10.9.99.10
port 8600
```
Now you can use DNS like nomad.service.consul:9999 vault.service.consul:9999 via Fabio Load Balancer <br />

## Pre-requisites
* 10GB of disk space
* 4GB RAM
* Admin rights / sudo (you will be asked to update ETC Host file)
* Virtualbox
* Vagrant
* `vagrant up --provision`

## Additional Information
* [__Multi Cloud__](multi-cloud/#terraform-hashicorp-hashiqube) - Hashiqube on AWS, GCP and Azure (Clustered) https://registry.terraform.io/modules/star3am/hashiqube/hashicorp/latest
* [__Vagrant__](hashicorp/#vagrant) - Development Environments Made Easy
* [__Vault__](hashicorp/#vault) - Manage Secrets and Protect Sensitive Data
* [__Consul__](hashicorp/#consul) - Secure Service Networking
* [__Nomad__](hashicorp/#nomad) - Deploy and Manage Any Containerized, Legacy, or Batch Application
* [__Terraform__](hashicorp/#terraform) - Use Infrastructure as Code to provision and manage any cloud, infrastructure, or service
* [__Packer__](hashicorp/#packer) - Build Automated Machine Images
* [__Sentinel__](hashicorp/#sentinel) - Sentinel is an embedded policy-as-code framework
* [__Waypoint__](hashicorp/#waypoint) - Waypoint is an open source solution that provides a modern workflow for build, deploy, and release across platforms
* [__Boundary__](hashicorp/#boundary) - Simple and secure remote access to any system from anywhere based on user identity.
* [__Fabio__](hashicorp/#fabio-load-balancer) - Fabio is an HTTP and TCP reverse proxy that configures itself with data from Consul
* [__Docker__](docker/#docker) - Securely build, share and run any application, anywhere
* [__Localstack__](localstack/#localstack) - A fully functional local AWS cloud stack
* [__Ansible__](ansible/#ansible) - Automation for everyone
* [__LDAP__](ldap/#ldap) - Lightweight Directory Access Protocol
* [__Jenkins__](jenkins/#jenkins) - The leading open source automation server
* [__Oracle MySQL__](database/#oracle-mysql) - MySQL is an open-source relational database management system (RDBMS)
* [__Microsoft MSSQL__](database/#microsoft-sql-mssql-express) - Microsoft SQL Server is a relational database management system developed by Microsoft
* [__PostgreSQL__](database/#postgresql) - PostgreSQL, also known as Postgres, is a free and open-source relational database management system emphasizing extensibility and SQL compliance.
* [__Docsify__](docsify/#docsify) - A magical documentation site generator

Once the stack is up you will have a large number of services running and available on `localhost` <br />
For Documentation please open http://localhost:3333 in your browser

## Hashicorp basic usage
* Vault http://localhost:8200
* Nomad http://localhost:4646
* Consul http://localhost:8500
* Localstack http://localhost:8080

## HashiQube runs all HashiCorp's products
![HashiQube](images/hashicorp_products.png?raw=true "HashiQube")

## Other
* LDAP can be accessed on ldap://localhost:389
* Localstack web http://localhost:8080
* Ansible provisioning Apache2 http://localhost:8888
* Jenkins http://localhost:8088
* Oracle MySQL localhost:3306
* Microsoft SQL localhost:1433

### Vagrant Basic Usage
* vagrant up --provision OR vagrant up --provision-with bootstrap|nomad|consul|vault|docker|ldap
* vagrant global-status # to see which VMs are active
* vagrant global-status --prune # to remove stale VMs from Vagrant cache
* vagrant status # vagrant status
* vagrant reload
* vagrant up
* vagrant destroy
* vagrant provision
* vagrant plugin list

### Docker Basic Usage
* docker image ls
* docker ps
* docker stop

### Hostnames and DNS can  be faked via /etc/hosts

```
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 consul-user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 vault-user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 nomad-user.local.dev
==> user.local.dev: Setting hostname...
```

## To investigate
### CI/CD
    Gatling: (load testing) https://gatling.io/open-source
    Spinnaker for multi-cloud / multi swim lane CD tool: https://www.spinnaker.io/concepts/
    Build agent showing code clean and dirty.
        Java
        Python
        JavaScript

### Monitoring / Dash-boarding
    Hygiea dashboard: https://github.com/Hygieia/Hygieia
    Alerting will be handled by a local docker messaging server such as Gotify: https://github.com/gotify/server

### Containerisation and API’s
    Gloo: https://docs.solo.io/gloo/latest/introduction/

## Support & Feedback
For suggestions, feedback and queries please branch or and submit a Pull Request or directly contact the architects of the HashiQube via email:

Lead Automation Architect [riaan.nolan@servian.com](mailto:riaan.nolan@servian.com)

## Contributors and Special mentions
A Very special mention to HashiQube's contributors, Thank You All for your help, suggestions and contributions no matter how small <3
 - Thomas Cockin
 - Konstantin Vanyushov
 - Tristan Morgan
 - Ringo Chan
 - Ehsan Mirzaei
 - Greg Luxford

## Videos
Videos were made with asciinema https://asciinema.org/
- asciinema rec -i 1
- asciicast2gif -S 1 -s 2 tmpd1zpq13n-ascii.cast tmpd1zpq13n-ascii.gif

## License
HashiQube is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
