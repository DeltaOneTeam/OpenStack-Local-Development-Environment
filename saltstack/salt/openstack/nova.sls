install_nova:
  pkg.installed:
    - pkgs:
      - openstack-nova-compute
      - sysfsutils

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
    - value: '172.16.0.202'

nova_conf_vnc_enabled:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vnc_enabled
    - value: 'True'

nova_conf_vncserver_listen:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vncserver_listen
    - value: '0.0.0.0'

nova_conf_vncserver_proxyclient_address:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vncserver_proxyclient_address
    - value: '172.16.0.202'

nova_conf_novncproxy_base_url:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: novncproxy_base_url
    - value: http://controller:6080/vnc_auto.html

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

nova_conf_libvirt_virt_type:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: libvirt
    - parameter: virt_type
    - value: qemu

enable_libvirtd:
  service.running:
    - name: libvirtd
    - enable: True
    - require:
      - pkg: install_nova

install_bridge_utils:
  pkg.installed:
    - name: bridge-utils

load_bridge_module:
  kmod.present:
    - name: bridge
    - persist: True
    - require:
      - pkg: install_bridge_utils

net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0

net.bridge.bridge-nf-call-iptables:
  sysctl.present:
    - value: 1
    - require:
      - kmod: load_bridge_module

net.bridge.bridge-nf-call-ip6tables:
  sysctl.present:
    - value: 1
    - require:
      - kmod: load_bridge_module

install_neutron:
  pkg.installed:
    - pkgs:
      - openstack-neutron
      - openstack-neutron-ml2
      - openstack-neutron-openvswitch

eutron_conf_rpc_backend:
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
    - value: 'ml2'

neutron_conf_service_plugins:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: service_plugins
    - value: 'router'

neutron_conf_allow_overlapping_ips:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: allow_overlapping_ips
    - value: 'True'

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

# neutron_conf_ovs_local_ip:
#   openstack_config.present:
#     - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
#     - section: ovs
#     - parameter: local_ip
#     - value: '10.0.0.21'

neutron_conf_ovs_local_ip:
  ini.sections_present:
    - name: /etc/neutron/plugins/ml2/ml2_conf.ini
    - sections:
        ovs:
          local_ip: '10.10.0.202'

# neutron_conf_tunnel_types:
#   openstack_config.present:
#     - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
#     - section: agent
#     - parameter: tunnel_types
#     - value: gre

neutron_conf_tunnel_types:
  ini.sections_present:
    - name: /etc/neutron/plugins/ml2/ml2_conf.ini
    - sections:
        agent:
          tunnel_types: gre

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

enable_openvswitch:
  service.running:
    - name: openvswitch
    - enable: True
    - require:
      - pkg: install_neutron

neutron_plugin_symlink:
  file.symlink:
    - name: /etc/neutron/plugin.ini
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini

neutron_openvswitch_agent_service:
  file.managed:
    - name: /usr/lib/systemd/system/neutron-openvswitch-agent.service
    - source: salt://neutron-openvswitch-agent.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install_neutron

enable_nova_compute:
  service.running:
    - name: openstack-nova-compute
    - enable: True
    - require:
      - pkg: install_nova
    - watch:
      - file: neutron_openvswitch_agent_service

enable_neutron_openvswitch_agent:
  service.running:
    - name: neutron-openvswitch-agent
    - enable: True
    - require:
      - pkg: install_neutron