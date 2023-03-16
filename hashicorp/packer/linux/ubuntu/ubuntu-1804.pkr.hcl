# Hashicorp Packer
#
# https://www.packer.io/
#

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "azure-arm" "ubuntu-1804" {
  client_id     = "${var.azure_client_id}"
  client_secret = "${var.azure_client_secret}"
  #tenant_id                         = "${var.azure_tenant_id}"
  subscription_id                   = "${var.azure_subscription_id}"
  image_offer                       = "UbuntuServer"
  image_publisher                   = "Canonical"
  image_sku                         = "18_04-lts-gen2"
  image_version                     = "latest"
  managed_image_name                = "ubuntu-1804"
  location                          = "${var.azure_region}"
  managed_image_resource_group_name = "resourcegroup"
  os_type                           = "linux"
  vm_size                           = "Standard_DS2_v2"
  shared_image_gallery_destination {
    gallery_name        = "SharedImageGallery"
    image_name          = "ubuntu-1804"
    image_version       = "${local.azure_version_number}"
    replication_regions = ["${var.azure_region}"]
    resource_group      = "resourcegroup"
  }
  azure_tags = {
    vm_name = "ubuntu-1804"
  }
}

source "amazon-ebs" "ubuntu-1804" {
  source_ami_filter {
    filters = {
      name         = "*/hvm-ssd/ubuntu-bionic-18.04-amd64-server*"
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
  ami_name      = "ubuntu-1804-${local.version_number}"
  tags = {
    vm_name = "ubuntu-1804"
  }
}

source "googlecompute" "ubuntu-1804" {
  project_id          = "${var.gcp_project_id}"
  account_file        = "${var.gcp_account_file}"
  disk_size           = "${var.disk_size}"
  image_name          = "ubuntu-1804-${local.version_number}"
  source_image_family = "ubuntu-1804-lts"
  ssh_username        = "packer"
  zone                = "${var.gcp_zone}"
  image_labels = {
    vm_name = "ubuntu-1804"
  }
  image_family = "soe-ubuntu-1804-lts"
}

source "vagrant" "ubuntu-1804" {
  source_path     = "ubuntu/bionic64"
  template        = "linux/ubuntu/templates/ubuntu/1804/Vagrantfile.tpl"
  provider        = "virtualbox"
  teardown_method = "suspend"
  skip_package    = true
  communicator    = "ssh"
  box_name        = "ubuntu-1804"
  output_dir      = "${var.build_directory}/ubuntu-1804/vagrant"
}

source "docker" "ubuntu-1804" {
  image   = "ubuntu:18.04"
  commit  = false
  discard = true
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.docker.ubuntu-1804", "source.vagrant.ubuntu-1804", "source.azure-arm.ubuntu-1804", "source.amazon-ebs.ubuntu-1804", "source.googlecompute.ubuntu-1804"]

  provisioner "shell" {
    inline = [
      "cat /etc/os-release"
    ]
  }

  provisioner "ansible" {
    command = "./scripts/ansible.sh"
    extra_arguments = [
      #"-v",
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3 ansible_become=true version_number=${local.version_number}"
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
    playbook_file = "../../ansible/galaxy/roles/UBUNTU18-CIS/site.yml"
    only          = ["vagrant.ubuntu-1804", "azure-arm.ubuntu-1804", "googlecompute.ubuntu-1804"]
  }

  provisioner "ansible" {
    command = "./scripts/ansible.sh"
    user    = "${build.User}"
    extra_arguments = [
      #"-v",
      "--extra-vars", "system_is_ec2=true"
    ]
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/UBUNTU18-CIS/site.yml"
    only          = ["amazon-ebs.ubuntu-1804"]
  }

  provisioner "shell-local" {
    inline = ["curl -s https://api.ipify.org/?format=none"]
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
    only            = ["azure-arm.ubuntu-1804"]
  }
}
