# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end

  config.vm.define "librenms.local" do |libre|
    libre.vm.box = "sl6-base"
    libre.vm.box_url = "https://jgsyd.s3.amazonaws.com/vagrant/sl6-base.box"
    libre.vm.hostname = "librenms.local"
    libre.vm.synced_folder "librenms", "/opt/librenms",
      owner: "root", group: "root"
    libre.vm.network :private_network, ip: "192.168.56.111"
    libre.ssh.forward_agent = true
    libre.vm.provider :virtualbox do |vb|
      vb.gui = false
      vb.memory = 2048
      vb.cpus = 1
    end
    libre.vm.provision :shell, :path => "install-librenms.sh"
  end

end
