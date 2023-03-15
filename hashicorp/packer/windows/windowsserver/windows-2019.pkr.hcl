# Hashicorp Packer
#
# https://www.packer.io/
#

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "azure-arm" "windows-2019" {
  client_id     = "${var.azure_client_id}"
  client_secret = "${var.azure_client_secret}"
  #tenant_id                         = "${var.azure_tenant_id}"
  subscription_id                   = "${var.azure_subscription_id}"
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2019-Datacenter"
  image_version                     = "latest"
  managed_image_name                = "windows-2019"
  location                          = "${var.azure_region}"
  managed_image_resource_group_name = "resourcegroup"
  os_type                           = "windows"
  vm_size                           = "Standard_DS2_v2"
  communicator                      = "winrm"
  winrm_username                    = "packer_user"
  winrm_insecure                    = true
  winrm_use_ssl                     = true
  shared_image_gallery_destination {
    gallery_name        = "SharedImageGallery"
    image_name          = "windows-2019"
    image_version       = "${local.azure_version_number}"
    replication_regions = ["${var.azure_region}"]
    resource_group      = "resourcegroup"
  }
  azure_tags = {
    vm_name       = "windows-2019"
    image_version = "${local.version_number}"
  }
}

source "amazon-ebs" "windows-2019" {
  force_deregister = true
  access_key       = "${var.aws_access_key}"
  secret_key       = "${var.aws_secret_key}"
  region           = "${var.aws_region}"
  ami_name         = "windows-2019-${local.version_number}"
  instance_type    = "${var.aws_instance_type}"
  user_data_file   = "./windows/windowsserver/scripts/bootstrap.txt"
  communicator     = "winrm"
  winrm_username   = "Administrator"
  winrm_insecure   = true
  winrm_use_ssl    = true
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2019-English-Full-Base*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["801119661308"]
  }
}

source "googlecompute" "windows-2019" {
  project_id          = "${var.gcp_project_id}"
  account_file        = "${var.gcp_account_file}"
  disk_size           = "${var.disk_size}"
  image_name          = "windows-2019-${local.version_number}"
  source_image_family = "windows-2019"
  communicator        = "winrm"
  winrm_username      = "packer_user"
  winrm_insecure      = true
  winrm_use_ssl       = true
  zone                = "${var.gcp_zone}"
  metadata = {
    windows-startup-script-cmd = "winrm quickconfig -quiet & net user /add packer_user & net localgroup administrators packer_user /add & winrm set winrm/config/service/auth @{Basic=\"true\"}"
  }
  image_labels = {
    vm_name = "windows-2019"
  }
  image_family = "soe-windows-2019"
}

source "vagrant" "windows-2019" {
  source_path = "jborean93/WindowsServer2019"
  provider    = "virtualbox"
  # the Vagrant builder currently only supports the ssh communicator
  communicator    = "ssh"
  ssh_username    = "vagrant"
  ssh_password    = "vagrant"
  teardown_method = "suspend"
  skip_package    = true
  box_name        = "windows-2019"
  output_dir      = "${var.build_directory}/windows-2019/vagrant"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.azure-arm.windows-2019", "source.amazon-ebs.windows-2019", "source.googlecompute.windows-2019", "source.vagrant.windows-2019"]

  provisioner "powershell" {
    script = "./windows/windowsserver/scripts/ConfigureRemotingForAnsible.ps1"
    only   = ["azure-arm.windows-2019"]
  }

  provisioner "ansible" {
    command   = "./scripts/ansible.sh"
    user      = "${build.User}"
    use_proxy = false
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_ARGS='-o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'",
      "ANSIBLE_NOCOLOR=True"
    ]
    extra_arguments = [
      #"-v",
      "--extra-vars",
      "ansible_ssh_pass=${build.User} version_number=${local.version_number} ansible_shell_type=cmd ansible_shell_executable=None"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/roles/ansible-role-example-role/site.yml"
    only          = ["vagrant.windows-2019"]
  }

  provisioner "ansible" {
    command   = "./scripts/ansible.sh"
    user      = "vagrant"
    use_proxy = false
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_ARGS='-o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'",
      "ANSIBLE_NOCOLOR=True"
    ]
    extra_arguments = [
      #"-v",
      "--extra-vars",
      "ansible_ssh_pass=vagrant version_number=${local.version_number} ansible_shell_type=cmd ansible_shell_executable=None rule_2_3_1_5=false win_skip_for_test=true rule_2_3_1_1=false"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/Windows-2019-CIS/site.yml"
    only          = ["vagrant.windows-2019"]
  }

  provisioner "ansible" {
    command   = "./scripts/ansible.sh"
    user      = "vagrant"
    use_proxy = false
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_ARGS='-o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'",
      "ANSIBLE_NOCOLOR=True"
    ]
    extra_arguments = [
      # "-vvv",
      "--extra-vars",
      "ansible_ssh_pass=vagrant version_number=${local.version_number} ansible_shell_type=cmd ansible_shell_executable=None ansbile_become=yes ansible_become_method=runas"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/roles/ansible-role-vm-config/site.yml"
    only          = ["vagrant.windows-2019"]
  }

  provisioner "ansible" {
    command   = "./scripts/ansible.sh"
    user      = "${build.User}"
    use_proxy = false
    extra_arguments = [
      #"-v",
      "--extra-vars",
      "ansible_winrm_server_cert_validation=ignore version_number=${local.version_number}"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/roles/ansible-role-example-role/site.yml"
    only          = ["amazon-ebs.windows-2019", "googlecompute.windows-2019", "azure-arm.windows-2019"]
  }

  /*
  provisioner "ansible" {
    command   = "./scripts/ansible.sh"
    user      = "${build.User}"
    use_proxy = false
    extra_arguments = [
      #"-v",
      "--extra-vars",
      "ansible_winrm_server_cert_validation=ignore version_number=${local.version_number}"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/ansible-role-win_openssh/site.yml"
    only          = ["amazon-ebs.windows-2019", "googlecompute.windows-2019", "azure-arm.windows-2019"]
  }
  */
  
  provisioner "ansible" {
    command   = "./scripts/ansible.sh"
    user      = "${build.User}"
    use_proxy = false
    extra_arguments = [
      #"-v",
      "--extra-vars",
      "ansible_winrm_server_cert_validation=ignore version_number=${local.version_number}"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/roles/ansible-role-example-role/site.yml"
    only          = ["amazon-ebs.windows-2019", "googlecompute.windows-2019", "azure-arm.windows-2019"]
  }

  provisioner "ansible" {
    command   = "./scripts/ansible.sh"
    user      = "${build.User}"
    use_proxy = false
    extra_arguments = [
      #"-v",
      "--extra-vars",
      "ansible_winrm_server_cert_validation=ignore section02_patch=false rule_2_3_1_5=false rule_2_3_1_1=false win_skip_for_test=true rule_2_3_1_5=false rule_2_3_1_6=false"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/Windows-2019-CIS/site.yml"
    only          = ["amazon-ebs.windows-2019", "googlecompute.windows-2019", "azure-arm.windows-2019"]
  }

  provisioner "shell-local" {
    inline = ["curl -s https://api.ipify.org/?format=none"]
  }

  provisioner "powershell" {
    inline = [
      "Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State",
      "C:\\windows\\system32/sysprep\\sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
    only = ["azure-arm.windows-2019"]
  }

  provisioner "powershell" {
    inline = [
      "Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State",
      "GCESysprep -no_shutdown"
    ]
    only = ["googlecompute.windows-2019"]
  }
}
