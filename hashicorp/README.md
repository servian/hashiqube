# HashiCorp
http://www.hashicorp.com

## About
HashiCorp delivers consistent workflows to provision, secure, connect, and run any infrastructure for any application.
HashiCorp was founded by Mitchell Hashimoto and Armon Dadgar in 2012 with the goal of revolutionizing datacenter management: application development, delivery, and maintenance. ... IaaS, PaaS, SaaS. ... Our tools manage both physical machines and virtual machines, Windows, and Linux, SaaS ...

## HashiStack
* [Terraform](/hashicorp/?id=terraform)
* [Vault](/hashicorp/?id=vault)
* [Consul](/hashicorp/?id=consul)
* [Nomad](/hashicorp/?id=nomad)
* [Boundary](/hashicorp/?id=boundary)
* [Waypoint](/hashicorp/?id=waypoint)
* [Vagrant](/hashicorp/?id=vagrant)
* [Packer](/hashicorp/?id=packer)

## So how do we use the HashiStack

Kelsey Hightower presenting 12-Factor Apps and the HashiStack
https://github.com/kelseyhightower/hashiapp

Five years ago the world was introduced to 12 Factor apps which provided the blueprint for building applications for the cloud. 

As we move beyond the cloud into Hyperscale computing applications must be designed to be globally available and always on. Building on the foundation of 12 Factor, this session will introduce key requirements for Hyperscale applications such as high performance low latency communication, and playing nice in a distributed system. Attendees will learn how to build Hyperscale applications from the ground up using the HashiStack (Nomad, Vault, and Consul).

