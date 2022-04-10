# -*- mode: ruby -*-
# vi: set ft=ruby :

# create local domain name e.g user.local.dev
user = ENV["USER"].downcase
fqdn = ENV["fqdn"] || "service.consul"

# https://www.virtualbox.org/manual/ch08.html
vbox_config = [
  { '--memory' => '10240' },
  { '--cpus' => '4' },
  { '--cpuexecutioncap' => '100' },
  { '--biosapic' => 'x2apic' },
  { '--ioapic' => 'on' },
  { '--largepages' => 'on' },
  { '--natdnshostresolver1' => 'on' },
  { '--natdnsproxy1' => 'on' },
  { '--nictype1' => 'virtio' },
  { '--audio' => 'none' },
]

# machine(s) hash
machines = [
  {
    :name => "hashiqube0.#{fqdn}",
    :ip => '10.9.99.10',
    :ssh_port => '2255',
    :disksize => '10GB',
    :vbox_config => vbox_config,
    :synced_folders => [
      { :vm_path => '/osdata', :ext_rel_path => '../../', :vm_owner => 'ubuntu' },
      { :vm_path => '/var/jenkins_home', :ext_rel_path => './jenkins/jenkins_home', :vm_owner => 'ubuntu' },
    ],
  },
  # {
  #   :name => "hashiqube1.#{fqdn}",
  #   :ip => '10.9.99.11',
  #   :ssh_port => '2266',
  #   :disksize => '10GB',
  #   :vbox_config => vbox_config,
  #   :synced_folders => [
  #     { :vm_path => '/data', :ext_rel_path => '../../', :vm_owner => 'ubuntu' },
  #     { :vm_path => '/var/jenkins_home', :ext_rel_path => './jenkins/jenkins_home', :vm_owner => 'ubuntu' },
  #   ],
  # },
  # {
  #   :name => "hashiqube2.#{fqdn}",
  #   :ip => '10.9.99.12',
  #   :ssh_port => '2277',
  #   :disksize => '10GB',
  #   :vbox_config => vbox_config,
  #   :synced_folders => [
  #     { :vm_path => '/data', :ext_rel_path => '../../', :vm_owner => 'ubuntu' },
  #     { :vm_path => '/var/jenkins_home', :ext_rel_path => './jenkins/jenkins_home', :vm_owner => 'ubuntu' },
  #   ],
  # },
]

