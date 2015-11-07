# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "gsfjohnson/centos71"

  config.vm.define "os-aio" do |v|
    v.vm.network "forwarded_port", guest: 80, host: 8080
    v.vm.network "forwarded_port", guest: 443, host: 8443
    v.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    v.vm.hostname = "os"
    v.vm.provision "shell", inline: <<-SHELL
      echo
      echo Use \\\'vagrant ssh\\\' to enter client environment and run:
      echo ansible-playbook -i inventory openstack.yml
    SHELL
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo Disable selinux... [setenforce 0]
    setenforce 0
    cp /vagrant/{*.yml,inventory} .
    cp -a /vagrant/group_vars .
    chmod a-x {*.yml,inventory}
    chown -R vagrant:vagrant {*.yml,inventory,group_vars}
    echo Install git and ansible w/ yum... [yum -q -y install ansible git yum-utils]
    yum -q -y install ansible git yum-utils
    echo Downloading ansible roles... [/vagrant/setup_roles.sh]
    /vagrant/setup_roles.sh
    if [ -e /vagrant/gitconfig ]; then
      cp -v /vagrant/gitconfig /home/vagrant/.gitconfig
      chown -v vagrant:vagrant /home/vagrant/.gitconfig
    fi
    if [ -e /vagrant/id_rsa ]; then
      cp -v /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
      chmod -v 0600 /home/vagrant/.ssh/id_rsa
      chown -v vagrant:vagrant /home/vagrant/.ssh/id_rsa
    fi
  SHELL

end
