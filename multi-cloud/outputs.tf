output "your_ipaddress" {
  value = data.external.myipaddress.result.ip
}

output "aaa_welcome" {
  value = <<WELCOME
Your HashiQube instance is busy launching, usually this takes ~5 minutes.
Below are some links to open in your browser, and commands you can copy and paste in a terminal to login via SSH into your HashiQube instance.
Thank you for using this module, you are most welcome to fork this repository to make it your own.
** DO NOT USE THIS IN PRODUCTION **
WELCOME
  description = <<WELCOME
A Welcome message. Your HashiQube instance is busy launching, usually this takes ~5 minutes.
Below are some links to open in your browser, and commands you can copy and paste in a terminal to login via SSH into your HashiQube instance.
Thank you for using this module, you are most welcome to fork this repository to make it your own.
** DO NOT USE THIS IN PRODUCTION **
WELCOME
}

output "aab_instructions" {
  value = <<INSTRUCTIONS
Use the Hashiqube SSH output below to login to your instance
To get Vault Shamir keys and Root token do "sudo cat /etc/vault/init.file"
INSTRUCTIONS
  description = <<INSTRUCTIONS
Use the Hashiqube SSH output below to login to your instance
To get Vault Shamir keys and Root token do "sudo cat /etc/vault/init.file"
INSTRUCTIONS
}

# AWS
output "aws_hashiqube_ip" {
  value = var.deploy_to_aws ? try(module.aws-hashiqube[0].hashiqube_ip, null) : null
}

output "aws_hashiqube-ssh" {
  value = var.deploy_to_aws ? try("ssh ubuntu@${module.aws-hashiqube[0].hashiqube_ip}", null) : null
}

output "aws_hashiqube-consul" {
  value = var.deploy_to_aws ? try("http://${module.aws-hashiqube[0].hashiqube_ip}:8500", null) : null
}

output "aws_hashiqube-nomad" {
  value = var.deploy_to_aws ? try("http://${module.aws-hashiqube[0].hashiqube_ip}:4646", null) : null
}

output "aws_hashiqube-waypoint" {
  value = var.deploy_to_aws ? try("https://${module.aws-hashiqube[0].hashiqube_ip}:9702", null) : null
}

output "aws_hashiqube-vault" {
  value = var.deploy_to_aws ? try("http://${module.aws-hashiqube[0].hashiqube_ip}:8200", null) : null
}

output "aws_hashiqube-fabio-ui" {
  value = var.deploy_to_aws ? try("http://${module.aws-hashiqube[0].hashiqube_ip}:9998", null) : null
}

output "aws_hashiqube-fabio-lb" {
  value = var.deploy_to_aws ? try("https://${module.aws-hashiqube[0].hashiqube_ip}:9999", null) : null
}

# Azure
output "azure_hashiqube_ip" {
  value = var.deploy_to_azure ? try(module.azure-hashiqube[0].hashiqube_ip, null) : null
}

output "azure_hashiqube-ssh" {
  value = var.deploy_to_azure ? try("ssh ubuntu@${module.azure-hashiqube[0].hashiqube_ip}", null) : null
}

output "azure_hashiqube-consul" {
  value = var.deploy_to_azure ? try("http://${module.azure-hashiqube[0].hashiqube_ip}:8500", null) : null
}

output "azure_hashiqube-nomad" {
  value = var.deploy_to_azure ? try("http://${module.azure-hashiqube[0].hashiqube_ip}:4646", null) : null
}

output "azure_hashiqube-waypoint" {
  value = var.deploy_to_azure ? try("https://${module.azure-hashiqube[0].hashiqube_ip}:9702", null) : null
}

output "azure_hashiqube-vault" {
  value = var.deploy_to_azure ? try("http://${module.azure-hashiqube[0].hashiqube_ip}:8200", null) : null
}

output "azure_hashiqube-fabio-ui" {
  value = var.deploy_to_azure ? try("http://${module.azure-hashiqube[0].hashiqube_ip}:9998", null) : null
}

output "azure_hashiqube-fabio-lb" {
  value = var.deploy_to_azure ? try("http://${module.azure-hashiqube[0].hashiqube_ip}:9999", null) : null
}

# GCP
output "gcp_hashiqube_ip" {
  value = var.deploy_to_gcp ? try(module.gcp-hashiqube[0].hashiqube_ip, null) : null
}

output "gcp_hashiqube-ssh" {
  value = var.deploy_to_gcp ? try("ssh ubuntu@${module.gcp-hashiqube[0].hashiqube_ip}", null) : null
}

output "gcp_hashiqube-consul" {
  value = var.deploy_to_gcp ? try("http://${module.gcp-hashiqube[0].hashiqube_ip}:8500", null) : null
}

output "gcp_hashiqube-nomad" {
  value = var.deploy_to_gcp ? try("http://${module.gcp-hashiqube[0].hashiqube_ip}:4646", null) : null
}

output "gcp_hashiqube-waypoint" {
  value = var.deploy_to_gcp ? try("https://${module.gcp-hashiqube[0].hashiqube_ip}:9702", null) : null
}

output "gcp_hashiqube-vault" {
  value = var.deploy_to_gcp ? try("http://${module.gcp-hashiqube[0].hashiqube_ip}:8200", null) : null
}

output "gcp_hashiqube-fabio-ui" {
  value = var.deploy_to_gcp ? try("http://${module.gcp-hashiqube[0].hashiqube_ip}:9998", null) : null
}

output "gcp_hashiqube-fabio-lb" {
  value = var.deploy_to_gcp ? try("http://${module.gcp-hashiqube[0].hashiqube_ip}:9999", null) : null
}
