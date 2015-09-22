create_keystone_db:
  mysql_database.present:
    - name: keystone 
    - connection_user: root
    - connection_pass: openstack

create_keystone_db_user_localhost:
  mysql_user.present:
    - name: keystone
    - host: localhost
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: localhost
    - connection_user: root
    - connection_pass: openstack

create_keystone_db_user_controller:
  mysql_user.present:
    - name: keystone
    - host: controller
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: controller
    - connection_user: root
    - connection_pass: openstack

create_keystone_db_user:
  mysql_user.present:
    - name: keystone
    - host: '%'
    - password: openstack
    - connection_user: root
    - connection_pass: openstack
  mysql_grants.present:
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: '%'
    - connection_user: root
    - connection_pass: openstack

install_keystone:
  pkg.installed:
    - pkgs:
      - openstack-keystone
      - httpd
      - mod_wsgi
      - python-openstackclient
      - memcached
      - python-memcached

enable_memcached:
  service.running:
    - name: memcached
    - enable: True
    - require:
      - pkg: install_keystone

keystone_conf_admin_token:
  openstack_config.present:
    - filename: /etc/keystone/keystone.conf
    - section: DEFAULT
    - parameter: admin_token
    - value: openstack

keystone_conf_connection:
  openstack_config.present:
    - filename: /etc/keystone/keystone.conf
    - section: database
    - parameter: connection
    - value: mysql://keystone:openstack@172.16.0.200/keystone

keystone_conf_memcache:
  openstack_config.present:
    - filename: /etc/keystone/keystone.conf
    - section: memcache
    - parameter: servers
    - value: localhost:11211

keystone_conf_token_provider:
  openstack_config.present:
    - filename: /etc/keystone/keystone.conf
    - section: token
    - parameter: provider
    - value: keystone.token.providers.uuid.Provider

keystone_conf_token_driver:
  openstack_config.present:
    - filename: /etc/keystone/keystone.conf
    - section: token
    - parameter: driver
    - value: keystone.token.persistence.backends.memcache.Token

keystone_conf_revoke_driver:
  openstack_config.present:
    - filename: /etc/keystone/keystone.conf
    - section: revoke
    - parameter: driver
    - value: keystone.contrib.revoke.backends.sql.Revoke

keystone_conf_verbose:
  openstack_config.present:
    - filename: /etc/keystone/keystone.conf
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

keystone_db_sync:
  cmd.run:
    - name: keystone-manage db_sync
    - user: keystone
    - shell: /bin/sh
    - onchanges:
      - mysql_database: create_keystone_db

install_apache:
  pkg.installed:
    - name: httpd

apache_httpd_conf:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://httpd.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install_apache

apache_wsgi_keystone_conf:
  file.managed:
    - name: /etc/httpd/conf.d/wsgi-keystone.conf
    - source: salt://wsgi-keystone.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install_apache

wsgi_main_keystone_conf:
  file.managed:
    - name: /var/www/cgi-bin/keystone/main
    - source: salt://wsgi-comp.txt
    - user: keystone
    - group: keystone
    - mode: 755
    - makedirs: True
    - require:
      - pkg: install_apache

wsgi_admin_keystone_conf:
  file.managed:
    - name: /var/www/cgi-bin/keystone/admin
    - source: salt://wsgi-comp.txt
    - user: keystone
    - group: keystone
    - mode: 755
    - makedirs: True
    - require:
      - pkg: install_apache

enable_apache:
  service.running:
    - name: httpd
    - enable: True
    - require:
      - pkg: install_apache
    - watch:
      - file: apache_wsgi_keystone_conf
      - file: wsgi_main_keystone_conf
      - file: wsgi_admin_keystone_conf

create_keystone_service_endpoint:
  keystone.service_present:
    - name: keystone
    - service_type: identity 
    - description: OpenStack Identity
    - require:
      - service: enable_apache

create_keystone_api_endpoint:
  keystone.endpoint_present:
    - name: keystone
    - publicurl: http://controller:5000/v2.0
    - internalurl: http://controller:5000/v2.0
    - adminurl: http://controller:35357/v2.0
    - region: RegionOne
    - require:
      - service: enable_apache

create_admin_project:
  keystone.tenant_present:
    - name: admin
    - description: Admin Project
    - require:
      - service: enable_apache

create_admin_role:
  keystone.role_present:
    - name: admin
    - require:
      - service: enable_apache

create_admin_user:
  keystone.user_present:
    - name: admin
    - password: openstack
    - email: None
    - roles:
        admin:
          - admin
    - require:
      - keystone: create_admin_project
      - keystone: create_admin_role

create_service_project:
  keystone.tenant_present:
    - name: service
    - description: Service Project
    - require:
      - service: enable_apache

create_demo_project:
  keystone.tenant_present:
    - name: demo
    - description: Demo Project
    - require:
      - service: enable_apache

create_user_role:
  keystone.role_present:
    - name: user
    - require:
      - service: enable_apache

create_heat_stack_owner_role:
  keystone.role_present:
    - name: heat_stack_owner
    - require:
      - service: enable_apache

create_heat_stack_user_role:
  keystone.role_present:
    - name: heat_stack_user
    - require:
      - service: enable_apache

create_demo_user:
  keystone.user_present:
    - name: demo
    - password: openstack
    - email: None
    - roles:
        demo:
          - user
          - heat_stack_owner
    - require:
      - keystone: create_demo_project
      - keystone: create_user_role
      - keystone: create_heat_stack_owner_role

admin_openrc:
  file.managed:
    - name: /home/vagrant/admin-openrc.sh
    - source: salt://admin-openrc.sh
    - user: vagrant
    - group: vagrant
    - mode: 755

demo_openrc:
  file.managed:
    - name: /home/vagrant/demo-openrc.sh
    - source: salt://demo-openrc.sh
    - user: vagrant
    - group: vagrant
    - mode: 755