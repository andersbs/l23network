class l23network::l3::hosts_file (
  $nodes,
  $hosts_file = "/etc/hosts"
) {

  #Move original hosts file

  $host_resources = nodes_to_hosts($nodes)

  Host {
    ensure => present,
    target => $hosts_file
  }

  create_resources(host, $host_resources)
}
# vim: set ts=2 sw=2 et :