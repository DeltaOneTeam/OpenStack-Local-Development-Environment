create_glance_db:
  mysql_database.present:
    - name: glance 
    - connection_user: root
    - connection_pass: openstack

create_glance_db_user_localhost:
  mysql_user.present:
    - name: glance
    - host: localhost
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: localhost
    - connection_user: root
    - connection_pass: openstack

create_glance_db_user_controller:
  mysql_user.present:
    - name: glance
    - host: 172.16.0.200
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: 172.16.0.200
    - connection_user: root
    - connection_pass: openstack

create_glance_db_user:
  mysql_user.present:
    - name: glance
    - host: '%'
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: '%'
    - connection_user: root
    - connection_pass: openstack

create_glance_user:
  keystone.user_present:
    - name: glance
    - password: openstack
    - email: None
    - roles:
        service:
          - admin

create_glance_service_endpoint:
  keystone.service_present:
    - name: glance
    - service_type: image 
    - description: OpenStack Image service

create_glance_api_endpoint:
  keystone.endpoint_present:
    - name: glance
    - publicurl: http://controller:9292
    - internalurl: http://controller:9292
    - adminurl: http://controller:9292
    - region: RegionOne

install_glance:
  pkg.installed:
    - pkgs:
      - openstack-glance
      - python-glance
      - python-glanceclient

glance_conf_connection:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: database
    - parameter: connection
    - value: mysql://glance:openstack@controller/glance

glance_conf_auth_uri:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: auth_uri
    - value: http://controller:5000

glance_conf_auth_url:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: auth_url
    - value: http://controller:35357

glance_conf_auth_plugin:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: auth_plugin
    - value: password

glance_conf_project_domain_id:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: project_domain_id
    - value: default

glance_conf_user_domain_id:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: user_domain_id
    - value: default

glance_conf_project_name:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: project_name
    - value: service

glance_conf_username:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: username
    - value: glance

glance_conf_password:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: password
    - value: openstack

glance_conf_paste_deploy_flavor:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: paste_deploy
    - parameter: flavor
    - value: keystone

glance_conf_default_store:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: glance_store
    - parameter: default_store
    - value: file

glance_conf_filesystem_store_datadir:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: glance_store
    - parameter: filesystem_store_datadir
    - value: /var/lib/glance/images/

glance_conf_notification_driver:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: DEFAULT
    - parameter: notification_driver
    - value: noop

glance_conf_verbose:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

glance_registry_connection:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: database
    - parameter: connection
    - value: mysql://glance:openstack@controller/glance

glance_registry_auth_uri:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: auth_uri
    - value: http://controller:5000

glance_registry_auth_url:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: auth_url
    - value: http://controller:35357

glance_registry_auth_plugin:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: auth_plugin
    - value: password

gglance_registry_project_domain_id:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: project_domain_id
    - value: default

glance_registry_user_domain_id:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: user_domain_id
    - value: default

glance_registry_project_name:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: project_name
    - value: service

glance_registry_username:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: username
    - value: glance

glance_registry_password:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: password
    - value: openstack

glance_registry_paste_deploy_flavor:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: paste_deploy
    - parameter: flavor
    - value: keystone

glance_registry_verbose:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

glance_registry_notification_driver:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: DEFAULT
    - parameter: notification_driver
    - value: noop

glance_db_sync:
  cmd.run:
    - name: glance-manage db_sync
    - user: glance
    - shell: /bin/sh
    - onchanges:
      - mysql_database: create_glance_db

enable_glance_api:
  service.running:
    - name: openstack-glance-api
    - enable: True
    - require:
      - pkg: install_glance

enable_glance_registry:
  service.running:
    - name: openstack-glance-registry
    - enable: True
    - require:
      - pkg: install_glance