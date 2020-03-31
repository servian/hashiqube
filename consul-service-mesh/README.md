# Consul Service Mesh for Multi Cloud
https://www.hashicorp.com/products/consul/service-mesh/ <br />
https://learn.hashicorp.com/nomad/operating-nomad/clustering <br />

Service Mesh Made Easy
A distributed networking layer to connect, secure and observe services across any runtime platform and public or private cloud.

Let's bring up HashiQube in some public clouds and see how we can connect them all together in a Service Mesh, we will also bring up Nomad with the countdash demo, fabio load balancer and http-echo service.

This demo will you Terraform to bring up the Multi Cloud.

## Instructions
* You need an SSH key pair configured on your laptop, you can create one with this command <br />
`ssh-keygen -t rsa -b 2048`


You need an account with AWS and GCP, you can open a free account with each.
* Configure your AWS credentials in ~/.aws/credentials
`cat ~/.aws/credentials`
```
[default]
region = ap-southeast-2
aws_access_key_id = xxxXXXxxxXXX
aws_secret_access_key = xxxXXXxxxXXX
```

* Configure your GCP credentials in ~/.gcp/credentials.json
`cat ~/.gcp/credentials.json`
```
{
  "type": "service_account",
  "project_id": "xxxXXXxxxXXX",
  "private_key_id": "xxxXXXxxxXXX",
  "private_key": "xxxXXXxxxXXX",
  "client_email": "xxxXXXxxxXXX",
  "client_id": "xxxXXXxxxXXX",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "xxxXXXxxxXXX"
}
```

## Launch
`cd consul-service-mesh/terraform` <br />
`terraform init`
```

Initializing the backend...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 2.52"
* provider.external: version = "~> 1.2"
* provider.google: version = "~> 3.9"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

`terraform plan` To see what will be created and then,

`terraform apply --auto-approve`
```
data.external.myipaddress: Refreshing state...
data.google_compute_subnetwork.default: Refreshing state...
data.aws_ami.ubuntu: Refreshing state...
google_service_account.consul_compute: Creating...
google_compute_address.static: Creating...
google_service_account.consul_compute: Creation complete after 3s [id=projects/thermal-formula-256223/serviceAccounts/sa-consul-compute-prod@thermal-formula-256223.iam.gserviceaccount.com]
google_project_iam_member.compute_policy: Creating...
aws_iam_role.hashiqube: Creating...
aws_key_pair.hashiqube: Creating...
aws_eip.hashiqube: Creating...
aws_key_pair.hashiqube: Creation complete after 0s [id=hashiqube]
aws_eip.hashiqube: Creation complete after 0s [id=eipalloc-0d97d1dfb4f5a6b0d]
google_compute_firewall.allow_intercluster_consul_inbound: Creating...
google_compute_firewall.allow_cluster_consul_wan: Creating...
google_compute_address.static: Creation complete after 5s [id=projects/thermal-formula-256223/regions/australia-southeast1/addresses/hashiqube]
aws_security_group.hashiqube: Creating...
google_compute_instance_template.hashiqube: Creating...
aws_iam_role.hashiqube: Creation complete after 2s [id=hashiqube]
aws_iam_role_policy.hashiqube: Creating...
aws_iam_instance_profile.hashiqube: Creating...
aws_security_group.hashiqube: Creation complete after 2s [id=sg-06f375c319e9b005d]
aws_iam_role_policy.hashiqube: Creation complete after 2s [id=hashiqube:hashiqube]
aws_iam_instance_profile.hashiqube: Creation complete after 3s [id=hashiqube]
aws_instance.hashiqube: Creating...
google_compute_instance_template.hashiqube: Creation complete after 6s [id=projects/thermal-formula-256223/global/instanceTemplates/consul20200315180711098900000001]
google_compute_region_instance_group_manager.hashiqube: Creating...
google_project_iam_member.compute_policy: Creation complete after 10s [id=thermal-formula-256223/roles/compute.networkViewer/serviceaccount:sa-consul-compute-prod@thermal-formula-256223.iam.gserviceaccount.com]
google_compute_firewall.allow_cluster_consul_wan: Still creating... [10s elapsed]
google_compute_firewall.allow_intercluster_consul_inbound: Still creating... [10s elapsed]
aws_instance.hashiqube: Still creating... [10s elapsed]
google_compute_region_instance_group_manager.hashiqube: Still creating... [10s elapsed]
google_compute_firewall.allow_intercluster_consul_inbound: Creation complete after 18s [id=projects/thermal-formula-256223/global/firewalls/consul-rule-consul-inter-inbound]
google_compute_firewall.allow_cluster_consul_wan: Creation complete after 19s [id=projects/thermal-formula-256223/global/firewalls/consul-rule-consul-wan]
aws_instance.hashiqube: Still creating... [20s elapsed]
google_compute_region_instance_group_manager.hashiqube: Creation complete after 20s [id=projects/thermal-formula-256223/regions/australia-southeast1/instanceGroupManagers/hashiqube]
aws_instance.hashiqube: Still creating... [30s elapsed]
aws_instance.hashiqube: Still creating... [40s elapsed]
aws_instance.hashiqube: Creation complete after 42s [id=i-05c007ecc8746640e]
aws_eip_association.eip_assoc: Creating...
aws_eip_association.eip_assoc: Creation complete after 0s [id=eipassoc-00b8a789123882607]

Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

AWS_hashiqube1-consul-service-consul = http://13.239.110.170:8500
AWS_hashiqube1-fabio-ui-service-consul = http://13.239.110.170:9998
AWS_hashiqube1-nomad-service-consul = http://13.239.110.170:4646
AWS_hashiqube1-service-consul = 13.239.110.170
AWS_hashiqube1-ssh-service-consul = ssh ubuntu@13.239.110.170
GCP_hashiqube2-consul-service-consul = http://34.87.237.149:8500
GCP_hashiqube2-fabio-ui-service-consul = http://34.87.237.149:9998
GCP_hashiqube2-nomad-service-consul = http://34.87.237.149:4646
GCP_hashiqube2-service-consul = 34.87.237.149
GCP_hashiqube2-ssh-service-consul = ssh ubuntu@34.87.237.149
OnPrem_hashiqube0-service-consul = 61.68.144.9
```

These instances will only be accessible by you, since we whitelist our IPs - see gcp.tf and aws.tf and main.tf for details.

You will be able to access Consul on the above addresses on port 8500
![Consul](images/consul-consul-service-mesh.png?raw=true "Consul")

You will be able to access Nomad on the above addresses on port 4646
![Nomad](images/nomad-consul-service-mesh.png?raw=true "Nomad")

You will be able to access Fabio on the above addresses on port 9998
![Fabio](images/fabio-consul-service-mesh.png?raw=true "Fabio")

You will be able to ssh into the instances as user ubuntu
`ssh ubuntu@13.239.110.170`  
```                                                  
Warning: Permanently added '13.239.110.170' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-1060-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun Mar 15 18:15:18 UTC 2020

  System load:  0.0               Users logged in:        0
  Usage of /:   30.0% of 7.69GB   IP address for eth0:    172.31.3.88
  Memory usage: 12%               IP address for docker0: 172.17.0.1
  Swap usage:   0%                IP address for nomad:   172.26.64.1
  Processes:    132

0 packages can be updated.
0 updates are security updates.



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@hashiqube1:~$
```
