# https://registry.terraform.io/modules/star3am/hashiqube/hashicorp

# terraform init
# terraform plan
# terraform apply

module "hashiqube" {
  source          = "star3am/hashiqube/hashicorp"
  version         = "0.0.12"
  deploy_to_aws   = var.deploy_to_aws
  deploy_to_gcp   = var.deploy_to_gcp
  deploy_to_azure = var.deploy_to_azure
}
