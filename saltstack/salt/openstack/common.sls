vagrant sshcreate_etc_hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://hosts

install_openstack_utils:
  pkg.installed:
    - name: openstack-utils

enable_network:
  service.running:
    - name: network
    - enable: True

disable_network:
  service.dead:
    - name: NetworkManager
    - enable: False

remove_network_manager:
  pkg.removed:
    - name: NetworkManager