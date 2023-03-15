# Hashicorp Packer
#
# https://www.packer.io/
#

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "azure-arm" "windows-2016" {
  client_id     = "${var.azure_client_id}"
  client_secret = "${var.azure_client_secret}"
  #tenant_id                         = "${var.azure_tenant_id}"
  subscription_id                   = "${var.azure_subscription_id}"
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2016-Datacenter"
  image_version                     = "latest"
  managed_image_name                = "windows-2016"
  location                          = "${var.azure_region}"
  managed_image_resource_group_name = "resourcegroup"
  os_type                           = "windows"
  vm_size                           = "Standard_DS2_v2"
  communicator                      = "winrm"
  winrm_insecure                    = true
  winrm_use_ssl                     = true
  winrm_username                    = "packer_user"
  shared_image_gallery_destination {
    gallery_name        = "SharedImageGallery"
    image_name          = "windows-2016"
    image_version       = "${local.azure_version_number}"
    replication_regions = ["${var.azure_region}"]
    resource_group      = "resourcegroup"
  }
  azure_tags = {
    vm_name = "windows-2016"
  }
}

source "amazon-ebs" "windows-2016" {
  force_deregister = true
  access_key       = "${var.aws_access_key}"
  secret_key       = "${var.aws_secret_key}"
  region           = "${var.aws_region}"
  ami_name         = "windows-2016-${local.version_number}"
  instance_type    = "${var.aws_instance_type}"
  user_data_file   = "./windows/windowsserver/scripts/bootstrap.txt"
  communicator     = "winrm"
  winrm_username   = "Administrator"
  winrm_insecure   = true
  winrm_use_ssl    = true
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2016-English-Full-Base*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["801119661308"]
  }
}

source "googlecompute" "windows-2016" {
  project_id          = "${var.gcp_project_id}"
  account_file        = "${var.gcp_account_file}"
  disk_size           = "${var.disk_size}"
  image_name          = "windows-2016-${local.version_number}"
  source_image_family = "windows-2016"
  communicator        = "winrm"
  winrm_insecure      = true
  winrm_use_ssl       = true
  winrm_username      = "packer_user"
  zone                = "${var.gcp_zone}"
  metadata = {
    windows-startup-script-cmd = "winrm quickconfig -quiet & net user /add packer_user & net localgroup administrators packer_user /add & winrm set winrm/config/service/auth @{Basic=\"true\"}"
  }
  image_labels = {
    vm_name = "windows-2016"
  }
  image_family = "soe-windows-2016"
}

source "vagrant" "windows-2016" {
  source_path = "jborean93/WindowsServer2016"
  provider    = "virtualbox"
  # the Vagrant builder currently only supports the ssh communicator
  communicator    = "ssh"
  ssh_username    = "vagrant"
  ssh_password    = "vagrant"
  teardown_method = "suspend"
  skip_package    = true
  box_name        = "windows-2016"
  output_dir      = "${var.build_directory}/windows-2016/vagrant"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.azure-arm.windows-2016", "source.amazon-ebs.windows-2016", "source.googlecompute.windows-2016", "source.vagrant.windows-2016"]

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
    only          = ["vagrant.windows-2016"]
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
      "ansible_ssh_pass=${build.User} version_number=${local.version_number} ansible_shell_type=cmd ansible_shell_executable=None rule_2_3_1_5=false win_skip_for_test=true rule_2_3_1_1=false"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/Windows-2016-CIS/site.yml"
    only          = ["vagrant.windows-2016"]
  }

  provisioner "powershell" {
    script = "./windows/windowsserver/scripts/ConfigureRemotingForAnsible.ps1"
    only   = ["azure-arm.windows-2016"]
  }

  provisioner "ansible" {
    command   = "./packer/scripts/ansible.sh"
    user      = "${build.User}"
    use_proxy = false
    extra_arguments = [
      #"-v",
      "--extra-vars",
      "ansible_winrm_server_cert_validation=ignore ansible_connection=winrm ansible_shell_type=powershell ansible_shell_executable=None ansible_user=${build.User}"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/roles/ansible-role-example-role/site.yml"
    only          = ["amazon-ebs.windows-2016", "googlecompute.windows-2016", "azure-arm.windows-2016"]
  }

  provisioner "ansible" {
    command   = "./scripts/ansible.sh"
    user      = "${build.User}"
    use_proxy = false
    extra_arguments = [
      #"-v",
      "--extra-vars",
      "ansible_winrm_server_cert_validation=ignore ansible_connection=winrm ansible_shell_type=powershell ansible_shell_executable=None ansible_user=${build.User} section01_patch=true section02_patch=false section09_patch=true section17_patch=true section18_patch=false section19_patch=false rule_2_3_1_5=false rule_2_3_1_6=false"
    ]
    host_alias    = "none"
    playbook_file = "../../ansible/galaxy/roles/Windows-2016-CIS/site.yml"
    only          = ["amazon-ebs.windows-2016", "googlecompute.windows-2016", "azure-arm.windows-2016"]
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
    only = ["azure-arm.windows-2016"]
  }

  # Install EC2Launch
  provisioner "powershell" {
    inline = [
      "Write-Host \"Download EC2Launch to temp folder $env:Temp\"", 
      "Invoke-WebRequest -Uri https://s3.amazonaws.com/ec2-downloads-windows/EC2Launch/latest/EC2-Windows-Launch.zip -OutFile $env:Temp/EC2-Windows-Launch.zip",
      "Invoke-WebRequest -Uri https://s3.amazonaws.com/ec2-downloads-windows/EC2Launch/latest/install.ps1 -OutFile $env:Temp/EC2Launch-Install.ps1",
      "Write-Host Install EC2Launch", 
      "Invoke-Expression -Command $env:Temp/EC2Launch-Install.ps1"
    ]
    only = ["amazon-ebs.windows-2016"]
  }

  # Print out EC2Launch Version
  provisioner "powershell" {
    inline = [
      "Write-Host EC2Launch Version",
      "Test-ModuleManifest -Path \"C:\\ProgramData\\Amazon\\EC2-Windows\\Launch\\Module\\Ec2Launch.psd1\""]
      only = ["amazon-ebs.windows-2016"]
  }

  provisioner "powershell" {
    inline = [
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/InitializeInstance.ps1 -Schedule",
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/SysprepInstance.ps1 -NoShutdown"
    ]
    only = ["amazon-ebs.windows-2016"]
  }

  provisioner "powershell" {
    inline = [
      "Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State",
      "GCESysprep -no_shutdown"
    ]
    only = ["googlecompute.windows-2016"]
  }
}
