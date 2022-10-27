variable "tower_cli_remote" {
  type    = string
  default = "~/.local/bin/awx"
}

variable "tower_cli_local" {
  type    = string
  default = "/Users/riaannolan/bin/awx"
}

variable "tower_host" {
  type    = string
  default = "https://10.9.99.10:8043/"
}

data "external" "tower_token" {
  program = ["/bin/bash", "-c", "${var.tower_cli_local} login --conf.host ${var.tower_host} --conf.insecure --conf.username admin --conf.password \"password\""]
}

locals {
  timestamp = timestamp()
}

resource "null_resource" "awx_cli" {
  triggers = {
    timestamp = local.timestamp
  }

  provisioner "remote-exec" {
    inline = [
      "${var.tower_cli_remote} --conf.host ${var.tower_host} -f human job_templates launch 9 --monitor --filter status --conf.insecure --conf.token ${data.external.tower_token.result.token}",
    ]

    connection {
      type        = "ssh"
      user        = "vagrant"
      password    = "vagrant"
      host        = "10.9.99.10"
    }
  }
  
  provisioner "local-exec" {
    command = "${var.tower_cli_local} --conf.host ${var.tower_host} -f human job_templates launch 9 --monitor --filter status --conf.insecure --conf.token ${data.external.tower_token.result.token}"
  }
}
