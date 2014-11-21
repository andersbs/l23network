# == Define: l23network::l2::bridge
#
# Create open vSwitch brigde.
#
# === Parameters
#
# [*name*]
#   Bridge name.
#
# [*external_ids*]
#   See open vSwitch documentation.
#   http://openvswitch.org/cgi-bin/ovsman.cgi?page=utilities%2Fovs-vsctl.8
#
define l23network::l2::bridge (
  $ensure          = present,
  $external_ids    = "bridge-id=${name}",
  $vendor_specific = undef,
  $provider        = undef,
) {
  include l23network::params

  #todo: name length control for bridge name
  l2_bridge {$name:
    ensure          => $ensure,
    external_ids    => $external_ids,
    vendor_specific => $vendor_specific,
    provider        => $provider
  }
  if provider =~ /ovs/ {
    enshure_service($::l23network::params::ovs_datapath_package_name)
    Service[$::l23network::params::ovs_datapath_package_name] -> L2_bridge[$name]
  }
}
# vim: set ts=2 sw=2 et :