Vagrant::configure("2") do |config|

  # check for vagrant version
  Vagrant.require_version ">= 1.9.7"

  if Vagrant::Util::Platform.windows?
    COMMAND_SEPARATOR = "&"
  else
    COMMAND_SEPARATOR = ";"
  end

  # deprecated
  # if @chipset != "Apple"; then
  #   # auto install plugins, will prompt for admin password on 1st vagrant up
  #   required_plugins = %w( vagrant-disksize vagrant-hostsupdater )
  #   required_plugins.each do |plugin|
  #     exec "vagrant plugin install #{plugin}#{COMMAND_SEPARATOR}vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
  #   end
  # end

  machines.each_with_index do |machine, index|

    config.vm.box = "ubuntu/focal64"
    config.vm.define machine[:name] do |config|

      # config.disksize.size = machine[:disksize] # deprecated
      config.ssh.forward_agent = true
      config.ssh.insert_key = true
      config.vm.network "private_network", ip: "#{machine[:ip]}"
      config.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: 'ssh', auto_correct: true

      if machines.size == 1 # only expose these ports if 1 machine, else conflicts
        config.vm.network "forwarded_port", guest: 8200, host: 8200 # vault
        config.vm.network "forwarded_port", guest: 4646, host: 4646 # nomad
        config.vm.network "forwarded_port", guest: 9702, host: 9702 # waypoint
        config.vm.network "forwarded_port", guest: 19200, host: 19200 # boundary
        config.vm.network "forwarded_port", guest: 8500, host: 8500 # consul
        config.vm.network "forwarded_port", guest: 8600, host: 8600, protocol: 'udp' # consul dns
        config.vm.network "forwarded_port", guest: 8888, host: 8888 # ansible/roles/www
        config.vm.network "forwarded_port", guest: 8889, host: 8889 # docker/apache2
        config.vm.network "forwarded_port", guest: 389, host: 33389 # ldap
        config.vm.network "forwarded_port", guest: 4566, host: 4566 # localstack
        config.vm.network "forwarded_port", guest: 8088, host: 8088 # jenkins
        config.vm.network "forwarded_port", guest: 9002, host: 9002 # consul counter-dashboard
        config.vm.network "forwarded_port", guest: 9001, host: 9001 # consul counter-api
        config.vm.network "forwarded_port", guest: 9022, host: 9022 # consul counter-dashboard-test
        config.vm.network "forwarded_port", guest: 9011, host: 9011 # consul counter-api-test
        config.vm.network "forwarded_port", guest: 3306, host: 3306 # mysql
        config.vm.network "forwarded_port", guest: 5432, host: 5432 # postgres
        config.vm.network "forwarded_port", guest: 1433, host: 1433 # mssql
        config.vm.network "forwarded_port", guest: 9998, host: 9998 # fabio-dashboard
        config.vm.network "forwarded_port", guest: 9999, host: 9999 # fabiolb
        config.vm.network "forwarded_port", guest: 3333, host: 3333 # docsify

      end

      config.vm.hostname = "#{machine[:name]}"

      unless machine[:vbox_config].nil?
        config.vm.provider :virtualbox do |vb|
          machine[:vbox_config].each do |hash|
            hash.each do |key, value|
              vb.customize ['modifyvm', :id, "#{key}", "#{value}"]
            end
          end
        end
      end
      
      # if you are not on Apple M chip and want to use docker provider do:
      # vagrant up --provision-with basetools --provider docker
      # https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container
      # https://github.com/containers/podman/issues/3295
      # --tmpfs /tmp : Create a temporary filesystem in /tmp
      # --tmpfs /run : Create another temporary filesystem in /run
      # --tmpfs /run/lock : Apparently having a tmpfs in /run isn’t enough – you ALSO need one in /run/lock
      # -v /sys/fs/cgroup:/sys/fs/cgroup:ro : Mount the CGroup kernel configuration values into the container
      # https://github.com/docker/for-mac/issues/6073
      # Docker Desktop now uses cgroupv2. If you need to run systemd in a container then:
      # * Ensure your version of systemd supports cgroupv2. It must be at least systemd 247. Consider upgrading any centos:7 images to centos:8.
      # * Containers running systemd need the following options: --privileged --cgroupns=host -v /sys/fs/cgroup:/sys/fs/cgroup:rw.
      # https://betterprogramming.pub/managing-virtual-machines-under-vagrant-on-a-mac-m1-aebc650bc12c
      config.vm.provider "docker" do |docker, override|
        override.vm.box        = nil
        docker.build_dir       = "."
        docker.remains_running = true
        docker.has_ssh         = true
        docker.privileged      = true
        docker.volumes         = ['/sys/fs/cgroup:/sys/fs/cgroup:rw']
        docker.create_args     = ['--cgroupns=host', '--tmpfs=/tmp:exec', '--tmpfs=/var/lib/docker:mode=0777,dev,size=15g,suid,exec', '--tmpfs=/run', '--tmpfs=/run/lock'] # '--memory=10g', '--memory-swap=14g', '--oom-kill-disable'
        docker.env             = { "PROVIDER": "docker", "NAME": "hashiqube" }
      end

      # mount the shared folder inside the VM
      unless machine[:synced_folders].nil?
        machine[:synced_folders].each do |folder|
          config.vm.synced_folder "#{folder[:ext_rel_path]}", "#{folder[:vm_path]}", owner: "#{folder[:vm_owner]}", mount_options: ["dmode=777,fmode=777"]
          # below will mount shared folder via NFS
          # config.vm.synced_folder "#{folder[:ext_rel_path]}", "#{folder[:vm_path]}", nfs: true, nfs_udp: false, mount_options: ['nolock', 'noatime', 'lookupcache=none', 'async'], linux__nfs_options: ['rw','no_subtree_check','all_squash','async']
        end
      end

      # vagrant up --provision-with bootstrap to only run this on vagrant up
      config.vm.provision "bootstrap", preserve_order: true, type: "shell", privileged: true, inline: <<-SHELL
        echo -e '\e[38;5;198m'"BEGIN BOOTSTRAP $(date '+%Y-%m-%d %H:%M:%S')"
        echo -e '\e[38;5;198m'"running vagrant as #{user}"
        echo -e '\e[38;5;198m'"vagrant IP #{machine[:ip]}"
        echo -e '\e[38;5;198m'"vagrant fqdn #{machine[:name]}"
        echo -e '\e[38;5;198m'"vagrant index #{index}"
        cd ~\n
        grep -q "VAGRANT_IP=#{machine[:ip]}" /etc/environment
        if [ $? -eq 1 ]; then
          echo "VAGRANT_IP=#{machine[:ip]}" >> /etc/environment
        else
          sed -i "s/VAGRANT_INDEX=.*/VAGRANT_INDEX=#{index}/g" /etc/environment
        fi
        grep -q "VAGRANT_INDEX=#{index}" /etc/environment
        if [ $? -eq 1 ]; then
          echo "VAGRANT_INDEX=#{index}" >> /etc/environment
        else
          sed -i "s/VAGRANT_INDEX=.*/VAGRANT_INDEX=#{index}/g" /etc/environment
        fi
      SHELL

      # install base tools
      # vagrant up --provision-with basetools to only run this on vagrant up
      config.vm.provision "basetools", preserve_order: true, type: "shell", path: "hashiqube/basetools.sh"

      # install docker
      # vagrant up --provision-with docker to only run this on vagrant up
      config.vm.provision "docker", preserve_order: true, type: "shell", path: "docker/docker.sh"

      # docsify
      # vagrant up --provision-with docsify to only run this on vagrant up
      config.vm.provision "docsify", type: "shell", preserve_order: true, privileged: false, path: "docsify/docsify.sh"

      # install terraform
      # vagrant up --provision-with terraform to only run this on vagrant up
      config.vm.provision "terraform", preserve_order: true, type: "shell", privileged: true, path: "hashicorp/terraform.sh"


      # blast-radius

      # install vault
      # vagrant up --provision-with vault to only run this on vagrant up
      config.vm.provision "vault", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/vault.sh"

      # install consul
      # vagrant up --provision-with consul to only run this on vagrant up
      config.vm.provision "consul", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/consul.sh"

      # install nomad
      # vagrant up --provision-with nomad to only run this on vagrant up
      config.vm.provision "nomad", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/nomad.sh"

      # install waypoint
      # vagrant up --provision-with waypoint to only run this on vagrant up
      config.vm.provision "waypoint", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/waypoint.sh"

      # install boundary
      # vagrant up --provision-with boundary to only run this on vagrant up
      config.vm.provision "boundary", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/boundary.sh"

      # install packer
      # vagrant up --provision-with packer to only run this on vagrant up
      config.vm.provision "packer", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/packer.sh"

      # install sentinel
      # vagrant up --provision-with sentinel to only run this on vagrant up
      config.vm.provision "sentinel", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/sentinel.sh"

      # install localstack
      # vagrant up --provision-with localstack to only run this on vagrant up
      config.vm.provision "localstack", run: "never", type: "shell", preserve_order: true, privileged: false, path: "localstack/localstack.sh"

      # vagrant up --provision-with ldap to only run this on vagrant up
      # run ldap docker container for testing with vault (for example) ldap login
      config.vm.provision "ldap", run: "never", type: "shell", preserve_order: true, privileged: true, path: "ldap/ldap.sh"


      # vagrant up --provision-with mysql to only run this on vagrant up
      # run mysql docker container for testing with vault
      config.vm.provision "mysql", run: "never", type: "shell", preserve_order: true, privileged: false, path: "database/mysql.sh"

      # vagrant up --provision-with postgresql to only run this on vagrant up
      # run postgresql docker container for testing with vault
      config.vm.provision "postgresql", run: "never", type: "shell", preserve_order: true, privileged: false, path: "database/postgresql.sh"

      # vagrant up --provision-with mssql to only run this on vagrant up
      # run mssql docker container for testing with vault
      config.vm.provision "mssql", run: "never", type: "shell", preserve_order: true, privileged: false, path: "database/mssql.sh"

      # install apache2 with ansible
      # vagrant up --provision-with ansible_local to only run this on vagrant up
      if ARGV.include? '--provision-with'
        config.vm.provision "ansible_local" do |ansible|
          ansible.playbook     = "ansible/playbook.yml"
          ansible.verbose      = true
          ansible.install_mode = "pip"
          ansible.version      = "latest"
          ansible.become       = true
          ansible.extra_vars   = {
            www: {
              package: "apache2",
              service: "apache2",
              docroot: "/var/www/html"
            }
          }
        end
      end

      # install jenkins
      # vagrant up --provision-with jenkins to only run this on vagrant up
      config.vm.provision "jenkins", run: "never", type: "shell", preserve_order: true, privileged: false, path: "jenkins/jenkins.sh"






      







      # vagrant up --provision-with bootstrap to only run this on vagrant up
      config.vm.provision "welcome", preserve_order: true, type: "shell", privileged: true, inline: <<-SHELL
        echo -e '\e[38;5;198m'"HashiQube has now been provisioned, and your services should be running."
        echo -e '\e[38;5;198m'"Below are some links for you to get started."
        echo -e '\e[38;5;198m'"Main documentation http://localhost:3333 Open this first."
        echo -e '\e[38;5;198m'"Vault http://localhost:8200 with $(cat /etc/vault/init.file | grep Root)"
        echo -e '\e[38;5;198m'"Consul http://localhost:8500"
        echo -e '\e[38;5;198m'"Nomad http://localhost:4646"
        echo -e '\e[38;5;198m'"Fabio http://localhost:9998"
      SHELL

    end
  end
end
