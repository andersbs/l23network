class l23network::examples::bridges {
    l23network::l2::bridge {'br1':
        provider        => 'ovs',
        external_ids    => ''
        stp             => true,
        stp_properties  => {
            system_id     => '',
            priority      => '',
            hello_time    => '',
            max_age       => '',
            forward_delay => '',
        },
        bpdu_forward    => true,
    }
    l23network::l2::bridge {'br2':
        provider        => 'lnx',
        external_ids    => undef,   # can't set for this provider type
        stp             => true,
        stp_properties  => {
            system_id     => '',
            priority      => '',
            hello_time    => '',
            max_age       => '',
            forward_delay => '',
        },
        bpdu_forward    => undef,   # can't set for this provider type
    }
}
###