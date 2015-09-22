# On Controller
wget -P /tmp/images -e use_proxy=yes -e http_proxy=http://159.156.159.225:9090 http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
#wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

. ./admin-openrc.sh 
glance image-create --name "cirros-0.3.4-x86_64" --file /tmp/images/cirros-0.3.4-x86_64-disk.img   --disk-format qcow2 --container-format bare --visibility public --progress
glance image-list
rm -r /tmp/images

#External Network:
neutron net-create ext-net --router:external --provider:physical_network external --provider:network_type flat

neutron subnet-create ext-net 192.168.100.0/24  --name ext-subnet \
  --allocation-pool start=192.168.100.30,end=192.168.100.50 \
  --disable-dhcp --gateway 192.168.100.1

#Tenannt Network:
. ./demo-openrc.sh
neutron net-create demo-net

neutron subnet-create demo-net 10.200.0.0/24 --name demo-subnet --gateway 10.200.0.1

neutron router-create demo-router

neutron router-interface-add demo-router demo-subnet

neutron router-gateway-set demo-router ext-net

nova secgroup-add-rule default tcp 22 22 0.0.0.0/0

nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0

nova keypair-add demo-key
nova keypair-list

nova boot --flavor m1.tiny --image cirros-0.3.4-x86_64 --nic net-id=$(neutron net-list | awk '/demo-net/ {print $2}') --security-group default --key-name demo-key demo-instance1