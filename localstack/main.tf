/* helpful hints
 * https://www.terraform.io/docs/configuration/functions/
*/

provider "aws" {
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "us-east-1"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4567"
    cloudformation = "http://localhost:4581"
    cloudwatch     = "http://localhost:4582"
    dynamodb       = "http://localhost:4569"
    es             = "http://localhost:4578"
    firehose       = "http://localhost:4573"
    iam            = "http://localhost:4593"
    kinesis        = "http://localhost:4568"
    lambda         = "http://localhost:4574"
    route53        = "http://localhost:4580"
    redshift       = "http://localhost:4577"
    s3             = "http://localhost:4572"
    secretsmanager = "http://localhost:4584"
    ses            = "http://localhost:4579"
    sns            = "http://localhost:4575"
    sqs            = "http://localhost:4576"
    ssm            = "http://localhost:4583"
    stepfunctions  = "http://localhost:4585"
    sts            = "http://localhost:4592"
  }
}

resource "aws_s3_bucket" "localstack-s3-bucket" {
  bucket = "localstack-s3-bucket"
  acl    = "public-read"

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
  }
}

locals {
  ec2_instance_with_index = zipmap(
    range(length(var.ec2_instance)),
    var.ec2_instance
  )
  ec2_instance_disk_allocations_basic = [
    for instance in var.ec2_instance : [
      for disk in instance.ebs_disks : {
        ami_id    = instance.ami_id
        subnet_id = instance.ami_id
        disksize  = disk.disksize
        disktype  = disk.disktype
      }
    ]
  ]
  ec2_instance_disk_allocations_flattened = flatten(local.ec2_instance_disk_allocations_basic)
  ec2_instance_disk_allocations_indexed = zipmap(
    range(length(local.ec2_instance_disk_allocations_flattened)),
    local.ec2_instance_disk_allocations_flattened
  )
}

resource "null_resource" "ec2_instance_disk_allocations_indexed" {
  for_each = local.ec2_instance_disk_allocations_indexed
  triggers = {
    availability_zone = "melbourne"
    ami_id            = each.value.ami_id
    subnet_id         = each.value.subnet_id
    disksize          = each.value.disksize
    disktype          = each.value.disktype
  }
}
