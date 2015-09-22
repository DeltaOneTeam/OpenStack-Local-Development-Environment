#/bin/bash

. /home/vagrant/admin-openrc.sh

heat-keystone-setup-domain \
  --stack-user-domain-name heat_user_domain \
  --stack-domain-admin heat_domain_admin \
  --stack-domain-admin-password openstack

NET_ID=$(nova net-list | awk '/ demo-net / { print $2 }')
heat stack-create -f test-stack.yml  -P "ImageID=cirros-0.3.4-x86_64;NetID=$NET_ID" testStack
heat stack-list
