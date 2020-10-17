# -*- mode: ruby -*-
# vi: set ft=ruby :

# create local domain name e.g user.local.dev
user = ENV["USER"].downcase
fqdn = ENV["fqdn"] || "service.consul"

# https://www.virtualbox.org/manual/ch08.html
vbox_config = [
  { '--memory' => '4096' },
  { '--cpus' => '2' },
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
      { :vm_path => '/data', :ext_rel_path => '../../', :vm_owner => 'ubuntu' },
      { :vm_path => '/var/jenkins_home', :ext_rel_path => './jenkins/jenkins_home', :vm_owner => 'ubuntu' },
    ],
  },
  #{
  #  :name => "hashiqube1.#{fqdn}",
  #  :ip => '10.9.99.11',
  #  :ssh_port => '2266',
  #  :disksize => '10GB',
  #  :vbox_config => vbox_config,
  #  :synced_folders => [
  #    { :vm_path => '/data', :ext_rel_path => '../../', :vm_owner => 'ubuntu' },
  #    { :vm_path => '/var/jenkins_home', :ext_rel_path => './jenkins/jenkins_home', :vm_owner => 'ubuntu' },
  #  ],
  #},
  #{
  #  :name => "hashiqube2.#{fqdn}",
  #  :ip => '10.9.99.12',
  #  :ssh_port => '2277',
  #  :disksize => '10GB',
  #  :vbox_config => vbox_config,
  #  :synced_folders => [
  #    { :vm_path => '/data', :ext_rel_path => '../../', :vm_owner => 'ubuntu' },
  #    { :vm_path => '/var/jenkins_home', :ext_rel_path => './jenkins/jenkins_home', :vm_owner => 'ubuntu' },
  #  ],
  #},
]


