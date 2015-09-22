create_neutron_db:
  mysql_database.present:
    - name: neutron 
    - connection_user: root
    - connection_pass: openstack

create_neutron_db_localuser:
  mysql_user.present:
    - name: neutron
    - host: localhost
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: neutron.*
    - user: neutron
    - host: localhost
    - connection_user: root
    - connection_pass: openstack

create_neutron_db_user_controller:
  mysql_user.present:
    - name: neutron
    - host: controller
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: neutron.*
    - user: neutron
    - host: controller
    - connection_user: root
    - connection_pass: openstack

create_neutron_db_user:
  mysql_user.present:
    - name: neutron
    - host: '%'
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: neutron.*
    - user: neutron
    - host: '%'
    - connection_user: root
    - connection_pass: openstack

create_neutron_user:
  keystone.user_present:
    - name: neutron
    - password: openstack
    - email: None
    - roles:
        service:
          - admin

create_neutron_service_endpoint:
  keystone.service_present:
    - name: neutron
    - service_type: network
    - description: OpenStack Networking

create_neutron_api_endpoint:
  keystone.endpoint_present:
    - name: neutron
    - publicurl: 'http://controller:9696'
    - internalurl: 'http://controller:9696'
    - adminurl: 'http://controller:9696'
    - region: RegionOne

install_neutron:
  pkg.installed:
    - pkgs:
      - openstack-neutron
      - openstack-neutron-ml2
      - python-neutronclient
      - which

neutron_conf_connection:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: database
    - parameter: connection
    - value: mysql://neutron:openstack@controller/neutron

neutron_conf_rpc_backend:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: rpc_backend
    - value: rabbit

neutron_conf_rabbit_host:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: oslo_messaging_rabbit
    - parameter: rabbit_host
    - value: controller

neutron_conf_rabbit_userid:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: oslo_messaging_rabbit
    - parameter: rabbit_userid
    - value: openstack

neutron_conf_rabbit_password:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: oslo_messaging_rabbit
    - parameter: rabbit_password
    - value: openstack

neutron_conf_auth_strategy:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: auth_strategy
    - value: keystone

neutron_conf_auth_uri:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: auth_uri
    - value: http://controller:5000

neutron_conf_auth_url:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: auth_url
    - value: http://controller:35357

neutron_conf_auth_plugin:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: auth_plugin
    - value: password

neutron_conf_project_domain_id:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: project_domain_id
    - value: default

neutron_conf_user_domain_id:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: user_domain_id
    - value: default

neutron_conf_project_name:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: project_name
    - value: service

neutron_conf_username:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: username
    - value: neutron

neutron_conf_password:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: password
    - value: openstack

neutron_conf_core_plugin:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: core_plugin
    - value: ml2

neutron_conf_service_plugins:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: service_plugins
    - value: router

neutron_conf_allow_overlapping_ips:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: allow_overlapping_ips
    - value: 'True'

neutron_conf_notify_nova_on_port_status_changes:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: notify_nova_on_port_status_changes
    - value: 'True'

neutron_conf_notify_nova_on_port_data_changes:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: notify_nova_on_port_data_changes
    - value: 'True'

neutron_conf_nova_url:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: nova_url
    - value: http://controller:8774/v2

neutron_conf_nova_auth_url:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: nova
    - parameter: auth_url
    - value: http://controller:35357

neutron_conf_nova_auth_plugin:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: nova
    - parameter: auth_plugin
    - value: password

neutron_conf_nova_project_domain_id:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: nova
    - parameter: project_domain_id
    - value: default

neutron_conf_nova_user_domain_id:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: nova
    - parameter: user_domain_id
    - value: default

neutron_conf_nova_region_name:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: nova
    - parameter: region_name
    - value: RegionOne

neutron_conf_nova_project_name:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: nova
    - parameter: project_name
    - value: service

neutron_conf_nova_username:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: nova
    - parameter: username
    - value: nova

neutron_conf_nova_password:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: nova
    - parameter: password
    - value: openstack

neutron_conf_verbose:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

neutron_conf_type_drivers:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2
    - parameter: type_drivers
    - value: 'flat,vlan,gre,vxlan'

neutron_conf_tenant_network_types:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2
    - parameter: tenant_network_types
    - value: gre

neutron_conf_mechanism_drivers:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2
    - parameter: mechanism_drivers
    - value: openvswitch

neutron_conf_tunnel_id_ranges:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2_type_gre
    - parameter: tunnel_id_ranges
    - value: '1:1000'

neutron_conf_enable_security_group:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: securitygroup
    - parameter: enable_security_group
    - value: 'True'

neutron_conf_enable_ipset:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: securitygroup
    - parameter: enable_ipset
    - value: 'True'

neutron_conf_firewall_driver:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: securitygroup
    - parameter: firewall_driver
    - value: neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

neutron_plugin_symlink:
  file.symlink:
    - name: /etc/neutron/plugin.ini
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini

neutron_db_sync:
  cmd.run:
    - name: 'neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head'
    - user: neutron
    - shell: /bin/sh
    - onchanges:
      - mysql_database: create_neutron_db

enable_neutron_server:
  service.running:
    - name: neutron-server
    - enable: True
    - require:
      - cmd: neutron_db_sync
