---
install_horizon:
  pkg.installed:
    - pkgs:
      - openstack-dashboard
      - httpd
      - mod_wsgi
      - memcached
      - python-memcached

horizon_local_settings:
  file.managed:
    - name: /etc/openstack-dashboard/local_settings
    - source: salt://local_settings
    - user: root
    - group: apache
    - mode: 640
    - makedirs: True
    - require:
      - pkg: install_horizon

chown_openstack_dashboard_static:
  file.directory:
    - name: /usr/share/openstack-dashboard/static
    - user: apache
    - group: apache
    - recurse:
      - user
      - group
    - require:
      - pkg: install_horizon

enable_horizon_apache:
  service.running:
    - name: httpd
    - enable: True
    - require:
      - pkg: install_horizon
    - watch:
      - file: horizon_local_settings
      - file: chown_openstack_dashboard_static

enable_horizon_memcached:
  service.running:
    - name: memcached
    - enable: True
    - require:
      - pkg: install_horizon