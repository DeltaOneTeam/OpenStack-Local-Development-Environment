---
install_ntp:
  pkg.installed:
    - name: ntp

install_mariadb:
  pkg.installed:
    - pkgs:
      - mariadb
      - mariadb-server
      - MySQL-python

configure_mariadb:
  file.managed:
    - name: /etc/my.cnf.d/mariadb_openstack.cnf
    - source: salt://mariadb_openstack.cnf
    - user: root
    - group: root
    - mode: 644

enable_mariadb:
  service.running:
    - name: mariadb
    - enable: True
    - require:
      - pkg: install_mariadb
    - watch:
      - file: configure_mariadb

mariadb_root_user:
  mysql_user.present:
    - name: root
    - password: openstack
    - require:
      - service: enable_mariadb


mariadb_anonymous_user:
  mysql_user.absent:
    - name: ''
    - connection_user: root
    - connection_pass: openstack
    - require:
      - service: enable_mariadb

mariadb_drop_testdb:
  mysql_database.absent:
    - name: test
    - connection_user: root
    - connection_pass: openstack
    - require:
      - service: enable_mariadb

mariadb_delete_testdb_privs:
  mysql_query.run:
    - database: mysql
    - query: "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    - connection_user: root
    - connection_pass: openstack
    - onchanges:
      - mysql_database: mariadb_drop_testdb

mariadb_flush_privs:
  mysql_query.run:
    - database: mysql
    - query: "FLUSH PRIVILEGES;"
    - connection_user: root
    - connection_pass: openstack
    - onchanges:
      - mysql_query: mariadb_delete_testdb_privs

install_rabbitmq:
  pkg.installed:
    - name: rabbitmq-server

enable_rabbitmq:
  service.running:
    - name: rabbitmq-server
    - enable: True
    - require:
      - pkg: install_rabbitmq

rabbitmq_user:
  rabbitmq_user.present:
    - name: openstack
    - password: openstack
    - perms:
      - '/':
        - '.*'
        - '.*'
        - '.*'