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

resource "aws_security_group" "default" {
  name        = "default"
  description = "Default Security Group"

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
