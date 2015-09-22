# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
    'controller'  => [1, 200],
    'network'  => [1, 201],
    'compute'  => [1, 202],
    #'swift'   => [1, 210],
    #'swift2'  => [1, 212],
    #'cinder'   => [1, 211],
}
  
Vagrant.configure("2") do |config|
    
  # Virtualbox
  config.vm.box = "deltaone-team/centos-7.1"
  config.vm.synced_folder "saltstack/", "/srv/saltstack"
  config.vm.synced_folder "saltstack/salt/", "/srv/salt"
  config.vm.synced_folder ".", "/vagrant"

  #Default is 2200..something, but port 2200 is used by forescout NAC agent.
  config.vm.usable_port_range= 2800..2900

  ##############################
  # OpenStack Nodes
  ##############################
  nodes.each do |prefix, (count, ip_start)|
    count.times do |i|
      if prefix == "compute"
        hostname = "%s%d" % [prefix, (i+1)]
      else
        hostname = "%s" % [prefix, (i+1)]
      end

      config.vm.define "#{hostname}" do |box|
        box.vm.hostname = "#{hostname}"
        box.vm.network :private_network, ip: "172.16.0.#{ip_start+i}", :netmask => "255.255.255.0"
        box.vm.network :private_network, ip: "10.10.0.#{ip_start+i}", :netmask => "255.255.255.0" 
      	box.vm.network :private_network, ip: "192.168.100.#{ip_start+i}", :netmask => "255.255.255.0" 

        box.vm.provision "shell", inline: "mkdir -p  /etc/salt/minion.d; chown vagrant /etc/salt/minion.d"
        box.vm.provision "shell", inline: "cp /srv/saltstack/etc/openstack.conf /etc/salt/minion.d/openstack.conf"

        box.vm.provision :salt do |salt|
          salt.minion_id = "#{hostname}"
          salt.masterless = true
          salt.run_highstate = true
          salt.install_type = "stable"
        end
        

        box.vm.provider :virtualbox do |vbox|

          # Defaults
          vbox.customize ["modifyvm", :id, "--memory", 1024]
          vbox.customize ["modifyvm", :id, "--cpus", 1]
          if prefix == "compute" or prefix
            vbox.customize ["modifyvm", :id, "--memory", 3172]
            vbox.customize ["modifyvm", :id, "--cpus", 2]
          elsif prefix == "controller"
            vbox.customize ["modifyvm", :id, "--memory", 2048]
          end
          vbox.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
          vbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
          vbox.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
          vbox.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
        end
      end
    end
  end

end
