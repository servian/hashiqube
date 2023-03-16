# Hashicorp Packer
#
# https://www.packer.io/
#

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "azure-arm" "ubuntu-2204" {
  client_id     = "${var.azure_client_id}"
  client_secret = "${var.azure_client_secret}"
  #tenant_id                        = "${var.azure_tenant_id}"
  subscription_id                   = "${var.azure_subscription_id}"
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "Canonical"
  image_sku                         = "22_04-lts-gen2"
  image_version                     = "latest"
  managed_image_name                = "ubuntu-2204"
  location                          = "${var.azure_region}"
  managed_image_resource_group_name = "resourcegroup"
  os_type                           = "linux"
  vm_size                           = "Standard_DS2_v2"
  shared_image_gallery_destination {
    gallery_name        = "SharedImageGallery"
    image_name          = "ubuntu-2204"
    image_version       = "${local.azure_version_number}"
    replication_regions = ["${var.azure_region}"]
    resource_group      = "resourcegroup"
  }
  azure_tags = {
    vm_name = "ubuntu-2204"
  }
}

source "amazon-ebs" "ubuntu-2204" {
  source_ami_filter {
    filters = {
      name         = "*ubuntu-jammy-22.04-amd64-server*"
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
  ami_name      = "ubuntu-2204-${local.version_number}"
  tags = {
    vm_name = "ubuntu-2204"
  }
}

source "googlecompute" "ubuntu-2204" {
  project_id          = "${var.gcp_project_id}"
  account_file        = "${var.gcp_account_file}"
  disk_size           = "${var.disk_size}"
  image_name          = "ubuntu-2204-${local.version_number}"
  source_image_family = "ubuntu-2204-lts"
  ssh_username        = "packer"
  zone                = "${var.gcp_zone}"
  image_labels = {
    vm_name = "ubuntu-2204"
  }
  image_family = "soe-ubuntu-2204-lts"
}

source "vagrant" "ubuntu-2204" {
  source_path     = "ubuntu/jammy64"
  template        = "linux/ubuntu/templates/ubuntu/2204/Vagrantfile.tpl"
  provider        = "virtualbox"
  teardown_method = "suspend"
  skip_package    = true
  communicator    = "ssh"
  box_name        = "ubuntu-2204"
  output_dir      = "${var.build_directory}/ubuntu-2204/vagrant"
}

source "docker" "ubuntu-2204" {
  image   = "ubuntu:22.04"
  commit  = false
  discard = true
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.docker.ubuntu-2204", "source.vagrant.ubuntu-2204", "source.azure-arm.ubuntu-2204", "source.amazon-ebs.ubuntu-2204", "source.googlecompute.ubuntu-2204"]

  provisioner "shell" {
    inline = ["cat /etc/os-release"]
  }

  provisioner "ansible" {
    command = "./scripts/ansible.sh"
    user    = "${build.User}"
    extra_arguments = [
      "-vvv",
      "--tags", "always,day0",
      "--extra-vars", "ansible_python_interpreter=/vagrant/ansible/ansible-venv/bin/python ansible_become=true version_number=${local.version_number}"
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
      "--extra-vars", "ansible_python_interpreter=/vagrant/ansible/ansible-venv/bin/python foo=bar"
    ]
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/UBUNTU22-CIS/site.yml"
    only          = ["vagrant.ubuntu-2204", "azure-arm.ubuntu-2204", "googlecompute.ubuntu-2204"]
  }

  provisioner "ansible" {
    command = "./scripts/ansible.sh"
    user    = "${build.User}"
    extra_arguments = [
      #"-v",
      "--extra-vars", "ansible_python_interpreter=/vagrant/ansible/ansible-venv/bin/python foo=bar"
    ]
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/UBUNTU22-CIS/site.yml"
    only          = ["amazon-ebs.ubuntu-2204"]
  }

  provisioner "shell-local" {
    inline = ["curl -s https://api.ipify.org/?format=none"]
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
    only            = ["azure-arm.ubuntu-2204"]
  }
}

