/* helpful hints
 * https://www.terraform.io/docs/configuration/functions/
 * Localstack Terraform configuration https://docs.localstack.cloud/integrations/terraform/
 * https://github.com/localstack/localstack-pro-samples/tree/master/terraform-resources
*/

provider "aws" {
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "us-east-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
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

resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@$"
  min_numeric      = 6
  min_special      = 2
  min_upper        = 3
}

resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-bucket"
}

resource "aws_s3_bucket_acl" "my-bucket-acl" {
  bucket = aws_s3_bucket.my-bucket.id
  acl    = "private"
}

resource "aws_security_group" "default-sec-group" {
  name        = "default-sec-group"
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

/* Error: error creating Lambda Function (1): InternalFailure 
resource "aws_api_gateway_authorizer" "demo" {
  name                   = "demo"
  rest_api_id            = aws_api_gateway_rest_api.demo.id
  authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role.arn
  type                   = "TOKEN"
}

resource "aws_api_gateway_rest_api" "demo" {
  name = "auth-demo"
}

resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "s3:ListBucket",
    "Resource": "arn:aws:s3:::test-bucket"
  }
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = aws_iam_role.invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "s3:ListBucket",
    "Resource": "arn:aws:s3:::example_bucket"
  }
}
EOF
}

resource "aws_iam_role" "lambda" {
  name = "demo-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "s3:ListBucket",
    "Resource": "arn:aws:s3:::example_bucket"
  }
}
EOF
}

resource "aws_lambda_function" "authorizer" {
  filename         = "lambda.zip"
  function_name    = "api_gateway_authorizer"
  role             = aws_iam_role.lambda.arn
  handler          = "lambda.hello"
  runtime          = "python3.7"
  source_code_hash = filebase64sha256("lambda.zip")
}
*/

/* Takes ages to launch, and never finish, disabling for now 
resource "aws_elasticsearch_domain" "example" {
  domain_name           = "test-domain"
  elasticsearch_version = "1.5"

  cluster_config {
    instance_type = "r4.large.elasticsearch"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain = "TestDomain"
  }
}
*/

/* Error: error creating ElastiCache Cache Cluster: InternalFailure: API action 'CreateCacheCluster' for service 'elasticache' not yet implemented or pro feature
resource "aws_elasticache_cluster" "my-redis" {
  cluster_id           = "my-redis-cluster"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
}
*/

/* Error: Error creating DB Parameter Group: InternalFailure: API action 'CreateDBParameterGroup' for service 'rds' not yet implemented or pro feature
resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "mysql5.6"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
}
*/
