create_nova_db:
  mysql_database.present:
    - name: nova 
    - connection_user: root
    - connection_pass: openstack

create_nova_db_user_localhost:
  mysql_user.present:
    - name: nova
    - host: localhost
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: nova.*
    - user: nova
    - host: localhost
    - connection_user: root
    - connection_pass: openstack

create_nova_db_user_controller:
  mysql_user.present:
    - name: nova
    - host: controller
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: nova.*
    - user: nova
    - host: controller
    - connection_user: root
    - connection_pass: openstack

create_nova_db_user:
  mysql_user.present:
    - name: nova
    - host: '%'
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: nova.*
    - user: nova
    - host: '%'
    - connection_user: root
    - connection_pass: openstack

create_nova_user:
  keystone.user_present:
    - name: nova
    - password: openstack
    - email: None
    - roles:
        service:
          - admin

create_nova_service_endpoint:
  keystone.service_present:
    - name: nova
    - service_type: compute 
    - description: OpenStack Compute

create_nova_api_endpoint:
  keystone.endpoint_present:
    - name: nova
    - publicurl: 'http://controller:8774/v2/%(tenant_id)s'
    - internalurl: 'http://controller:8774/v2/%(tenant_id)s'
    - adminurl: 'http://controller:8774/v2/%(tenant_id)s'
    - region: RegionOne

install_nova:
  pkg.installed:
    - pkgs:
      - openstack-nova-api
      - openstack-nova-cert
      - openstack-nova-conductor
      - openstack-nova-console
      - openstack-nova-novncproxy
      - openstack-nova-scheduler
      - python-novaclient

nova_conf_connection:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: database
    - parameter: connection
    - value: mysql://nova:openstack@controller/nova

nova_conf_rpc_backend:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: rpc_backend
    - value: rabbit

nova_conf_rabbit_host:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: oslo_messaging_rabbit
    - parameter: rabbit_host
    - value: controller

nova_conf_rabbit_userid:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: oslo_messaging_rabbit
    - parameter: rabbit_userid
    - value: openstack

nova_conf_rabbit_password:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: oslo_messaging_rabbit
    - parameter: rabbit_password
    - value: openstack

nova_conf_auth_strategy:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: auth_strategy
    - value: keystone

nova_conf_auth_uri:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: auth_uri
    - value: http://controller:5000

nova_conf_auth_url:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: auth_url
    - value: http://controller:35357

nova_conf_auth_plugin:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: auth_plugin
    - value: password

nova_conf_project_domain_id:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: project_domain_id
    - value: default

nova_conf_user_domain_id:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: user_domain_id
    - value: default

nova_conf_project_name:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: project_name
    - value: service

nova_conf_username:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: username
    - value: nova

nova_conf_password:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: password
    - value: openstack

nova_conf_my_ip:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: my_ip
    - value: '172.16.0.200'

nova_conf_vncserver_listen:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vncserver_listen
    - value: '172.16.0.200'

nova_conf_vncserver_proxyclient_address:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vncserver_proxyclient_address
    - value: '172.16.0.200'

nova_conf_glance_host:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: glance
    - parameter: host
    - value: controller

nova_conf_lock_path:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: oslo_concurrency
    - parameter: lock_path
    - value: /var/lib/nova/tmp

nova_conf_verbose:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

nova_db_sync:
  cmd.run:
    - name: 'nova-manage db sync'
    - user: nova
    - shell: /bin/sh
    - onchanges:
      - mysql_database: create_nova_db


nova_neutron_conf_network_api_class:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: network_api_class
    - value: nova.network.neutronv2.api.API

nova_neutron_conf_security_group_api:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: security_group_api
    - value: neutron

nova_neutron_conf_linuxnet_interface_driver:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: linuxnet_interface_driver
    - value: nova.network.linux_net.LinuxOVSInterfaceDriver

nova_neutron_conf_firewall_driver:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: firewall_driver
    - value: nova.virt.firewall.NoopFirewallDriver

nova_neutron_conf_url:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: url
    - value: http://controller:9696

nova_neutron_conf_auth_strategy:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: auth_strategy
    - value: keystone

nova_neutron_conf_admin_auth_url:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: admin_auth_url
    - value: http://controller:35357/v2.0

nova_neutron_conf_admin_tenant_name:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: admin_tenant_name
    - value: service

nova_neutron_conf_admin_username:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: admin_username
    - value: neutron

nova_neutron_conf_admin_password:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: admin_password
    - value: openstack

nova_neutron_conf_service_metadata_proxy:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: service_metadata_proxy
    - value: 'True'

nova_neutron_conf_metadata_proxy_shared_secret:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: metadata_proxy_shared_secret
    - value: openstack

enable_nova_api:
  service.running:
    - name: openstack-nova-api
    - enable: True
    - require:
      - pkg: install_nova

enable_nova_cert:
  service.running:
    - name: openstack-nova-cert
    - enable: True
    - require:
      - pkg: install_nova

enable_nova_consoleauth:
  service.running:
    - name: openstack-nova-consoleauth
    - enable: True
    - require:
      - pkg: install_nova

enable_nova_scheduler:
  service.running:
    - name: openstack-nova-scheduler
    - enable: True
    - require:
      - pkg: install_nova

enable_nova_conductor:
  service.running:
    - name: openstack-nova-conductor
    - enable: True
    - require:
      - pkg: install_nova

enable_nova_novncproxy:
  service.running:
    - name: openstack-nova-novncproxy
    - enable: True
    - require:
      - pkg: install_nova
