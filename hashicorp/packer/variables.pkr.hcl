# All generated input variables will be of 'string' type as this is how Packer JSON
# views them; you can change their type later on. Read the variables type
# constraints documentation
# https://www.packer.io/docs/templates/hcl_templates/variables#type-constraints for more info.

# locals blocks
locals {
  version_number       = formatdate("YYYYMMDDhhmm", timestamp())
  azure_version_number = formatdate("YYYY.MM.DDhhmm", timestamp())
}

# variables
variable "build_directory" {
  type    = string
  default = "./output"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "memory" {
  type    = string
  default = "512"
}

variable "disk_size" {
  type    = string
  default = "1024"
}

variable "aws_access_key" {
  type    = string
  default = "${env("AWS_ACCESS_KEY")}"
}

variable "aws_secret_key" {
  type    = string
  default = "${env("AWS_SECRET_ACCESS_KEY")}"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "aws_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "aws_source_ami_centos-79" {
  type    = string
  default = "ami-0ffc7af9c06de0077"
}

variable "aws_source_ami_centos-83" {
  type    = string
  default = "ami-0c8ad4b0ff2d20c79"
}

variable "aws_source_ami_redhat-79" {
  type    = string
  default = "ami-00d05da9ad5c69bfd"
}

variable "aws_source_ami_redhat-83" {
  type    = string
  default = "ami-02a403e9f22ebf62b"
}

variable "aws_source_ami_ubuntu-1804" {
  type    = string
  default = "ami-0bd1a64868721e9ef"
}

variable "aws_source_ami_ubuntu-2004" {
  type    = string
  default = "ami-0b9e641f013a385af"
}

variable "azure_client_id" {
  type    = string
  default = "${env("AZURE_CLIENT_ID")}"
}

variable "azure_client_secret" {
  type      = string
  default   = "${env("AZURE_CLIENT_SECRET")}"
  sensitive = true
}

variable "azure_resource_group" {
  type    = string
  default = "resourcegroup" # "${env("AZURE_RESOURCE_GROUP")}"
}

variable "azure_shared_image_gallery" {
  type    = string
  default = "SharedImageGallery" # "${env("AZURE_SHARED_IMAGE_GALLERY")}"
}

variable "azure_subscription_id" {
  type    = string
  default = "${env("AZURE_SUBSCRIPTION_ID")}"
}

variable "azure_tenant_id" {
  type    = string
  default = "${env("AZURE_TENANT_ID")}"
}

variable "azure_region" {
  type    = string
  default = "Australia East"
}

variable "gcp_account_file" {
  type    = string
  default = "${env("GCP_ACCOUNT_FILE")}"
}

variable "gcp_project_id" {
  type    = string
  default = "${env("GCP_PROJECT_ID")}"
}

variable "gcp_zone" {
  type    = string
  default = "australia-southeast1-a"
}

variable "image_version_number" {
  type    = string
  default = "1970.01.010000"
}