[![Kelsey Hightower: 12-Factor Apps and the HashiStack](https://img.youtube.com/vi/NVl9cIiPF80/maxresdefault.jpg)](https://www.youtube.com/watch?v=NVl9cIiPF80)

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

Packer will build a Docker container, use the Shell and Ansible provisioners, Ansible will also connect to Vault to retrieve secrets using a Token.

https://learn.hashicorp.com/vault/getting-started/secrets-engines
https://docs.ansible.com/ansible/latest/plugins/lookup/hashi_vault.html

Packer Templates can be found in hashicorp/packer/linux and hashicorp/packer/windows

You can build local Windows and Ubuntu boxes with packer using these commands

You must be in the directory hashiqube/hashicorp/packer

Now you can run `./run.sh`

## Terraform
https://www.terraform.io/

Terraform is an open-source infrastructure as code software tool created by HashiCorp. It enables users to define and provision a datacenter infrastructure using a high-level configuration language known as Hashicorp Configuration Language, or optionally JSON.

### Why Terraform
- Provides a high-level abstraction of infrastructure (IaC)
- Allows for composition and combination
- Supports parallel management of resources (graph, fast)
- Separates planning from execution (dry-run)

Because of this flexibility, Terraform can be used to solve many different problems.

### Introduction to Terraform
[![Armon Dadgar: Introduction to Terraform](https://img.youtube.com/vi/h970ZBgKINg/maxresdefault.jpg)](https://www.youtube.com/watch?v=h970ZBgKINg)

### Terraform lifecycle
The Terraform lifecycle consists of the following four phases

```bash
terraform init -> terraform plan -> terraform apply -> terraform destroy
```

### Terraform Workflow at Scale, Best Practices
[![Armon Dadgar: Terraform Workflow at Scale, Best Practices](https://img.youtube.com/vi/9c0s93GcXVw/maxresdefault.jpg)](https://www.youtube.com/watch?v=9c0s93GcXVw)

### Terraform Language
HashiCorp Configuration Language (HCL)
- Variables
- Outputs
- Resources
- Providers

Providers extend the language functionality
- Infrastructure as Code (IaC)

### Terraform Modules and Providers
Modules build and extend on the resources defined by providers.

|Modules | Providers|
|--------|----------|
|Container of multiple resources used together | Defines resource types that Terraform manages|
|Sourced through a registry or local files | Configure a specific infrastructue platform|
|Consists of .tf and/or .tf.json files | Contains instructions for API interactions|
|Re-usable Terraform configuration | Written in Go Lanaguage|
|Built on top of providers | Foundation for modules|

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

[![Armon Dadgar: Introduction to HashiCorp Vault](https://img.youtube.com/vi/VYfl-DpZ5wM/maxresdefault.jpg)](https://www.youtube.com/watch?v=VYfl-DpZ5wM)

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

## Traefik Load Balancer for Nomad
https://traefik.io/blog/traefik-proxy-fully-integrates-with-hashicorp-nomad/ <br />
https://doc.traefik.io/traefik/v2.8/providers/nomad/

We are thrilled to announce the full integration of the new Nomad built-in Service Discovery with Traefik Proxy. This is a first-of-its-kind ingress integration that simplifies ingress in HashiCorp Nomad. Utilizing Nomad directly with Traefik Proxy has never been so easy!

In early May, Hashicorp announced Nomad Version 1.3. Among other updates, it also includes a nice list of improvements on usability and developer experience. Before this release, when using service discovery with Nomad, Traefik Proxy users had to use Hashicorp Consul and Nomad side-by-side in order to benefit from Traefik Proxy’s famous automatic configuration. Now, Nomad has a simple and straightforward way to use service discovery built-in. This improves direct usability a lot! Not only in simple test environments but also on the edge.

`http://localhost:8080/` and `http://localhost:8181`

![Traefik Load Balancer](images/traefik-dashboard.png?raw=true "Traefik Load Balancer")

![Traefik Load Balancer](images/traefik-proxy.png?raw=true "Traefik Load Balancer")

`vagrant up --provision-with nomad --provider docker`

The new native Service Discovery in Nomad really does work seamlessly. With this integration, delivering load balancing, dynamic routing configuration, and ingress traffic routing become easier than ever. Check out the Traefik Proxy 2.8 Release Candidate and the Nomad 1.3 release notes.

`curl -H "Host: whoami.nomad.localhost" http://localhost:8080 -v`

```
*   Trying 127.0.0.1:8080...
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET / HTTP/1.1
> Host: whoami.nomad.localhost
> User-Agent: curl/7.79.1
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Length: 365
< Content-Type: text/plain; charset=utf-8
< Date: Thu, 16 Jun 2022 02:08:56 GMT
< 
Hostname: 86bb7e3d366a
IP: 127.0.0.1
IP: 172.18.0.5
RemoteAddr: 172.18.0.1:51192
GET / HTTP/1.1
Host: whoami.nomad.localhost
User-Agent: curl/7.79.1
Accept: */*
Accept-Encoding: gzip
X-Forwarded-For: 172.17.0.1
X-Forwarded-Host: whoami.nomad.localhost
X-Forwarded-Port: 80
X-Forwarded-Proto: http
X-Forwarded-Server: 5d7dc64220c8
X-Real-Ip: 172.17.0.1

* Connection #0 to host localhost left intact
```
## Fabio Load Balancer for Nomad
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
https://github.com/hashicorp/tfe-policies-example
https://docs.hashicorp.com/sentinel/language/

Sentinel is a language and framework for policy built to be embedded in existing software to enable fine-grained, logic-based policy decisions. A policy describes under what circumstances certain behaviors are allowed. Sentinel is an enterprise-only feature of HashiCorp Consul, Nomad, Terraform, and Vault.

`vagrant up --provision-with sentinel`
```
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/bionic64' version '20191218.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: sentinel (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200310-40084-1bbypjm.sh
    user.local.dev: Reading package lists...
    user.local.dev: Building dependency tree...
    user.local.dev:
    user.local.dev: Reading state information...
    user.local.dev: unzip is already the newest version (6.0-21ubuntu1).
    user.local.dev: jq is already the newest version (1.5+dfsg-2).
    user.local.dev: curl is already the newest version (7.58.0-2ubuntu3.8).
    user.local.dev: 0 upgraded, 0 newly installed, 0 to remove and 6 not upgraded.
    user.local.dev: ++++ Sentinel Simulator v0.9.2 already installed at /usr/local/bin/sentinel
    user.local.dev: hour = 4
    user.local.dev: main = rule { hour >= 0 and hour < 12 }
    user.local.dev: ++++ cat /tmp/policy.sentinel
    user.local.dev: hour = 4
    user.local.dev: main = rule { hour >= 0 and hour < 12 }
    user.local.dev: ++++ sentinel apply /tmp/policy.sentinel
    user.local.dev: Pass
    user.local.dev: ++++ Let's test some more advanced Sentinel Policies
    user.local.dev: ++++ https://github.com/hashicorp/tfe-policies-example
    user.local.dev: ++++ https://docs.hashicorp.com/sentinel/language/
    user.local.dev: ++++ sentinel test aws-block-allow-all-cidr.sentinel
    user.local.dev: PASS - aws-block-allow-all-cidr.sentinel
    user.local.dev:   PASS - test/aws-block-allow-all-cidr/empty.json
    user.local.dev:   PASS - test/aws-block-allow-all-cidr/fail.json
    user.local.dev:   PASS - test/aws-block-allow-all-cidr/pass.json
    user.local.dev:   ERROR - test/aws-block-allow-all-cidr/plan.json
    user.local.dev:
    user.local.dev: ++++ sentinel apply -config ./test/aws-block-allow-all-cidr/pass.json aws-block-allow-all-cidr.sentinel
    user.local.dev: Pass
    user.local.dev: ++++ sentinel apply -config ./test/aws-block-allow-all-cidr/fail.json aws-block-allow-all-cidr.sentinel
    user.local.dev: Fail
    user.local.dev:
    user.local.dev: Execution trace. The information below will show the values of all
    user.local.dev: the rules evaluated and their intermediate boolean expressions. Note that
    user.local.dev: some boolean expressions may be missing if short-circuit logic was taken.
    user.local.dev: FALSE - aws-block-allow-all-cidr.sentinel:69:1 - Rule "main"
    user.local.dev:   TRUE - aws-block-allow-all-cidr.sentinel:70:2 - ingress_cidr_blocks
    user.local.dev:     TRUE - aws-block-allow-all-cidr.sentinel:50:2 - all get_resources("aws_security_group") as sg {
    user.local.dev: 	all sg.applied.ingress as ingress {
    user.local.dev: 		all disallowed_cidr_blocks as block {
    user.local.dev: 			ingress.cidr_blocks not contains block
    user.local.dev: 		}
    user.local.dev: 	}
    user.local.dev: }
    user.local.dev:   FALSE - aws-block-allow-all-cidr.sentinel:71:2 - egress_cidr_blocks
    user.local.dev:     FALSE - aws-block-allow-all-cidr.sentinel:60:2 - all get_resources("aws_security_group") as sg {
    user.local.dev: 	all sg.applied.egress as egress {
    user.local.dev: 		all disallowed_cidr_blocks as block {
    user.local.dev: 			egress.cidr_blocks not contains block
    user.local.dev: 		}
    user.local.dev: 	}
    user.local.dev: }
    user.local.dev:
    user.local.dev: FALSE - aws-block-allow-all-cidr.sentinel:59:1 - Rule "egress_cidr_blocks"
    user.local.dev:
    user.local.dev: TRUE - aws-block-allow-all-cidr.sentinel:49:1 - Rule "ingress_cidr_blocks"
    user.local.dev:
    user.local.dev: ++++ sentinel test aws-alb-redirect.sentinel
    user.local.dev: PASS - aws-alb-redirect.sentinel
    user.local.dev:   PASS - test/aws-alb-redirect/empty.json
    user.local.dev:   PASS - test/aws-alb-redirect/fail.json
    user.local.dev:   PASS - test/aws-alb-redirect/pass.json
    user.local.dev:   ERROR - test/aws-alb-redirect/plan.json
    user.local.dev:
    user.local.dev: ++++ sentinel apply -config ./test/aws-alb-redirect/fail.json aws-alb-redirect.sentinel
    user.local.dev: Fail
    user.local.dev:
    user.local.dev: Execution trace. The information below will show the values of all
    user.local.dev: the rules evaluated and their intermediate boolean expressions. Note that
    user.local.dev: some boolean expressions may be missing if short-circuit logic was taken.
    user.local.dev: FALSE - aws-alb-redirect.sentinel:69:1 - Rule "main"
    user.local.dev:   FALSE - aws-alb-redirect.sentinel:70:2 - default_action
    user.local.dev:     FALSE - aws-alb-redirect.sentinel:49:2 - all get_resources("aws_lb_listener") as ln {
    user.local.dev: 	all ln.applied.default_action as action {
    user.local.dev:
    user.local.dev: 		all action.redirect as rdir {
    user.local.dev:
    user.local.dev: 			rdir.status_code == redirect_status_code
    user.local.dev: 		}
    user.local.dev: 	}
    user.local.dev: }
    user.local.dev:
    user.local.dev: FALSE - aws-alb-redirect.sentinel:48:1 - Rule "default_action"
    user.local.dev:
    user.local.dev: ++++ sentinel apply -config ./test/aws-alb-redirect/pass.json aws-alb-redirect.sentinel
    user.local.dev: Pass
```

## Terraform Enterprise
https://www.terraform.io/docs/enterprise/index.html

Terraform Enterprise is our self-hosted distribution of Terraform Cloud. It offers enterprises a private instance of the Terraform Cloud application, with no resource limits and with additional enterprise-grade architectural features like audit logging and SAML single sign-on.

Terraform Cloud is an application that helps teams use Terraform together. It manages Terraform runs in a consistent and reliable environment, and includes easy access to shared state and secret data, access controls for approving changes to infrastructure, a private registry for sharing Terraform modules, detailed policy controls for governing the contents of Terraform configurations, and more.

For independent teams and small to medium-sized businesses, Terraform Cloud is also available as a hosted service at https://app.terraform.io.

__Make sure you get a Terraform Licence file and place it in hashicorp directory e.g hashicorp/ptfe-license.rli__

When you run `vagrant up --provision-with terraform-enterprise` system logs and docker logs will be followed, the output will be in read, don't worry. This is for status output, __the installation takes a while__. The output will end when Terraform Enterprise is ready.

Once done, you will see __++++ To finish the installation go to http://10.9.99.10:8800__

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

## Waypoint

A consistent developer workflow to build, deploy, and release applications across any platform.

Waypoint supports
- aws-ec2
- aws-ecs
- azure-container-instance
- docker
- exec
- google-cloud-run
- kubernetes
- netlify
- nomad
- pack

https://www.hashicorp.com/blog/announcing-waypoint
https://www.waypointproject.io/

![Hashicorp Waypoint](images/waypoint-workflow.png?raw=true "Hashicorp Waypoint")
![Hashicorp Waypoint](images/waypoint.png?raw=true "Hashicorp Waypoint")
![Hashicorp Waypoint](images/waypoint-nodejs-deployment.png?raw=true "Hashicorp Waypoint")

Waypoint is a wonderful project and it's a firstclass citizen of Hashicorp and runs flawlessly on Nomad. 
To run Waypoint on Nomad do: 

```
vagrant up --provision-with basetools --provider docker
vagrant up --provision-with docker --provider docker
vagrant up --provision-with consul --provider docker
vagrant up --provision-with nomad --provider docker
vagrant up --provision-with waypoint-nomad --provider docker
```

Waypoint cab also run on Kubernetes and we can test Waypoint using Minikube
To run Waypoint on Kubernetes (Minikube) do: 

```
vagrant up --provision-with basetools --provider docker
vagrant up --provision-with docker --provider docker
vagrant up --provision-with minikube --provider docker
vagrant up --provision-with waypoint-kubernetes-minikube --provider docker
```

To access the documentation site you can run: 

```
vagrant up --provision-with docsify --provider docker
```

`vagrant up --provision-with waypoint`
```
Bringing machine 'hashiqube0.service.consul' up with 'virtualbox' provider...
==> hashiqube0.service.consul: Checking if box 'ubuntu/bionic64' version '20200429.0.0' is up to date...
==> hashiqube0.service.consul: A newer version of the box 'ubuntu/bionic64' for provider 'virtualbox' is
==> hashiqube0.service.consul: available! You currently have version '20200429.0.0'. The latest is version
==> hashiqube0.service.consul: '20201016.0.0'. Run `vagrant box update` to update.
==> hashiqube0.service.consul: [vagrant-hostsupdater] Checking for host entries
==> hashiqube0.service.consul: [vagrant-hostsupdater]   found entry for: 10.9.99.10 hashiqube0.service.consul
==> hashiqube0.service.consul: [vagrant-hostsupdater]   found entry for: 10.9.99.10 hashiqube0.service.consul
==> hashiqube0.service.consul: Running provisioner: waypoint (shell)...
    hashiqube0.service.consul: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20201019-11073-1uuxwal.sh
    hashiqube0.service.consul: Reading package lists...
    hashiqube0.service.consul: Building dependency tree...
    hashiqube0.service.consul: Reading state information...
    hashiqube0.service.consul: unzip is already the newest version (6.0-21ubuntu1).
    hashiqube0.service.consul: jq is already the newest version (1.5+dfsg-2).
    hashiqube0.service.consul: curl is already the newest version (7.58.0-2ubuntu3.10).
    hashiqube0.service.consul: The following packages were automatically installed and are no longer required:
    hashiqube0.service.consul:   linux-image-4.15.0-99-generic linux-modules-4.15.0-99-generic
    hashiqube0.service.consul: Use 'sudo apt autoremove' to remove them.
    hashiqube0.service.consul: 0 upgraded, 0 newly installed, 0 to remove and 30 not upgraded.
    hashiqube0.service.consul: WARNING! This will remove:
    hashiqube0.service.consul:   - all stopped containers
    hashiqube0.service.consul:   - all networks not used by at least one container
    hashiqube0.service.consul:   - all images without at least one container associated to them
    hashiqube0.service.consul:   - all build cache
    hashiqube0.service.consul:
    hashiqube0.service.consul: Are you sure you want to continue? [y/N]
    hashiqube0.service.consul: Deleted Images:
    hashiqube0.service.consul: deleted: sha256:6a104eb535fb892b25989f966e8775a4adf9b30590862c60745ab78aad58426e
    ...
    hashiqube0.service.consul: untagged: heroku/pack:18
    hashiqube0.service.consul: untagged: heroku/pack@sha256:52f6bc7a03ccf8680948527e51d4b089a178596d8835d8c884934e45272c2474
    hashiqube0.service.consul: deleted: sha256:b7b0e91d132e0874539ea0efa0eb4309a12e322b9ef64852ec05c13219ee2c36
    hashiqube0.service.consul: Total reclaimed space: 977.6MB
    hashiqube0.service.consul: WARNING! This will remove:
    hashiqube0.service.consul:   - all stopped containers
    hashiqube0.service.consul:   - all networks not used by at least one container
    hashiqube0.service.consul:   - all volumes not used by at least one container
    hashiqube0.service.consul:   - all dangling images
    hashiqube0.service.consul:   - all dangling build cache
    hashiqube0.service.consul:
    hashiqube0.service.consul: Are you sure you want to continue? [y/N]
    hashiqube0.service.consul: Deleted Volumes:
    hashiqube0.service.consul: pack-cache-e74b422cf62f.build
    hashiqube0.service.consul: pack-cache-e74b422cf62f.launch
    hashiqube0.service.consul: Total reclaimed space: 179.4MB
    hashiqube0.service.consul: ++++ Waypoint already installed at /usr/local/bin/waypoint
    hashiqube0.service.consul: ++++ Waypoint v0.1.2 (edf37a09)
    hashiqube0.service.consul: ++++ Docker pull Waypoint Server container
    hashiqube0.service.consul: latest:
    hashiqube0.service.consul: Pulling from hashicorp/waypoint
    hashiqube0.service.consul: Digest: sha256:689cae07ac8836ceba1f49c0c36ef57b27ebf61d36009bc309d2198e7825beb9
    hashiqube0.service.consul: Status: Image is up to date for hashicorp/waypoint:latest
    hashiqube0.service.consul: docker.io/hashicorp/waypoint:latest
    hashiqube0.service.consul: waypoint-server
    hashiqube0.service.consul: waypoint-server
    hashiqube0.service.consul: ++++ Waypoint Server starting
    hashiqube0.service.consul: Creating waypoint network...
    hashiqube0.service.consul: Installing waypoint server to docker
    hashiqube0.service.consul:  +: Server container started
    hashiqube0.service.consul: Service ready. Connecting to: localhost:9701
    hashiqube0.service.consul: Retrieving initial auth token...
    hashiqube0.service.consul: ! Error getting the initial token: server is already bootstrapped
    hashiqube0.service.consul:
    hashiqube0.service.consul:   The Waypoint server has been deployed, but due to this error we were
    hashiqube0.service.consul:   unable to automatically configure the local CLI or the Waypoint server
    hashiqube0.service.consul:   advertise address. You must do this manually using "waypoint context"
    hashiqube0.service.consul:   and "waypoint server config-set".
    hashiqube0.service.consul: ++++ Git Clone Waypoint examples
    hashiqube0.service.consul: Cloning into '/tmp/waypoint-examples'...
    hashiqube0.service.consul: -> Validating configuration file...
    hashiqube0.service.consul: -> Configuration file appears valid
    hashiqube0.service.consul: -> Validating server credentials...
    hashiqube0.service.consul: -> Connection to Waypoint server was successful
    hashiqube0.service.consul: -> Checking if project "example-nodejs" is registered...
    hashiqube0.service.consul: -> Project "example-nodejs" and all apps are registered with the server.
    hashiqube0.service.consul: -> Validating required plugins...
    hashiqube0.service.consul: -> Plugins loaded and configured successfully
    hashiqube0.service.consul: -> Checking auth for the configured components...
    hashiqube0.service.consul: -> Checking auth for app: "example-nodejs"
    hashiqube0.service.consul: -> Authentication requirements appear satisfied.
    hashiqube0.service.consul: Project initialized!
    hashiqube0.service.consul: You may now call 'waypoint up' to deploy your project or
    hashiqube0.service.consul: commands such as 'waypoint build' to perform steps individually.
    hashiqube0.service.consul:
    hashiqube0.service.consul: » Building...
    hashiqube0.service.consul: Creating new buildpack-based image using builder: heroku/buildpacks:18
    hashiqube0.service.consul: -> Creating pack client
    hashiqube0.service.consul: -> Building image
    hashiqube0.service.consul: 2020/10/19 00:21:34.146368 DEBUG:  Pulling image index.docker.io/heroku/buildpacks:18
    hashiqube0.service.consul: 18: Pulling from heroku/buildpacks
    6deb54562bfb: Downloading  4.615kB/4.615kB
    ...
6deb54562bfb: Download complete
797d95067ecf: .service.consul:
    hashiqube0.service.consul: Downloading  1.616MB/225.9MB
    ...
4f4fb700ef54: Pull complete l:
    hashiqube0.service.consul: Digest: sha256:27253508524ce1d6bbd70276425f6185743079ac7b389559c18e3f5843491272
    hashiqube0.service.consul: Status: Downloaded newer image for heroku/buildpacks:18
    hashiqube0.service.consul: 2020/10/19 00:22:51.943378 DEBUG:  Selected run image heroku/pack:18
    hashiqube0.service.consul: 2020/10/19 00:22:56.504815 DEBUG:  Pulling image heroku/pack:18
    hashiqube0.service.consul: 18: Pulling from heroku/pack
    hashiqube0.service.consul:
171857c49d0f: Already exists :
    hashiqube0.service.consul:
419640447d26: Already exists :
    hashiqube0.service.consul:
61e52f862619: Already exists :
    hashiqube0.service.consul:
c97d646ce0ef: Already exists :
    hashiqube0.service.consul:
3776f40e285d: Already exists :
    hashiqube0.service.consul:
5ca5846f3d21: Pulling fs layer
6b143b2e1683: Pulling fs layer
6b143b2e1683: Downloading     436B/4.537kB
6b143b2e1683: Downloading  4.537kB/4.537kB
6b143b2e1683: Verifying Checksum
    hashiqube0.service.consul: Download complete
5ca5846f3d21: Extracting      99B/99BB
5ca5846f3d21: Extracting      99B/99B
5ca5846f3d21: Pull complete l:
6b143b2e1683: Extracting  4.537kB/4.537kB
6b143b2e1683: Extracting  4.537kB/4.537kB
6b143b2e1683: Pull complete l:
    hashiqube0.service.consul: Digest: sha256:48e491dd56cc67b120039c958cfddeaf3f8752161efa85756d73c09fde413477
    hashiqube0.service.consul: Status: Downloaded newer image for heroku/pack:18
    hashiqube0.service.consul: 2020/10/19 00:23:02.430378 DEBUG:  Creating builder with the following buildpacks:
    hashiqube0.service.consul: 2020/10/19 00:23:02.430417 DEBUG:  -> heroku/maven@0.1
    hashiqube0.service.consul: 2020/10/19 00:23:02.430423 DEBUG:  -> heroku/jvm@0.1
    hashiqube0.service.consul: 2020/10/19 00:23:02.430427 DEBUG:  -> heroku/java@0.1
    hashiqube0.service.consul: 2020/10/19 00:23:02.430432 DEBUG:  -> heroku/ruby@0.0.1
    hashiqube0.service.consul: 2020/10/19 00:23:02.430436 DEBUG:  -> heroku/procfile@0.5
    hashiqube0.service.consul: 2020/10/19 00:23:02.430439 DEBUG:  -> heroku/python@0.2
    hashiqube0.service.consul: 2020/10/19 00:23:02.430442 DEBUG:  -> heroku/gradle@0.2
    hashiqube0.service.consul: 2020/10/19 00:23:02.430447 DEBUG:  -> heroku/scala@0.2
    hashiqube0.service.consul: 2020/10/19 00:23:02.430451 DEBUG:  -> heroku/php@0.2
    hashiqube0.service.consul: 2020/10/19 00:23:02.430455 DEBUG:  -> heroku/go@0.2
    hashiqube0.service.consul: 2020/10/19 00:23:02.430464 DEBUG:  -> heroku/nodejs-engine@0.4.4
    hashiqube0.service.consul: 2020/10/19 00:23:02.430471 DEBUG:  -> heroku/nodejs-npm@0.2.0
    hashiqube0.service.consul: 2020/10/19 00:23:02.430475 DEBUG:  -> heroku/nodejs-yarn@0.0.1
    hashiqube0.service.consul: 2020/10/19 00:23:02.430483 DEBUG:  -> heroku/nodejs-typescript@0.0.2
    hashiqube0.service.consul: 2020/10/19 00:23:02.430489 DEBUG:  -> heroku/nodejs@0.1
    hashiqube0.service.consul: 2020/10/19 00:23:02.430495 DEBUG:  -> salesforce/nodejs-fn@2.0.1
    hashiqube0.service.consul: 2020/10/19 00:23:02.430505 DEBUG:  -> projectriff/streaming-http-adapter@0.1.3
    hashiqube0.service.consul: 2020/10/19 00:23:02.430528 DEBUG:  -> projectriff/node-function@0.6.1
    hashiqube0.service.consul: 2020/10/19 00:23:02.430534 DEBUG:  -> evergreen/fn@0.2
    hashiqube0.service.consul: 2020/10/19 00:23:06.713138 DEBUG:  Pulling image buildpacksio/lifecycle:0.9.1
    hashiqube0.service.consul: 0.9.1: Pulling from buildpacksio/lifecycle
    hashiqube0.service.consul:
4000adbbc3eb: Pulling fs layer
474f7dcb012d: Pulling fs layer
    ...
474f7dcb012d: Pull complete l:
    hashiqube0.service.consul: Digest: sha256:53bf0e18a734e0c4071aa39b950ed8841f82936e53fb2a0df56c6aa07f9c5023
    hashiqube0.service.consul: Status: Downloaded newer image for buildpacksio/lifecycle:0.9.1
    hashiqube0.service.consul: 2020/10/19 00:23:14.338504 DEBUG:  Using build cache volume pack-cache-e74b422cf62f.build
    hashiqube0.service.consul: 2020/10/19 00:23:14.338523 INFO:   ===> DETECTING
    hashiqube0.service.consul: [detector] ======== Output: heroku/ruby@0.0.1 ========
    hashiqube0.service.consul: [detector] no
    hashiqube0.service.consul: [detector] err:  heroku/ruby@0.0.1 (1)
    hashiqube0.service.consul: [detector] ======== Output: heroku/maven@0.1 ========
    hashiqube0.service.consul: [detector] Could not find a pom.xml file! Please check that it exists and is committed to Git.
    hashiqube0.service.consul: [detector] err:  heroku/maven@0.1 (1)
    hashiqube0.service.consul: [detector] err:  salesforce/nodejs-fn@2.0.1 (1)
    hashiqube0.service.consul: [detector] 3 of 4 buildpacks participating
    hashiqube0.service.consul: [detector] heroku/nodejs-engine 0.4.4
    hashiqube0.service.consul: [detector] heroku/nodejs-npm    0.2.0
    hashiqube0.service.consul: [detector] heroku/procfile      0.5
    hashiqube0.service.consul: 2020/10/19 00:23:15.788888 INFO:   ===> ANALYZING
    hashiqube0.service.consul: [analyzer] Restoring metadata for "heroku/nodejs-engine:nodejs" from app image
    hashiqube0.service.consul: 2020/10/19 00:23:16.543000 INFO:   ===> RESTORING
    hashiqube0.service.consul: [restorer] Removing "heroku/nodejs-engine:nodejs", not in cache
    hashiqube0.service.consul: 2020/10/19 00:23:17.220776 INFO:   ===> BUILDING
    hashiqube0.service.consul: [builder] ---> Node.js Buildpack
    hashiqube0.service.consul: [builder] ---> Installing toolbox
    hashiqube0.service.consul: [builder] ---> - jq
    hashiqube0.service.consul: [builder] ---> - yj
    hashiqube0.service.consul: [builder] ---> Getting Node version
    hashiqube0.service.consul: [builder] ---> Resolving Node version
    hashiqube0.service.consul: [builder] ---> Downloading and extracting Node v12.19.0
    hashiqube0.service.consul: [builder] ---> Parsing package.json
    hashiqube0.service.consul: [builder] ---> Using npm v6.14.8 from Node
    hashiqube0.service.consul: [builder] ---> Installing node modules
    hashiqube0.service.consul: [builder]
    hashiqube0.service.consul: [builder] > ejs@2.7.4 postinstall /workspace/node_modules/ejs
    hashiqube0.service.consul: [builder] > node ./postinstall.js
    hashiqube0.service.consul: [builder]
    hashiqube0.service.consul: [builder] Thank you for installing EJS: built with the Jake JavaScript build tool (https://jakejs.com/)
    hashiqube0.service.consul: [builder]
    hashiqube0.service.consul: [builder] npm WARN node-js-getting-started@0.3.0 No repository field.
    hashiqube0.service.consul: [builder]
    hashiqube0.service.consul: [builder] added 131 packages from 107 contributors and audited 131 packages in 4.554s
    hashiqube0.service.consul: [builder]
    hashiqube0.service.consul: [builder] 26 packages are looking for funding
    hashiqube0.service.consul: [builder]   run `npm fund` for details
    hashiqube0.service.consul: [builder]
    hashiqube0.service.consul: [builder] found 0 vulnerabilities
    hashiqube0.service.consul: [builder]
    hashiqube0.service.consul: [builder] -----> Discovering process types
    hashiqube0.service.consul: [builder]        Procfile declares types     -> web
    hashiqube0.service.consul: 2020/10/19 00:24:22.424730 INFO:   ===> EXPORTING
    hashiqube0.service.consul: [exporter] Reusing layer 'heroku/nodejs-engine:nodejs'
    hashiqube0.service.consul: [exporter] Reusing 1/1 app layer(s)
    hashiqube0.service.consul: [exporter] Reusing layer 'launcher'
    hashiqube0.service.consul: [exporter] Reusing layer 'config'
    hashiqube0.service.consul: [exporter] Adding label 'io.buildpacks.lifecycle.metadata'
    hashiqube0.service.consul: [exporter] Adding label 'io.buildpacks.build.metadata'
    hashiqube0.service.consul: [exporter] Adding label 'io.buildpacks.project.metadata'
    hashiqube0.service.consul: [exporter] *** Images (f58c7abc7584):
    hashiqube0.service.consul: [exporter]       index.docker.io/library/example-nodejs:latest
    hashiqube0.service.consul: [exporter] Adding cache layer 'heroku/nodejs-engine:nodejs'
    hashiqube0.service.consul: [exporter] Adding cache layer 'heroku/nodejs-engine:toolbox'
    hashiqube0.service.consul: -> Injecting entrypoint binary to image
    hashiqube0.service.consul:
    hashiqube0.service.consul: » Deploying...
    hashiqube0.service.consul: -> Setting up waypoint network
    hashiqube0.service.consul: -> Creating new container
    hashiqube0.service.consul: -> Starting container
    hashiqube0.service.consul: -> App deployed as container: example-nodejs-01EMZ3X20HX35FRA3F28AAFHFA
    hashiqube0.service.consul:
    hashiqube0.service.consul: » Releasing...
    hashiqube0.service.consul:
    hashiqube0.service.consul: » Pruning old deployments...
    hashiqube0.service.consul:   Deployment: 01EMT63W8YBMWM5CGK05XGTC44
    hashiqube0.service.consul: Deleting container...
    hashiqube0.service.consul:
    hashiqube0.service.consul: The deploy was successful! A Waypoint deployment URL is shown below. This
    hashiqube0.service.consul: can be used internally to check your deployment and is not meant for external
    hashiqube0.service.consul: traffic. You can manage this hostname using "waypoint hostname."
    hashiqube0.service.consul:
    hashiqube0.service.consul:            URL: https://annually-peaceful-terrapin.waypoint.run
    hashiqube0.service.consul: Deployment URL: https://annually-peaceful-terrapin--v4.waypoint.run
    hashiqube0.service.consul: ++++ Waypoint Server https://localhost:9702 and enter the following Token displayed below
    hashiqube0.service.consul: bM152PWkXxfoy4vA51JFhR7LmV9FA9RLbSpHoKrysFnwnRCAGzV2RExsyAmBrHu784d1WZRW6Cx4MkhvWzkDHvEn49c4wkSZYScfJ
```

## Boundary

Boundary is designed to grant access to critical systems using the principle of least privilege, solving challenges organizations encounter when users need to securely access applications and machines. Traditional products that grant access to systems are cumbersome, painful to maintain, or are black boxes lacking extensible APIs. Boundary allows authenticated and authorized users to access secure systems in private networks without granting access to the larger network where those systems reside.

![Hashicorp Boundary](images/boundary-how-it-works.png?raw=true "Hashicorp Boundary")
![Hashicorp Boundary](images/boundary-login-page.png?raw=true "Hashicorp Boundary")
![Hashicorp Boundary](images/boundary-logged-in-page.png?raw=true "Hashicorp Boundary")

`vagrant up --provision-with boundary`
```
Bringing machine 'hashiqube0.service.consul' up with 'virtualbox' provider...
==> hashiqube0.service.consul: Checking if box 'ubuntu/bionic64' version '20200429.0.0' is up to date...
==> hashiqube0.service.consul: [vagrant-hostsupdater] Checking for host entries
==> hashiqube0.service.consul: [vagrant-hostsupdater]   found entry for: 10.9.99.10 hashiqube0.service.consul
==> hashiqube0.service.consul: [vagrant-hostsupdater]   found entry for: 10.9.99.10 hashiqube0.service.consul
==> hashiqube0.service.consul: Running provisioner: boundary (shell)...
    hashiqube0.service.consul: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20201103-74542-1kv32gp.sh
    hashiqube0.service.consul: Reading package lists...
    hashiqube0.service.consul: Building dependency tree...
    hashiqube0.service.consul:
    hashiqube0.service.consul: Reading state information...
    hashiqube0.service.consul: unzip is already the newest version (6.0-21ubuntu1).
    hashiqube0.service.consul: jq is already the newest version (1.5+dfsg-2).
    hashiqube0.service.consul: curl is already the newest version (7.58.0-2ubuntu3.10).
    hashiqube0.service.consul: 0 upgraded, 0 newly installed, 0 to remove and 64 not upgraded.
    hashiqube0.service.consul: ++++ Bundary already installed at /usr/local/bin/boundary
    hashiqube0.service.consul: ++++
    hashiqube0.service.consul: Version information:
    hashiqube0.service.consul:   Git Revision:        eccd68d73c3edf14863ecfd31f9023063b809d5a
    hashiqube0.service.consul:   Version Number:      0.1.1
    hashiqube0.service.consul: listener "tcp" {
    hashiqube0.service.consul:   purpose = "api"
    hashiqube0.service.consul:   address = "0.0.0.0:19200"
    hashiqube0.service.consul: }
    hashiqube0.service.consul: ++++ Starting Boundary in dev mode
    hashiqube0.service.consul: ==> Boundary server configuration:
    hashiqube0.service.consul:
    hashiqube0.service.consul:        [Controller] AEAD Key Bytes: F8Rr2klI5yUffkNBt0y9LgUDLMLkEQ583A3S1Ab315s=
    hashiqube0.service.consul:          [Recovery] AEAD Key Bytes: HVC+7Zs4CZlfCV204HG/VL1uYlqKrNkHizdwGflESTw=
    hashiqube0.service.consul:       [Worker-Auth] AEAD Key Bytes: T3Warqpc25zIpeNebp/+442OoQjejdGxEdykw6tzanA=
    hashiqube0.service.consul:               [Recovery] AEAD Type: aes-gcm
    hashiqube0.service.consul:                   [Root] AEAD Type: aes-gcm
    hashiqube0.service.consul:            [Worker-Auth] AEAD Type: aes-gcm
    hashiqube0.service.consul:                                Cgo: disabled
    hashiqube0.service.consul:             Dev Database Container: relaxed_hermann
    hashiqube0.service.consul:                   Dev Database Url: postgres://postgres:password@localhost:32773?sslmode=disable
    hashiqube0.service.consul:           Generated Auth Method Id: ampw_1234567890
    hashiqube0.service.consul:   Generated Auth Method Login Name: admin
    hashiqube0.service.consul:     Generated Auth Method Password: password
    hashiqube0.service.consul:          Generated Host Catalog Id: hcst_1234567890
    hashiqube0.service.consul:                  Generated Host Id: hst_1234567890
    hashiqube0.service.consul:              Generated Host Set Id: hsst_1234567890
    hashiqube0.service.consul:             Generated Org Scope Id: o_1234567890
    hashiqube0.service.consul:         Generated Project Scope Id: p_1234567890
    hashiqube0.service.consul:                Generated Target Id: ttcp_1234567890
    hashiqube0.service.consul:                         Listener 1: tcp (addr: "0.0.0.0:19200", max_request_duration: "1m30s", purpose: "api")
    hashiqube0.service.consul:                         Listener 2: tcp (addr: "127.0.0.1:9201", max_request_duration: "1m30s", purpose: "cluster")
    hashiqube0.service.consul:                         Listener 3: tcp (addr: "127.0.0.1:9202", max_request_duration: "1m30s", purpose: "proxy")
    hashiqube0.service.consul:                          Log Level: info
    hashiqube0.service.consul:                              Mlock: supported: true, enabled: false
    hashiqube0.service.consul:                            Version: Boundary v0.1.1
    hashiqube0.service.consul:                        Version Sha: eccd68d73c3edf14863ecfd31f9023063b809d5a
    hashiqube0.service.consul:                 Worker Public Addr: 127.0.0.1:9202
    hashiqube0.service.consul:
    hashiqube0.service.consul: ==> Boundary server started! Log data will stream in below:
    hashiqube0.service.consul:
    hashiqube0.service.consul: 2020-11-03T00:02:59.775Z [INFO]  controller: cluster address: addr=127.0.0.1:9201
    hashiqube0.service.consul: 2020-11-03T00:02:59.775Z [INFO]  worker: connected to controller: address=127.0.0.1:9201
    hashiqube0.service.consul: 2020-11-03T00:02:59.778Z [INFO]  controller: worker successfully authed: name=dev-worker
    hashiqube0.service.consul: ++++ Boundary Server started at http://localhost:19200
    hashiqube0.service.consul: ++++ Login with admin:password
    hashiqube0.service.consul: /tmp/vagrant-shell: line 5:  5093 Terminated              sh -c 'sudo tail -f /var/log/boundary.log | { sed "/worker successfully authed/ q" && kill $$ ;}'
```
