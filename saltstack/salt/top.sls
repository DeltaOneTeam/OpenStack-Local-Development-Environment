---
base:
  '*':
    - openstack.common
  'controller':
    - openstack.controller
    - openstack.keystone
    - openstack.glance
    - openstack.nova-control
    - openstack.neutron-control
    - openstack.horizon
    - openstack.heat
  'compute*':
    - openstack.nova
  'network':
    - openstack.neutron