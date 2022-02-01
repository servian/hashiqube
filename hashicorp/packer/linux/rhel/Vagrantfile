# -*- mode: ruby -*-
# vi: set ft=ruby :

rhel_version = 7
if "#{ENV['RHEL_VERSION']}" != ""
  rhel_version = "#{ENV['RHEL_VERSION']}"
end

use_activationkey = false
if "#{ENV['RHSM_ACTIVATIONKEY']}" != ""
  use_activationkey = true
end

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  # Guest additions not install during packaging
  #config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vagrant.plugins = ["vagrant-registration", "vagrant-vbguest"]

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.enabled = false
  end  

  # Require fix: https://github.com/projectatomic/adb-vagrant-registration/pull/127
  if Vagrant.has_plugin?('vagrant-registration')
    #config.registration.skip = true
    config.registration.name = "packer-rhel"
    if use_activationkey
      config.registration.org = "#{ENV['RHSM_ORG']}" 
      config.registration.activationkey = "#{ENV['RHSM_ACTIVATIONKEY']}"
    else
      config.registration.username = "#{ENV['RHSM_USERNAME']}" 
      config.registration.password = "#{ENV['RHSM_PASSWORD']}" 
    end
  end    
  # VirtualBox.
  config.vm.define "virtualbox" do |virtualbox|
    virtualbox.vm.hostname = "virtualbox-rhel-#{rhel_version}"
    virtualbox.vm.box = "rhel/#{rhel_version}"
    virtualbox.vm.box_url = "file://builds/virtualbox-rhel-#{rhel_version}.box"

    config.vm.provider :virtualbox do |v|
      v.gui = false
      v.memory = 1024
      v.cpus = 1
    end

    config.vm.provision "shell", inline: "echo Hello, World"
  end

end
