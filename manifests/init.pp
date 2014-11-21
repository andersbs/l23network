# == Class: l23network
#
# Module for configuring network. Contains L2 and L3 modules.
# Requirements, packages and services.
#
class l23network (
  $use_ovs           = true,
  $use_lnxbr         = true,
  #todo(sv): $network_scheme    = undef,
  #todo(sv): $use_ifenslave     = true,
  #todo(sv): $use_ethtool       = true,
  #todo(sv): $disable_firewalld = false,
  #todo(sv): $disable_network_manager = false,
){
  class {'l23network::l2':
    use_ovs   => $use_ovs,
    use_lnxbr => $use_lnxbr,
  }
}
# vim: set ts=2 sw=2 et :