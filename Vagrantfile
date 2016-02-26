# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

nodes = YAML.load_file("onvm/conf/nodes.conf.yml")
ids = YAML.load_file("onvm/conf/ids.conf.yml")

Vagrant.configure("2") do |config|
  config.vm.box = "tknerr/managed-server-dummy"
  config.ssh.username = ids['username']
  config.ssh.password = ids['password']

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "onvm", "/onvm", disabled: false, create: true

  # do setup ceilometer
  config.vm.define "ceilometer" do |node|
      node.vm.provider :managed do |managed|
        managed.server = nodes['ceilometer']['eth1']
      end

      node.vm.provision "install-ceilometer", type: "shell" do |s|
        s.path = "onvm/scripts/install/install-ceilometer.sh"
        s.args = ids['osrelease']
        s.privileged = true
      end

      node.vm.provision "config-ceilometer", type: "shell" do |s|
        s.path = "onvm/scripts/install/config-" + ids['osrelease'] + "-ceilometer.sh"
        s.args = ids['osrelease']
        s.privileged = true
      end

  end

end
