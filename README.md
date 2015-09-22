# OpenStack-Local-Development-Environment

This project is used to setup a local development environment for OpenStack, it builds out the following VirtualBox VM's:

1. Controller
2. Network
3. Compute
4. Cinder
5. Swift

The environment installs and configures the following OpenStack components.

1. Keystone
2. Glance
3. Nova
4. Neutron
5. Horizon
6. Heat
7. Cinder
8. Swift

## Pre-Requisites ##
1. Packer (Version 0.8.1 or higher): https://www.packer.io
2. VirtualBox (Version 4.3.30 or higher): https://www.virtualbox.org/wiki/Downloads
2. Vagrant (Version 1.7.4 or higher): https://www.vagrantup.com/
4. Centos 7.1 ISO: http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1503-01.iso

## System Requirements ##
To run this environment you will need a pretty powerful machine that has at lest 16GB RAM with a Quad Core or Dual core processor.

## Create Vagrant Box ##
```instr2
1. Download and intsall Packer
2. Download Centos 7.1 ISO
3. Execute the following commands:
    $ cd packer
    $ packer build centos-7-x86_64.json
    $ vagrant box add deltaone-team/centos-7.1 centos-7-x86_64.box
```

## Working with enviornment ##
```instr2
1. To build the enviornment execute the following command:
    $ vagrant up
    
2. To shutdown the environment:
    $ vagrant halt
    
3. To delete the environment:
    $ vagrant destroy
```
## Create Network and Boot instance ##
```instr3
1. ssh to the controller node
    $ vagrant ssh controller
    
2. Execute the following command on the controller node (Only execute this once).
    $ /vagrant/net-setup-test.sh

3. Execute the following commands to check the status of the instance creation.
    $ . ./demo-openrc.sh
    $ nova list
```
## HEAT Setup / Verification ##
```instr4
1. ssh to the controller node:
    $ vagrant ssh controller.

2. Execute the following commands.
    $ sudo -i
    # cd /vagrant
    # ./create_heat_domain.sh
    # exit

3. Execute the following commands to check the status of the stack creation.
    $ . ./admin-openrc.sh
    $ heat stack-list
```
