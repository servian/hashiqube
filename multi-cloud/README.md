# terraform-hashicorp-hashiqube
Terraform Registry Module for HashiQube - a Development Lab using all the HashiCorp Products.

This repo contains a [Terraform](https://www.terraform.io/) module for provisioning [HashiQube](https://servian.github.io/hashiqube) <br />
A __Development__ lab running all [HashiCorp](https://www.hashicorp.com/) products.

__DO NOT USE HASHIQUBE IN PRODUCTION__

## Introduction

Hello friends!

Hashicorp clustered Consul, Nomad and Vault HA in GCP, AWS and Azure using Terraform.

Last year I started learning about #Hashicorp products, and to help me do that, I created a Virtual Machine running all the Hashicorp products, you can read more about HashiQube the Development Lab that runs all Hashicorp products here:
[HashiQube at HashiTalks 2020](https://www.hashicorp.com/resources/hashiqube-a-development-lab-using-all-the-hashicorp-products/)

[HashiQube Website](https://servian.github.io/hashiqube)

This year I wanted to improve my Terraform knowledge while studying for my Terraform Associate Exam and I decided to try spin up HashiQube on the Clouds, GCP, Azure and AWS using Terraform.

I have written a Terraform Registry module that can help you do exactly that, https://registry.terraform.io/modules/star3am/hashiqube/hashicorp/latest

This module can launch a Vault, Consul and Nomad (Clustered) on all clouds or just 1 if you only have 1 Cloud account.

Give it a try and most of all have fun with this module, your feedback is always greatly appreciated!

#Hashicorp #Vault #Consul #Nomad #HashiQube #Servian #Curious

## Purpose
HashiQube has been created to help developers and engineers to get up to speed with HashiCorp products. It can be used for development, testing or training. HashiQube gives all interested parties the empowerment to deploy these tools in a way covers multiple use cases effectively providing a 'concept to completion' testbed using open-source HashiCorp products.

- [What is a Terraform module](#what-is-a-terraform-module)
- [How do you use this module](#how-do-you-use-this-module)
    - [Prerequisites](#prerequisites)
    - [Module Inputs](#inputs)
    - [Module Outputs](#outputs)

## What is a Terraform module
A Terraform "module" refers to a self-contained package of Terraform configurations that are managed as a group.
For more information around modules refer to the Terraform [documentation](https://www.terraform.io/docs/modules/index.html)

## How do you use this module

To use this module You have 2 options

1) You clone this repository and edit the variables.tf file and main.tf

2) You can look for an example in the examples folder, this will use the module from the Terraform Registry

In both cases you only need to edit the variables.tf

I've tried to include the batteries, so all you need to do is enable your cloud (or all 3) in `variables.tf`

```
variable "deploy_to_aws" {
  type        = bool
  default     = false
  description = "Deploy Hashiqube on AWS"
}

variable "deploy_to_gcp" {
  type        = bool
  default     = false
  description = "Deploy Hashiqube on GCP"
}

variable "deploy_to_azure" {
  type        = bool
  default     = false
  description = "Deploy Hashiqube on Azure"
}
```

You can then apply this Terraform configuration via:

`terraform init`

```
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Using previously-installed hashicorp/null v2.1.2
- Using previously-installed hashicorp/external v1.2.0
- Using previously-installed hashicorp/google v3.40.0
- Using previously-installed hashicorp/azurerm v2.29.0
- Using previously-installed hashicorp/aws v3.8.0
- Using previously-installed hashicorp/template v2.1.2

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* hashicorp/external: version = "~> 1.2.0"
* hashicorp/null: version = "~> 2.1.2"
* hashicorp/template: version = "~> 2.1.2"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

`terraform apply`

```
data.external.myipaddress: Refreshing state...
module.gcp-hashiqube[0].data.google_compute_subnetwork.hashiqube: Refreshing state...
module.aws-hashiqube[0].data.aws_ami.ubuntu: Refreshing state...
null_resource.hashiqube: Creating...
module.gcp-hashiqube[0].google_service_account.hashiqube: Creating...
module.gcp-hashiqube[0].google_compute_address.hashiqube: Creating...
null_resource.hashiqube: Creation complete after 0s [id=2557045852748484833]
module.gcp-hashiqube[0].google_compute_firewall.my_ipaddress: Creating...
module.aws-hashiqube[0].aws_key_pair.hashiqube: Creating...
module.aws-hashiqube[0].aws_eip.hashiqube: Creating...
module.aws-hashiqube[0].aws_iam_role.hashiqube: Creating...
module.aws-hashiqube[0].aws_security_group.hashiqube: Creating...
module.aws-hashiqube[0].aws_key_pair.hashiqube: Creation complete after 1s [id=hashiqube]
module.aws-hashiqube[0].aws_eip.hashiqube: Creation complete after 1s [id=eipalloc-0be659b75912d804d]
module.gcp-hashiqube[0].google_compute_firewall.azure_hashiqube_ip[0]: Creating...
module.gcp-hashiqube[0].google_compute_firewall.aws-hashiqube_ip[0]: Creating...
module.gcp-hashiqube[0].google_service_account.hashiqube: Creation complete after 4s [id=projects/thermal-formula-256223/serviceAccounts/sa-consul-compute-prod@thermal-formula-256223.iam.gserviceaccount.com]
module.gcp-hashiqube[0].google_project_iam_member.hashiqube: Creating...
module.aws-hashiqube[0].aws_iam_role.hashiqube: Creation complete after 2s [id=hashiqube]
module.aws-hashiqube[0].aws_iam_role_policy.hashiqube: Creating...
module.aws-hashiqube[0].aws_iam_instance_profile.hashiqube: Creating...
module.aws-hashiqube[0].aws_security_group.hashiqube: Creation complete after 3s [id=sg-025c9b87ece934e5c]
module.aws-hashiqube[0].aws_security_group_rule.aws_hashiqube[0]: Creating...
module.azure-hashiqube[0].azurerm_resource_group.hashiqube: Creating...
module.aws-hashiqube[0].aws_security_group_rule.aws_hashiqube[0]: Creation complete after 0s [id=sgrule-987379194]
module.azure-hashiqube[0].azurerm_resource_group.hashiqube: Creation complete after 1s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube]
module.azure-hashiqube[0].azurerm_virtual_network.hashiqube: Creating...
module.azure-hashiqube[0].azurerm_public_ip.hashiqube: Creating...
module.aws-hashiqube[0].aws_iam_role_policy.hashiqube: Creation complete after 3s [id=hashiqube:hashiqube]
module.aws-hashiqube[0].aws_iam_instance_profile.hashiqube: Creation complete after 4s [id=hashiqube]
module.gcp-hashiqube[0].google_compute_address.hashiqube: Still creating... [10s elapsed]
module.gcp-hashiqube[0].google_compute_firewall.my_ipaddress: Still creating... [10s elapsed]
module.azure-hashiqube[0].azurerm_public_ip.hashiqube: Creation complete after 5s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube/providers/Microsoft.Network/publicIPAddresses/hashiqube]
module.gcp-hashiqube[0].null_resource.hashiqube: Creating...
module.aws-hashiqube[0].aws_security_group_rule.azure_hashiqube[0]: Creating...
module.gcp-hashiqube[0].null_resource.hashiqube: Creation complete after 0s [id=4275072845816936591]
module.aws-hashiqube[0].aws_security_group_rule.azure_hashiqube[0]: Creation complete after 1s [id=sgrule-2223201042]
module.gcp-hashiqube[0].google_compute_firewall.aws-hashiqube_ip[0]: Still creating... [10s elapsed]
module.gcp-hashiqube[0].google_compute_firewall.azure_hashiqube_ip[0]: Still creating... [10s elapsed]
module.gcp-hashiqube[0].google_project_iam_member.hashiqube: Still creating... [10s elapsed]
module.gcp-hashiqube[0].google_compute_firewall.my_ipaddress: Creation complete after 14s [id=projects/thermal-formula-256223/global/firewalls/hashiqube-my-ipaddress]
module.gcp-hashiqube[0].google_compute_address.hashiqube: Creation complete after 15s [id=projects/thermal-formula-256223/regions/australia-southeast1/addresses/hashiqube]
module.gcp-hashiqube[0].data.template_file.hashiqube: Reading...
module.aws-hashiqube[0].data.template_file.hashiqube: Reading...
module.aws-hashiqube[0].null_resource.hashiqube: Creating...
module.azure-hashiqube[0].null_resource.hashiqube: Creating...
module.aws-hashiqube[0].aws_security_group_rule.gcp_hashiqube[0]: Creating...
module.aws-hashiqube[0].null_resource.hashiqube: Creation complete after 0s [id=7498116740625141680]
module.gcp-hashiqube[0].data.template_file.hashiqube: Read complete after 0s [id=aaee44e2e7bf83153ee128d3e56e7fa81af72ee1ceecc19caa32ea0b353d1ec9]
module.aws-hashiqube[0].data.template_file.hashiqube: Read complete after 0s [id=aaee44e2e7bf83153ee128d3e56e7fa81af72ee1ceecc19caa32ea0b353d1ec9]
module.gcp-hashiqube[0].google_compute_firewall.gcp_hashiqube_ip[0]: Creating...
module.azure-hashiqube[0].data.template_file.hashiqube_user_data: Reading...
module.azure-hashiqube[0].null_resource.hashiqube: Creation complete after 0s [id=773650861847054347]
module.azure-hashiqube[0].data.template_file.hashiqube_user_data: Read complete after 0s [id=aaee44e2e7bf83153ee128d3e56e7fa81af72ee1ceecc19caa32ea0b353d1ec9]
module.aws-hashiqube[0].aws_instance.hashiqube: Creating...
module.gcp-hashiqube[0].google_compute_instance_template.hashiqube: Creating...
module.aws-hashiqube[0].aws_security_group_rule.gcp_hashiqube[0]: Creation complete after 1s [id=sgrule-3999887141]
module.gcp-hashiqube[0].google_project_iam_member.hashiqube: Creation complete after 12s [id=thermal-formula-256223/roles/compute.networkViewer/serviceaccount:sa-consul-compute-prod@thermal-formula-256223.iam.gserviceaccount.com]
module.gcp-hashiqube[0].google_compute_firewall.azure_hashiqube_ip[0]: Creation complete after 12s [id=projects/thermal-formula-256223/global/firewalls/azure-hashiqube-ip]
module.gcp-hashiqube[0].google_compute_firewall.aws-hashiqube_ip[0]: Creation complete after 13s [id=projects/thermal-formula-256223/global/firewalls/aws-hashiqube-ip]
module.azure-hashiqube[0].azurerm_virtual_network.hashiqube: Still creating... [10s elapsed]
module.azure-hashiqube[0].azurerm_virtual_network.hashiqube: Creation complete after 12s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube/providers/Microsoft.Network/virtualNetworks/hashiqube]
module.azure-hashiqube[0].azurerm_subnet.hashiqube: Creating...
module.gcp-hashiqube[0].google_compute_firewall.gcp_hashiqube_ip[0]: Still creating... [10s elapsed]
module.aws-hashiqube[0].aws_instance.hashiqube: Still creating... [10s elapsed]
module.gcp-hashiqube[0].google_compute_instance_template.hashiqube: Still creating... [10s elapsed]
module.gcp-hashiqube[0].google_compute_firewall.gcp_hashiqube_ip[0]: Creation complete after 13s [id=projects/thermal-formula-256223/global/firewalls/gcp-hashiqube-ip]
module.gcp-hashiqube[0].google_compute_instance_template.hashiqube: Creation complete after 14s [id=projects/thermal-formula-256223/global/instanceTemplates/hashiqube20201002032841119300000001]
module.gcp-hashiqube[0].google_compute_region_instance_group_manager.hashiqube: Creating...
module.azure-hashiqube[0].azurerm_subnet.hashiqube: Still creating... [10s elapsed]
module.azure-hashiqube[0].azurerm_subnet.hashiqube: Creation complete after 11s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube/providers/Microsoft.Network/virtualNetworks/hashiqube/subnets/hashiqube]
module.azure-hashiqube[0].azurerm_network_interface.hashiqube: Creating...
module.azure-hashiqube[0].azurerm_network_interface.hashiqube: Creation complete after 2s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube/providers/Microsoft.Network/networkInterfaces/hashiqube]
module.azure-hashiqube[0].azurerm_network_security_group.azure_hashiqube_ip[0]: Creating...
module.azure-hashiqube[0].azurerm_network_security_group.gcp_hashiqube_ip[0]: Creating...
module.azure-hashiqube[0].azurerm_network_security_group.aws_hashiqube_ip[0]: Creating...
module.azure-hashiqube[0].azurerm_network_security_group.my_ipaddress: Creating...
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Creating...
module.azure-hashiqube[0].azurerm_network_security_group.azure_hashiqube_ip[0]: Creation complete after 1s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube/providers/Microsoft.Network/networkSecurityGroups/azure_hashiqube_ip]
module.azure-hashiqube[0].azurerm_network_security_group.gcp_hashiqube_ip[0]: Creation complete after 1s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube/providers/Microsoft.Network/networkSecurityGroups/gcp_hashiqube_ip]
module.aws-hashiqube[0].aws_instance.hashiqube: Still creating... [20s elapsed]
module.gcp-hashiqube[0].google_compute_region_instance_group_manager.hashiqube: Still creating... [10s elapsed]
module.azure-hashiqube[0].azurerm_network_security_group.my_ipaddress: Still creating... [10s elapsed]
module.azure-hashiqube[0].azurerm_network_security_group.aws_hashiqube_ip[0]: Still creating... [10s elapsed]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Still creating... [10s elapsed]
module.azure-hashiqube[0].azurerm_network_security_group.aws_hashiqube_ip[0]: Creation complete after 11s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube/providers/Microsoft.Network/networkSecurityGroups/aws_hashiqube_ip]
module.azure-hashiqube[0].azurerm_network_security_group.my_ipaddress: Creation complete after 12s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube/providers/Microsoft.Network/networkSecurityGroups/hashiqube]
module.aws-hashiqube[0].aws_instance.hashiqube: Still creating... [30s elapsed]
module.aws-hashiqube[0].aws_instance.hashiqube: Creation complete after 34s [id=i-05f3cb075b40de94d]
module.aws-hashiqube[0].aws_eip_association.eip_assoc: Creating...
module.gcp-hashiqube[0].google_compute_region_instance_group_manager.hashiqube: Still creating... [20s elapsed]
module.aws-hashiqube[0].aws_eip_association.eip_assoc: Creation complete after 1s [id=eipassoc-0f9265328843fffda]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Still creating... [20s elapsed]
module.gcp-hashiqube[0].google_compute_region_instance_group_manager.hashiqube: Creation complete after 26s [id=projects/thermal-formula-256223/regions/australia-southeast1/instanceGroupManagers/hashiqube]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Still creating... [30s elapsed]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Still creating... [40s elapsed]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Still creating... [50s elapsed]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Still creating... [1m0s elapsed]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Still creating... [1m10s elapsed]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Still creating... [1m20s elapsed]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Still creating... [1m30s elapsed]
module.azure-hashiqube[0].azurerm_linux_virtual_machine.hashiqube: Creation complete after 1m39s [id=/subscriptions/c6b045ed-f7bb-44d3-bf8c-a57b2eb14579/resourceGroups/hashiqube/providers/Microsoft.Compute/virtualMachines/hashiqube]

