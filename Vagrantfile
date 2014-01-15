node_name = "otore.example.com"

Vagrant.configure("2") do |config|
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define :otore do |node|
    node.vm.box = "precise64"
    node.vm.provider :virtualbox do |v|
      v.name = node_name
      v.customize ["modifyvm", :id, "--memory", "4096"]
    end
    node.vm.network :private_network, ip: "10.211.55.100"
    node.vm.hostname = node_name
    node.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      puppet.options = "--verbose --debug"
      puppet.facter = {
        "vagrant" => "1",
      }
    end
  end
end
