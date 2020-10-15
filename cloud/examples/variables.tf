# for more variables see variables.tf in main folder

variable "deploy_to_aws" {
  type        = bool
  default     = true
  description = "Deploy Hashiqube on AWS"
}

variable "deploy_to_gcp" {
  type        = bool
  default     = true
  description = "Deploy Hashiqube on GCP"
}

variable "deploy_to_azure" {
  type        = bool
  default     = true
  description = "Deploy Hashiqube on Azure"
}