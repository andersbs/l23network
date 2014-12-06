class l23network::examples::l2_bridges {
    l2_bridge {'br01':
        ensure            => present,
        provider          => 'ovs',
        external_ids      => "bridge-id=${name}",
        stp               => true,
        stp_system_id     => '',
        stp_priority      => '',
        stp_hello_time    => '',
        stp_max_age       => '',
        stp_forward_delay => '',
        bpdu_forward      => true,
        vendor_specific   => undef,
    }
    l2_bridge {'br02':
        ensure            => present,
        provider          => 'lnx',
        external_ids      => undef,   # can't set for this provider type
        stp               => true,
        stp_system_id     => '',
        stp_priority      => '',
        stp_hello_time    => '',
        stp_max_age       => '',
        stp_forward_delay => '',
        bpdu_forward      => undef,   # can't set for this provider type
        vendor_specific   => undef,
    }
}
###