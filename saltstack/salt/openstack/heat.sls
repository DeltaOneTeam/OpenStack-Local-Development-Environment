create_heat_db:
  mysql_database.present:
    - name: heat 
    - connection_user: root
    - connection_pass: openstack

create_heat_db_user_localhost:
  mysql_user.present:
    - name: heat
    - host: localhost
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: heat.*
    - user: heat
    - host: localhost
    - connection_user: root
    - connection_pass: openstack

create_heat_db_user_controller:
  mysql_user.present:
    - name: heat
    - host: controller
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: heat.*
    - user: heat
    - host: controller
    - connection_user: root
    - connection_pass: openstack

create_heat_db_user:
  mysql_user.present:
    - name: heat
    - host: '%'
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: heat.*
    - user: heat
    - host: '%'
    - connection_user: root
    - connection_pass: openstack

create_heat_user:
  keystone.user_present:
    - name: heat
    - password: openstack
    - email: None
    - roles:
        service:
          - admin

create_heat_service_endpoint:
  keystone.service_present:
    - name: heat
    - service_type: orchestration
    - description: Orchestration

create_heat_cfn_service_endpoint:
  keystone.service_present:
    - name: heat-cfn
    - service_type: cloudformation
    - description: Orchestration

create_heat_api_endpoint:
  keystone.endpoint_present:
    - name: heat
    - publicurl: http://controller:8004/v1/%(tenant_id)s
    - internalurl: http://controller:8004/v1/%(tenant_id)s
    - adminurl: http://controller:8004/v1/%(tenant_id)s
    - region: RegionOne

create_heat_cfn_api_endpoint:
  keystone.endpoint_present:
    - name: heat-cfn
    - publicurl: http://controller:8000/v1
    - internalurl: http://controller:8000/v1
    - adminurl: http://controller:8000/v1
    - region: RegionOne

install_heat:
  pkg.installed:
    - pkgs:
      - openstack-heat-api
      - openstack-heat-api-cfn
      - openstack-heat-engine
      - python-heatclient

install_heat_conf:
  file.copy:
    - name: /etc/heat/heat.conf
    - source: /usr/share/heat/heat-dist.conf
    - user: heat
    - group: heat
    - mode: 644
    - require:
      - pkg: install_heat

heat_conf_connection:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: database
    - parameter: connection
    - value: mysql://heat:openstack@controller/heat

heat_conf_rpc_backend:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: DEFAULT
    - parameter: rpc_backend
    - value: rabbit

heat_conf_oslo_messaging_rabbit:
  ini.sections_present:
    - name: /etc/heat/heat.conf
    - sections:
        oslo_messaging_rabbit:
          rabbit_host: controller
          rabbit_userid: openstack
          rabbit_password: openstack

heat_conf_auth_uri:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: keystone_authtoken
    - parameter: auth_uri
    - value: http://controller:5000/v2.0

heat_conf_identity_uri:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: keystone_authtoken
    - parameter: identity_uri
    - value:  http://controller:35357

heat_conf_admin_tenant_name:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: keystone_authtoken
    - parameter: admin_tenant_name
    - value: service

heat_conf_admin_user:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: keystone_authtoken
    - parameter: admin_user
    - value: heat

heat_conf_admin_password:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: keystone_authtoken
    - parameter: admin_password
    - value: openstack

heat_conf_ec2authtoken:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: ec2authtoken
    - parameter: auth_uri
    - value: http://controller:5000/v2.0

heat_conf_heat_metadata_server_url:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: DEFAULT
    - parameter: heat_metadata_server_url
    - value: http://controller:8000

heat_conf_heat_waitcondition_server_url:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: DEFAULT
    - parameter: heat_waitcondition_server_url
    - value: http://controller:8000/v1/waitcondition

heat_conf_stack_domain_admin:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: DEFAULT
    - parameter: stack_domain_admin
    - value: heat_domain_admin

heat_conf_stack_domain_admin_password:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: DEFAULT
    - parameter: stack_domain_admin_password
    - value: openstack

heat_conf_stack_user_domain_name:
  openstack_config.present:
    - filename: /etc/heat/heat.conf
    - section: DEFAULT
    - parameter: stack_user_domain_name
    - value: heat_user_domain

heat_db_sync:
  cmd.run:
    - name: heat-manage db_sync
    - user: heat
    - shell: /bin/sh
    - onchanges:
      - mysql_database: create_heat_db

enable_openstack_heat_api:
  service.running:
    - name: openstack-heat-api
    - enable: True
    - require:
      - pkg: install_heat

enable_openstack_heat_api_cfn:
  service.running:
    - name: openstack-heat-api-cfn
    - enable: True
    - require:
      - pkg: install_heat

enable_openstack_heat_engine:
  service.running:
    - name: openstack-heat-engine
    - enable: True
    - require:
      - pkg: install_heat