Apply complete! Resources: 34 added, 0 changed, 0 destroyed.

Outputs:

aaa_welcome = Your HashiQube instance is busy launching, usually this takes ~5 minutes.
Below are some links to open in your browser, and commands you can copy and paste in a terminal to login via SSH into your HashiQube instance.
Thank you for using this module, you are most welcome to fork this repository to make it your own.
** DO NOT USE THIS IN PRODUCTION **

aab_instructions = Use the Hashiqube SSH output below to login to your instance
To get Vault Shamir keys and Root token do "sudo cat /etc/vault/init.file"

aws_hashiqube-consul = http://54.206.165.xxx:8500
aws_hashiqube-fabio-lb = http://54.206.165.xxx:9999
aws_hashiqube-fabio-ui = http://54.206.165.xxx:9998
aws_hashiqube-nomad = http://54.206.165.xxx:4646
aws_hashiqube-ssh = ssh ubuntu@54.206.165.xxx
aws_hashiqube-vault = http://54.206.165.xxx:8200
aws_hashiqube_ip = 54.206.165.xxx
azure_hashiqube-consul = http://13.75.237.xxx:8500
azure_hashiqube-fabio-lb = http://13.75.237.xxx:9999
azure_hashiqube-fabio-ui = http://13.75.237.xxx:9998
azure_hashiqube-nomad = http://13.75.237.xxx:4646
azure_hashiqube-ssh = ssh ubuntu@13.75.237.xxx
azure_hashiqube-vault = http://13.75.237.xxx:8200
azure_hashiqube_ip = 13.75.237.xxx
gcp_hashiqube-consul = http://34.87.219.xxx:8500
gcp_hashiqube-fabio-lb = http://34.87.219.xxx:9999
gcp_hashiqube-fabio-ui = http://34.87.219.xxx:9998
gcp_hashiqube-nomad = http://34.87.219.xxx:4646
gcp_hashiqube-ssh = ssh ubuntu@34.87.219.xxx
gcp_hashiqube-vault = http://34.87.219.xxx:8200
gcp_hashiqube_ip = 34.87.219.xxx
your_ipaddress = 103.234.250.xxx
```

When you do Terraform Apply, this is the output you will see.
![HashiQube SSH](https://github.com/star3am/terraform-hashicorp-hashiqube/blob/master/images/hashiqube-01-terraform-apply.png?raw=true "HashiQube Terraform Apply")

Now that HashiQube is up, let's SSH into the instance.
![HashiQube SSH](https://github.com/star3am/terraform-hashicorp-hashiqube/blob/master/images/hashiqube-03-ssh.png?raw=true "HashiQube SSH")

You can check the Vault, Consul and Nomad Cluster status.
![HashiQube SSH](https://github.com/star3am/terraform-hashicorp-hashiqube/blob/master/images/hashiqube-02-clusters-status.png?raw=true "HashiQube SSH")

We can access Hashicorp Consul
![Consul](https://github.com/star3am/terraform-hashicorp-hashiqube/blob/master/images/hashiqube-04-consul.png?raw=true "Consul")

We can also access Hashicorp Nomad
![Nomad](https://github.com/star3am/terraform-hashicorp-hashiqube/blob/master/images/hashiqube-05-nomad.png?raw=true "Nomad")

We can now enter Vault's Initial Root Token to login
![HashiQube Logged in](https://github.com/star3am/terraform-hashicorp-hashiqube/blob/master/images/hashiqube-06-vault_initial-logged-in.png?raw=true "HashiQube Logged in")

We can also access Fabio Load Balancer, running as a Nomad job
![Fabio](https://github.com/star3am/terraform-hashicorp-hashiqube/blob/master/images/hashiqube-07-fabio.png?raw=true "Fabio")

### Prerequisites

To make use of this module, you need a Cloud account.
AWS, GCP and Azure is supported.

- You need a Public/Private SSH key pair.
- A Cloud account

__Instructions on how to setup a SSH Key pair__: <br />
[SSH Create a Public/Private Key Pair](https://www.ssh.com/ssh/keygen/) <br /><br />
__Instructions on how to setup Cloud Account__: <br />
[Google Cloud Installation and Setup](https://cloud.google.com/deployment-manager/docs/step-by-step-guide/installation-and-setup)<br />
[AWS Cloud Installation and Setup](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)

#### Inputs

| Name | Type | Default | Description |
|------|-------------|------|---------|
| deploy_to_aws | bool | false | Deploy Hashiqube on AWS |
| deploy_to_gcp | bool | false | Deploy Hashiqube on GCP |
| deploy_to_azure | bool | false | Deploy Hashiqube on Azure |
| whitelist_cidr | string | "" | Additional CIDR to whitelist |
| ssh_public_key | string | "~/.ssh/id_rsa.pub" | SSH public key |
| azure_region | string | "Australia East" | The region in which all Azure resources will be launched |
| azure_instance_type | string | "Standard_F2" | Azure instance type |
| aws_credentials | string | "~/.aws/credentials" | AWS credentials file location |
| aws_profile | string | "default" | AWS profile |
| aws_region | string | "ap-southeast-2" | The region in which all AWS resources will be launched |
| aws_instance_type | string | "t2.medium" | AWS instance type |
| gcp_credentials | string | "~/.gcp/credentials.json" | GCP Credentials file |
| gcp_project | string | "thermal-formula-256223" | GCP project ID |
| gcp_region | string | "australia-southeast1" | The region in which all GCP resources will be launched |
| gcp_account_id | string | "sa-consul-compute-prod" | GCP Account ID |
| gcp_cluster_name | string | "hashiqube" | GCP Cluster name |
| gcp_cluster_description | string | "hashiqube" | The description for the cluster |
| gcp_cluster_tag_name | string | "hashiqube" | GCP Cluster tag to apply |
| gcp_cluster_size | number | 1 | GCP size of the cluster |
| gcp_zones| list(string) | ["australia-southeast1-a","australia-southeast1-b","australia-southeast1-c"] | The zones accross which GCP resources will be launched |
| gcp_machine_type | string | "n1-standard-1" | GCP machine type |
| gcp_custom_metadata | map(string) | {} | A map of metadata key value pairs to assign to the Compute Instance metadata |
| gcp_root_volume_disk_size_gb | number | 16 | The size, in GB, of the root disk volume on each HashiQube node |
| gcp_root_volume_disk_type | string | "pd-standard" | The GCE disk type. Can be either pd-ssd, local-ssd, or pd-standard |

#### Outputs

| Name | Description |
|------|-------------|
| ip_address | The IP address of HashiQube instance |
| aws_hashiqube-consul | http://aws_hashiqube-consul:8500
| aws_hashiqube-fabio-lb | http://aws_hashiqube-fabio-lb:9999
| aws_hashiqube-fabio-ui | http://aws_hashiqube-fabio-ui:9998
| aws_hashiqube-nomad | http://aws_hashiqube-nomad:4646
| aws_hashiqube-waipoint | https://aws_hashiqube-nomad:9702
| aws_hashiqube-ssh | ssh ubuntu@54.206.165.xxx
| aws_hashiqube-vault | http://aws_hashiqube-vault:8200
| aws_hashiqube_ip | 54.206.165.xxx
| azure_hashiqube-consul | http://azure_hashiqube-consul:8500
| azure_hashiqube-fabio-lb | http://azure_hashiqube-fabio-lb:9999
| azure_hashiqube-fabio-ui | http://azure_hashiqube-fabio-ui:9998
| azure_hashiqube-nomad | http://azure_hashiqube-nomad:4646
| azure_hashiqube-waipoint | https://azure_hashiqube-nomad:9702
| azure_hashiqube-ssh | ssh ubuntu@13.75.237.xxx
| azure_hashiqube-vault | http://azure_hashiqube-vault:8200
| azure_hashiqube_ip | 13.75.237.xxx
| gcp_hashiqube-consul | http://gcp_hashiqube-consul:8500
| gcp_hashiqube-fabio-lb | http://gcp_hashiqube-fabio-lb:9999
| gcp_hashiqube-fabio-ui | http://gcp_hashiqube-fabio-ui:9998
| gcp_hashiqube-nomad | http://gcp_hashiqube-nomad:4646
| gcp_hashiqube-waipoint | https://gcp_hashiqube-nomad:9702
| gcp_hashiqube-ssh | ssh ubuntu@34.87.219.xxx
| gcp_hashiqube-vault | http://gcp_hashiqube-vault:8200
| gcp_hashiqube_ip | 34.87.219.xxx
| your_ipaddress | 103.234.250.xxx
