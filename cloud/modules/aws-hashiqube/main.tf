# https://www.terraform.io/docs/providers/aws/r/instance.html

resource "null_resource" "hashiqube" {
  triggers = {
    deploy_to_aws      = var.deploy_to_aws
    deploy_to_azure    = var.deploy_to_azure
    deploy_to_gcp      = var.deploy_to_gcp
    whitelist_cidr     = var.whitelist_cidr
    my_ipaddress       = var.my_ipaddress
    ssh_public_key     = var.ssh_public_key
    azure_hashiqube_ip = var.azure_hashiqube_ip
    gcp_hashiqube_ip   = var.gcp_hashiqube_ip
    vault_enabled      = lookup(var.vault, "enabled")
    vault_version      = lookup(var.vault, "version")
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_iam_role" "hashiqube" {
  name = "hashiqube"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "hashiqube" {
  name = "hashiqube"
  role = aws_iam_role.hashiqube.name
}

resource "aws_iam_role_policy" "hashiqube" {
  name = "hashiqube"
  role = aws_iam_role.hashiqube.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "template_file" "hashiqube" {
  template = file("${path.module}/../../modules/shared/startup_script")
  vars = {
    HASHIQUBE_AWS_IP   = aws_eip.hashiqube.public_ip
    HASHIQUBE_AZURE_IP = var.azure_hashiqube_ip == null ? "" : var.azure_hashiqube_ip
    HASHIQUBE_GCP_IP   = var.gcp_hashiqube_ip == null ? "" : var.gcp_hashiqube_ip
    VAULT_ENABLED      = lookup(var.vault, "enabled")
  }
}

resource "aws_instance" "hashiqube" {
  ami                 = data.aws_ami.ubuntu.id
  instance_type       = var.aws_instance_type
  security_groups     = [aws_security_group.hashiqube.name]
  key_name            = aws_key_pair.hashiqube.key_name
  user_data_base64    = base64gzip(data.template_file.hashiqube.rendered)
  iam_instance_profile = aws_iam_instance_profile.hashiqube.name
  tags = {
    Name = "hashiqube"
  }
}

resource "aws_key_pair" "hashiqube" {
  key_name   = "hashiqube"
  public_key = file(var.ssh_public_key)
}

resource "aws_security_group" "hashiqube" {
  name = "hashiqube"
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ipaddress}/32"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["${var.my_ipaddress}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "aws_hashiqube" {
  count             = var.deploy_to_aws ? 1 : 0
  type              = "ingress"
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["${aws_eip.hashiqube.public_ip}/32"]
  from_port         = 0
  security_group_id = aws_security_group.hashiqube.id
}

resource "aws_security_group_rule" "azure_hashiqube" {
  count             = var.deploy_to_azure ? 1 : 0
  type              = "ingress"
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["${var.azure_hashiqube_ip}/32"]
  from_port         = 0
  security_group_id = aws_security_group.hashiqube.id
}

resource "aws_security_group_rule" "gcp_hashiqube" {
  count             = var.deploy_to_gcp ? 1 : 0
  type              = "ingress"
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["${var.gcp_hashiqube_ip}/32"]
  from_port         = 0
  security_group_id = aws_security_group.hashiqube.id
}

resource "aws_security_group_rule" "whitelist_cidr" {
  count             = var.whitelist_cidr != "" ? 1 : 0
  type              = "ingress"
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.whitelist_cidr]
  from_port         = 0
  security_group_id = aws_security_group.hashiqube.id
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.hashiqube.id
  allocation_id = aws_eip.hashiqube.id
}

resource "aws_eip" "hashiqube" {
  vpc = true
}