Vagrant::configure("2") do |config|

  # check for vagrant version
  Vagrant.require_version ">= 1.9.7"

  if Vagrant::Util::Platform.windows?
    COMMAND_SEPARATOR = "&"
  else
    COMMAND_SEPARATOR = ";"
  end

  # auto install plugins, will prompt for admin password on 1st vagrant up
  required_plugins = %w( vagrant-disksize )
  required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin}#{COMMAND_SEPARATOR}vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
  end

  machines.each_with_index do |machine, index|

    config.vm.box = "ubuntu/bionic64"
    config.vm.define machine[:name] do |config|

      config.disksize.size = machine[:disksize]
      config.ssh.forward_agent = true
      config.ssh.insert_key = true
      config.vm.network "private_network", ip: machine[:ip]
      config.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: 'ssh', auto_correct: true

      if machines.size == 1 # only expose these ports if 1 machine, else conflicts
        config.vm.network "forwarded_port", guest: 8200, host: 8200 # vault
        config.vm.network "forwarded_port", guest: 4646, host: 4646 # nomad
        config.vm.network "forwarded_port", guest: 8500, host: 8500 # consul
        config.vm.network "forwarded_port", guest: 8600, host: 8600, protocol: 'udp' # consul dns
        config.vm.network "forwarded_port", guest: 8800, host: 8800 # terraform-enterprise
        config.vm.network "forwarded_port", guest: 443, host: 4443 # terraform-enterprise
        config.vm.network "forwarded_port", guest: 8888, host: 8888 # ansible/roles/www
        config.vm.network "forwarded_port", guest: 8889, host: 8889 # docker/apache2
        config.vm.network "forwarded_port", guest: 389, host: 3389 # ldap
        config.vm.network "forwarded_port", guest: 8080, host: 8080 # localstack web
        config.vm.network "forwarded_port", guest: 7443, host: 7443 # localstack web
        config.vm.network "forwarded_port", guest: 8088, host: 8088 # jenkins
        config.vm.network "forwarded_port", guest: 9002, host: 9002 # consul counter-dashboard
        config.vm.network "forwarded_port", guest: 9001, host: 9001 # consul counter-api
        config.vm.network "forwarded_port", guest: 9022, host: 9022 # consul counter-dashboard-test
        config.vm.network "forwarded_port", guest: 9011, host: 9011 # consul counter-api-test
        config.vm.network "forwarded_port", guest: 3306, host: 3306 # mysql
        config.vm.network "forwarded_port", guest: 1433, host: 1433 # mssql
        config.vm.network "forwarded_port", guest: 5432, host: 5432 # postgres
        config.vm.network "forwarded_port", guest: 9998, host: 9998 # fabio-dashboard
        config.vm.network "forwarded_port", guest: 9999, host: 9999 # fabiolb
        config.vm.network "forwarded_port", guest: 3333, host: 3333 # docsify
        # localstack
        for port in 4567..4597 do
          config.vm.network "forwarded_port", guest: "#{port}", host: "#{port}" # localstack
        end
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
        echo -e '\e[38;5;198m'"vagrant IP "#{machine[:ip]}
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
        # install applications
        export DEBIAN_FRONTEND=noninteractive
        export PATH=$PATH:/root/.local/bin
        sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes update -o Acquire::CompressionTypes::Order::=gz
        sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes upgrade
        sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install swapspace jq curl unzip software-properties-common bzip2 git make python3-pip python3-dev python3-virtualenv golang-go apt-utils
        sudo -E -H pip3 install pip --upgrade
        sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes autoremove
        sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes clean
        sudo rm -rf /var/lib/apt/lists/partial

        # if the user IS jenkins, the we are running this from a Jenkinsfile (Scripted Pipelines)
        if [ "#{user}" != "jenkins" ]; then
          cd "#{machine[:synced_folders][0][:vm_path]}"
          # printenv
          # below is run from the Makefile, shorthand commands to run composer, gulp, database importer
          # make bootstrap
        fi
        echo -e '\e[38;5;198m'"END BOOTSTRAP $(date '+%Y-%m-%d %H:%M:%S')"
      SHELL

      # install docker
      # vagrant up --provision-with docker to only run this on vagrant up
      config.vm.provision "docker", preserve_order: true, type: "shell", path: "docker/docker.sh"

      # install terraform
      # vagrant up --provision-with terraform to only run this on vagrant up
      config.vm.provision "terraform", preserve_order: true, type: "shell", privileged: true, path: "hashicorp/terraform.sh"

      # install terraform-enterprise
      # vagrant up --provision-with terraform-enterprise to only run this on vagrant up
      config.vm.provision "terraform-enterprise", run: "never", preserve_order: true, type: "shell", privileged: true, path: "hashicorp/terraform-enterprise.sh"

      # install vault
      # vagrant up --provision-with vault to only run this on vagrant up
      config.vm.provision "vault", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/vault.sh"

      # install consul
      # vagrant up --provision-with consul to only run this on vagrant up
      config.vm.provision "consul", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/consul.sh"

      # install nomad
      # vagrant up --provision-with nomad to only run this on vagrant up
      config.vm.provision "nomad", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/nomad.sh"

      # install packer
      # vagrant up --provision-with packer to only run this on vagrant up
      config.vm.provision "packer", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/packer.sh"

      # install sentinel
      # vagrant up --provision-with sentinel to only run this on vagrant up
      config.vm.provision "sentinel", type: "shell", preserve_order: true, privileged: true, path: "hashicorp/sentinel.sh"

      # install localstack
      # vagrant up --provision-with localstack to only run this on vagrant up
      config.vm.provision "localstack", type: "shell", preserve_order: true, privileged: false, path: "localstack/localstack.sh"

      # vagrant up --provision-with ldap to only run this on vagrant up
      # run ldap docker container for testing with vault (for example) ldap login
      config.vm.provision "ldap", run: "never", type: "shell", preserve_order: true, privileged: true, path: "ldap/ldap.sh"

      # vagrant up --provision-with mysql to only run this on vagrant up
      # run mysql docker container for testing with vault
      config.vm.provision "mysql", run: "never", type: "shell", preserve_order: true, privileged: false, path: "database/mysql.sh"

      # vagrant up --provision-with mssql to only run this on vagrant up
      # run mssql docker container for testing with vault
      config.vm.provision "mssql", run: "never", type: "shell", preserve_order: true, privileged: false, path: "database/mssql.sh"

      # vagrant up --provision-with postgresql to only run this on vagrant up
      # run postgresql docker container for testing with vault
      config.vm.provision "postgresql", run: "never", type: "shell", preserve_order: true, privileged: false, path: "database/postgresql.sh"

      # install jenkins
      # vagrant up --provision-with jenkins to only run this on vagrant up
      config.vm.provision "jenkins", run: "never", type: "shell", preserve_order: true, privileged: false, path: "jenkins/jenkins.sh"

      # docsify
      # vagrant up --provision-with docsify to only run this on vagrant up
      config.vm.provision "docsify", type: "shell", preserve_order: true, privileged: false, path: "docsify/docsify.sh"

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
