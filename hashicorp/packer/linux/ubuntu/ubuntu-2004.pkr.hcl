# Hashicorp Packer
#
# https://www.packer.io/
#

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "azure-arm" "ubuntu-2004" {
  client_id     = "${var.azure_client_id}"
  client_secret = "${var.azure_client_secret}"
  #tenant_id                         = "${var.azure_tenant_id}"
  subscription_id                   = "${var.azure_subscription_id}"
  image_offer                       = "0001-com-ubuntu-server-focal"
  image_publisher                   = "Canonical"
  image_sku                         = "20_04-lts-gen2"
  image_version                     = "latest"
  managed_image_name                = "ubuntu-2004"
  location                          = "${var.azure_region}"
  managed_image_resource_group_name = "resourcegroup"
  os_type                           = "linux"
  vm_size                           = "Standard_DS2_v2"
  shared_image_gallery_destination {
    gallery_name        = "SharedImageGallery"
    image_name          = "ubuntu-2004"
    image_version       = "${local.azure_version_number}"
    replication_regions = ["${var.azure_region}"]
    resource_group      = "resourcegroup"
  }
  azure_tags = {
    vm_name = "ubuntu-2004"
  }
}

source "amazon-ebs" "ubuntu-2004" {
  source_ami_filter {
    filters = {
      name         = "*ubuntu-focal-20.04-amd64-server*"
      architecture = "x86_64"
    }
    owners = ["099720109477"]
    most_recent = true
  }
  access_key    = "${var.aws_access_key}"
  secret_key    = "${var.aws_secret_key}"
  region        = "${var.aws_region}"
  instance_type = "${var.aws_instance_type}"
  ssh_username  = "ubuntu"
  ami_name      = "ubuntu-2004-${local.version_number}"
  tags = {
    vm_name = "ubuntu-2004"
  }
}

source "googlecompute" "ubuntu-2004" {
  project_id          = "${var.gcp_project_id}"
  account_file        = "${var.gcp_account_file}"
  disk_size           = "${var.disk_size}"
  image_name          = "ubuntu-2004-${local.version_number}"
  source_image_family = "ubuntu-2004-lts"
  ssh_username        = "packer"
  zone                = "${var.gcp_zone}"
  image_labels = {
    vm_name = "ubuntu-2004"
  }
  image_family = "soe-ubuntu-2004-lts"
}

source "vagrant" "ubuntu-2004" {
  source_path     = "ubuntu/focal64"
  template        = "linux/ubuntu/templates/ubuntu/2004/Vagrantfile.tpl"
  provider        = "virtualbox"
  teardown_method = "suspend"
  skip_package    = true
  communicator    = "ssh"
  box_name        = "ubuntu-2004"
  output_dir      = "${var.build_directory}/ubuntu-2004/vagrant"
}

source "docker" "ubuntu-2004" {
  image   = "ubuntu:20.04"
  commit  = false
  discard = true
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.docker.ubuntu-2004", "source.vagrant.ubuntu-2004", "source.azure-arm.ubuntu-2004", "source.amazon-ebs.ubuntu-2004", "source.googlecompute.ubuntu-2004"]

  provisioner "shell" {
    inline = ["cat /etc/os-release"]
  }

  provisioner "ansible" {
    command = "./scripts/ansible.sh"
    user    = "${build.User}"
    extra_arguments = [
      #"-v",
      "--tags", "always,day0",
      "--extra-vars", "ansible_become=true version_number=${local.version_number}"
    ]
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/roles/ansible-role-example-role/site.yml"
  }

  provisioner "ansible" {
    command = "./scripts/ansible.sh"
    user    = "${build.User}"
    extra_arguments = [
      #"-v",
      "--extra-vars", "foo=bar"
    ]
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/UBUNTU20-CIS/site.yml"
    only          = ["vagrant.ubuntu-2004", "azure-arm.ubuntu-2004", "googlecompute.ubuntu-2004"]
  }

  provisioner "ansible" {
    command = "./scripts/ansible.sh"
    extra_arguments = [
      #"-v",
      "--extra-vars", "foo=bar"
    ]
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/UBUNTU20-CIS/site.yml"
    only          = ["amazon-ebs.ubuntu-2004"]
  }

  provisioner "shell-local" {
    inline = ["curl -s https://api.ipify.org/?format=none"]
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
    only            = ["azure-arm.ubuntu-2004"]
  }
}

