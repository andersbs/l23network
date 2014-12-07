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
  $external_ids    = undef,
  $stp             = false,
  $stp_properties  = {},
  $bpdu_forward    = true,
  $vendor_specific = undef,
  $provider        = undef,
) {
  include l23network::params

  if $stp {
    $stp_system_id     = ''
    $stp_priority      = ''
    $stp_hello_time    = ''
    $stp_max_age       = ''
    $stp_forward_delay = ''
  } else {
    $stp_system_id     = undef
    $stp_priority      = undef
    $stp_hello_time    = undef
    $stp_max_age       = undef
    $stp_forward_delay = undef
  }

  l2_bridge {$name:
    ensure            => $ensure,
    external_ids      => $external_ids,
    # stp               => $stp,
    # stp_system_id     => $stp_system_id,
    # stp_priority      => $stp_priority,
    # stp_hello_time    => $stp_hello_time,
    # stp_max_age       => $stp_max_age,
    # stp_forward_delay => $stp_forward_delay,
    # bpdu_forward      => $bpdu_forward,
    vendor_specific   => $vendor_specific,
    provider          => $provider
  }
  if provider =~ /ovs/ and $::l23network::params::ovs_service_name {
    enshure_service($::l23network::params::ovs_service_name)
    Service[$::l23network::params::ovs_service_name] -> L2_bridge[$name]
  }
}
# vim: set ts=2 sw=2 et :