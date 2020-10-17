provider "google" {
  version     = "~> 3.40.0"
  credentials = file(var.gcp_credentials)
  project     = var.gcp_project
  region      = var.gcp_region
}

provider "azurerm" {
  version = "~> 2.29.0"
  features {}
}

provider "aws" {
  version                = "~> 3.8.0"
  region                 = var.aws_region
  shared_credentials_file = file(var.aws_credentials)
  profile                 = var.aws_profile
}

data "external" "myipaddress" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

resource "null_resource" "hashiqube" {
  triggers = {
    deploy_to_azure = var.deploy_to_azure
    deploy_to_gcp   = var.deploy_to_gcp
    deploy_to_aws   = var.deploy_to_aws
    my_ipaddress    = data.external.myipaddress.result.ip
  }
}

module "gcp-hashiqube" {
  count = var.deploy_to_gcp ? 1 : 0
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git::git@github.com:star3am/terraform-hashicorp-hashiqube.git//modules/gcp-hashiqube?ref=v0.0.1"
  source                       = "./modules/gcp-hashiqube"
  deploy_to_aws                = var.deploy_to_aws
  deploy_to_azure              = var.deploy_to_azure
  deploy_to_gcp                = var.deploy_to_gcp
  whitelist_cidr               = var.whitelist_cidr
  gcp_project                  = var.gcp_project
  gcp_credentials              = var.gcp_credentials
  gcp_cluster_description      = var.gcp_cluster_description
  gcp_cluster_name             = var.gcp_cluster_name
  gcp_cluster_size             = var.gcp_cluster_size
  gcp_machine_type             = var.gcp_machine_type
  gcp_region                   = var.gcp_region
  gcp_account_id               = var.gcp_account_id
  gcp_root_volume_disk_size_gb = var.gcp_root_volume_disk_size_gb
  gcp_root_volume_disk_type    = var.gcp_root_volume_disk_type
  gcp_zones                    = var.gcp_zones
  gcp_cluster_tag_name         = var.gcp_cluster_tag_name
  gcp_custom_metadata          = var.gcp_custom_metadata
  ssh_public_key               = var.ssh_public_key
  aws_hashiqube_ip             = var.deploy_to_aws ? try(module.aws-hashiqube[0].hashiqube_ip, null) : null
  azure_hashiqube_ip           = var.deploy_to_azure ? try(module.azure-hashiqube[0].hashiqube_ip, null) : null
  my_ipaddress                 = data.external.myipaddress.result.ip
  vault = {
    enabled = true
    version = "1.4.1"
  }
}

module "aws-hashiqube" {
  count = var.deploy_to_aws ? 1 : 0
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git::git@github.com:star3am/terraform-hashicorp-hashiqube.git//modules/aws-hashiqube?ref=v0.0.1"
  source             = "./modules/aws-hashiqube"
  deploy_to_aws      = var.deploy_to_aws
  deploy_to_azure    = var.deploy_to_azure
  deploy_to_gcp      = var.deploy_to_gcp
  ssh_public_key     = var.ssh_public_key
  aws_credentials    = var.aws_credentials
  aws_instance_type  = var.aws_instance_type
  aws_profile         = var.aws_profile
  aws_region         = var.aws_region
  whitelist_cidr     = var.whitelist_cidr
  azure_hashiqube_ip = var.deploy_to_azure ? try(module.azure-hashiqube[0].hashiqube_ip, null) : null
  gcp_hashiqube_ip   = var.deploy_to_gcp ? try(module.gcp-hashiqube[0].hashiqube_ip, null) : null
  my_ipaddress       = data.external.myipaddress.result.ip
  vault              = {
    enabled = true
    version = "1.4.1"
  }
}

module "azure-hashiqube" {
  count = var.deploy_to_azure ? 1 : 0
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git::git@github.com:star3am/terraform-hashicorp-hashiqube.git//modules/azure-hashiqube?ref=v0.0.1"
  source              = "./modules/azure-hashiqube"
  deploy_to_aws       = var.deploy_to_aws
  deploy_to_azure     = var.deploy_to_azure
  deploy_to_gcp       = var.deploy_to_gcp
  whitelist_cidr      = var.whitelist_cidr
  ssh_public_key      = var.ssh_public_key
  aws_hashiqube_ip    = var.deploy_to_aws ? try(module.aws-hashiqube[0].hashiqube_ip, null) : null
  gcp_hashiqube_ip    = var.deploy_to_gcp ? try(module.gcp-hashiqube[0].hashiqube_ip, null) : null
  my_ipaddress        = data.external.myipaddress.result.ip
  azure_region        = var.azure_region
  azure_instance_type = var.azure_instance_type
  vault               = {
    enabled = true
    version = "1.4.1"
  }
}