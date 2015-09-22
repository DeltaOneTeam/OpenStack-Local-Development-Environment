net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0

install_neutron:
  pkg.installed:
    - pkgs:
      - openstack-neutron
      - openstack-neutron-ml2
      - openstack-neutron-openvswitch

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

neutron_conf_flat_networks:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2_type_flat
    - parameter: flat_networks
    - value: external

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
#     - value: '10.0.1.21'

# neutron_conf_bridge_mappings:
#   openstack_config.present:
#     - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
#     - section: ovs
#     - parameter: bridge_mappings
#     - value: 'external:br-ex'

neutron_conf_ovs:
  ini.sections_present:
    - name: /etc/neutron/plugins/ml2/ml2_conf.ini
    - sections:
        ovs:
          local_ip: '10.10.0.201'
          bridge_mappings: external:br-ex

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

neutron_conf_l3_interface_driver:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: DEFAULT
    - parameter: interface_driver
    - value: neutron.agent.linux.interface.OVSInterfaceDriver

neutron_conf_l3_external_network_bridge:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: DEFAULT
    - parameter: external_network_bridge
    - value: ''

neutron_conf_l3_router_delete_namespaces:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: DEFAULT
    - parameter: router_delete_namespaces
    - value: 'True'

neutron_conf_l3_verbose:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

neutron_conf_dhcp_interface_driver:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: interface_driver
    - value: neutron.agent.linux.interface.OVSInterfaceDriver

neutron_conf_dhcp_driver:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: dhcp_driver
    - value: 'neutron.agent.linux.dhcp.Dnsmasq'

neutron_conf_dhcp_delete_namespaces:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: dhcp_delete_namespaces
    - value: 'True'

neutron_conf_dhcp_verbose:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

neutron_conf_metadata_auth_uri:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: auth_uri
    - value: http://controller:5000

neutron_conf_metadata_auth_url:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: auth_url
    - value: http://controller:35357

neutron_conf_metadata_auth_region:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: auth_region
    - value: RegionOne

neutron_conf_metadata_auth_plugin:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: auth_plugin
    - value: password

neutron_conf_metadata_project_domain_id:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: project_domain_id
    - value: default

neutron_conf_metadata_user_domain_id:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: user_domain_id
    - value: default

neutron_conf_metadata_project_name:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: project_name
    - value: service

neutron_conf_metadata_username:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: username
    - value: neutron

neutron_conf_metadata_password:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: password
    - value: openstack

neutron_conf_metadata_nova_metadata_ip:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: nova_metadata_ip
    - value: controller

neutron_conf_metadata_proxy_shared_secret:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: metadata_proxy_shared_secret
    - value: openstack

neutron_conf_metadata_verbose:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

enable_openvswitch:
  service.running:
    - name: openvswitch
    - enable: True
    - require:
      - pkg: install_neutron

ovs_add_br:
  cmd.run:
    - name: 'ovs-vsctl add-br br-ex'
    - runas: 'root'
    - require:
      - service: enable_openvswitch

ovs_add_br_port:
  cmd.run:
    - name: 'ovs-vsctl add-port br-ex enp0s10'
    - runas: 'root'
    - require:
      - cmd: ovs_add_br

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

enable_neutron_openvswitch_agent:
  service.running:
    - name: neutron-openvswitch-agent
    - enable: True
    - require:
      - pkg: install_neutron

enable_neutron_dhcp_agent:
  service.running:
    - name: neutron-dhcp-agent
    - enable: True
    - require:
      - pkg: install_neutron

enable_neutron_l3_agent:
  service.running:
    - name: neutron-l3-agent
    - enable: True
    - require:
      - pkg: install_neutron

enable_neutron_metadata_agent:
  service.running:
    - name: neutron-metadata-agent
    - enable: True
    - require:
      - pkg: install_neutron

enable_neutron_ovs_cleanup:
  service.enabled:
    - name: neutron-ovs-cleanup
    - require:
      - pkg: install_neutron