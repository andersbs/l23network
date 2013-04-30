L23network
==========
Puppet module for configuring network interfaces, 802.1q vlans, bonds on 2 and 3 level. Can work together with open vSwitch or standart linux way.  At this moment support Centos 6.3 (RHEL6) and Ubuntu 12.04 or above.


Usage
-----
Place this module at /etc/puppet/modules or to another path, contains your puppet modules.

Include L23network module and initialize it. I recommend do it in early stage:

    #Network configuration
    stage {'netconfig':
      before  => Stage['main'],
    }
    class {'l23network': stage=> 'netconfig'}

If You don't planned using open vSwitch -- you can disable it:

    class {'l23network': use_ovs=>false, stage=> 'netconfig'}


L2 network configuation
-----------------------

Current layout is:
* *bridges* -- A "Bridge" is a virtual ethernet L2 switch. You can plug ports into it.
* *ports* -- A Port is a interface you plug into the bridge (switch). It's a virtual.
* *interface* -- A physical implementation of port.

Then in your manifest you can either use the things as parameterized classes:

    class {"l23network": }
    
    l23network::l2::bridge{"br-mgmt": }
    l23network::l2::port{"eth0": bridge => "br-mgmt"}
    l23network::l2::port{"mmm0": bridge => "br-mgmt"}
    l23network::l2::port{"mmm1": bridge => "br-mgmt"}
    
    l23network::l2::bridge{"br-ex": }
    l23network::l2::port{"eth0": bridge => "br-ex"}
    l23network::l2::port{"eth1": bridge => "br-ex", ifname_order_prefix='ovs'}
    l23network::l2::port{"eee0": bridge => "br-ex", skip_existing => true}
    l23network::l2::port{"eee1": bridge => "br-ex", type=>'internal'}

You can define type for the port. Port type can be
'system', 'internal', 'tap', 'gre', 'ipsec_gre', 'capwap', 'patch', 'null'.
If you not define type for port (or define '') -- ovs-vsctl will have default behavior 
(see http://openvswitch.org/cgi-bin/ovsman.cgi?page=utilities%2Fovs-vsctl.8).

You can use *skip_existing* option if you not want interrupt configuration during adding existing port or bridge.

L3 network configuation
-----------------------

### Simple IP address definition, DHCP or address-less interfaces

    l23network::l3::ifconfig {"eth0": ipaddr=>'192.168.1.1/24'}
    l23network::l3::ifconfig {"xXxXxXx": 
        interface => 'eth1',
        ipaddr    => '192.168.2.1',
        netmask   => '255.255.255.0'
    }
    l23network::l3::ifconfig {"eth2": ipaddr=>'dhcp'}
    l23network::l3::ifconfig {"eth3": ipaddr=>'none'}

Option *ipaddr* can contains IP address, 'dhcp', or 'none' string. In example above we describe configuration of 4 network interfaces:
* Interface *eth0* have short CIDR-notated form of IP address definition.
* Interface *eth1* 
* Interface *eth2* will be configured to use dhcp protocol. 
* Interface *eth3* will be configured as interface without IP address. 
  Often it's need for create "master" interface for 802.1q vlans (in native linux implementation) 
  or as slave interface for bonding.

CIDR-notated form of IP address have more priority, that classic *ipaddr* and *netmask* definition. 
If you ommited *natmask* and not used CIDR-notated form -- will be used 
default *netmask* value as '255.255.255.0'.

### Multiple IP addresses for one interface (aliases)

    l23network::l3::ifconfig {"eth0": 
      ipaddr => ['192.168.0.1/24', '192.168.1.1/24', '192.168.2.1/24']
    }
    
You can pass list of CIDR-notated IP addresses to the *ipaddr* parameter for assign many IP addresses to one interface.
In this case will be created aliases (not a subinterfaces). Array can contains one or more elements.

### UP and DOWN interface order

    l23network::l3::ifconfig {"eth1": 
      ipaddr=>'192.168.1.1/24'
    }
    l23network::l3::ifconfig {"br-ex": 
      ipaddr=>'192.168.10.1/24',
      ifname_order_prefix='ovs'
    }
    l23network::l3::ifconfig {"aaa0": 
      ipaddr=>'192.168.20.1/24', 
      ifname_order_prefix='zzz'
    }

Centos and Ubuntu at startup OS started and configure network interfaces in alphabetical order 
interface configuration file names. In example above we change configuration process order 
by *ifname_order_prefix* keyword. We will have this order:

    ifcfg-eth1
    ifcfg-ovs-br-ex
    ifcfg-zzz-aaa0

And OS will configure interfaces br-ex and aaa0 after eth0

### Default gateway

    l23network::l3::ifconfig {"eth1":
        ipaddr                => '192.168.2.5/24',
        gateway               => '192.168.2.1',
        check_by_ping         => '8.8.8.8',
        check_by_ping_timeout => '30'
    }

In example above we define default *gateway* and options for waiting that network stay up. 
Parameter *check_by_ping* define IP address, that will be pinged. Puppet will be blocked for waiting
response for *check_by_ping_timeout* time. 
Parameter *check_by_ping* can be IP address, 'gateway', or 'none' string for disabling checking.
By default gateway will be pinged.

### DNS-specific options
### DHCP-specific options


Bonding
-------
### Using standart linux ifenslave bond
For bonding two interfaces you need:
* Specify this interfaces as interfaces without IP addresses
* Specify that interfaces depends from master-bond-interface
* Assign IP address to the master-bond-interface.
* Specify bond-specific properties for master-bond-interface (if defaults not happy for you)

for example (defaults included):   

    l23network::l3::ifconfig {'eth1': ipaddr=>'none', bond_master=>'bond0'} ->
    l23network::l3::ifconfig {'eth2': ipaddr=>'none', bond_master=>'bond0'} ->
    l23network::l3::ifconfig {'bond0':
        ipaddr          => '192.168.232.1',
        netmask         => '255.255.255.0',
        bond_mode       => 0,
        bond_miimon     => 100,
        bond_lacp_rate  => 1,
    }


more information about bonding network interfaces you can get in manuals for you operation system:
* https://help.ubuntu.com/community/UbuntuBonding
* http://wiki.centos.org/TipsAndTricks/BondingInterfaces

### Using open vSwitch
In open vSwitch for bonding two network interfaces you need add special resource "bond" to bridge. 
In this example we add "eth1" and "eth2" interfaces to bridge "bridge0":

    l23network::l2::bridge{'bridge0': } ->
    l23network::l2::bond{'bond1':
        bridge     => 'bridge0',
        ports      => ['eth1', 'eth2'],
        properties => [
           'lacp=active',
           'other_config:lacp-time=fast'
        ],
    }

Open vSwitch provides lot of parameter for different configurations. 
We can specify them in "properties" option as list of parameter=value 
(or parameter:key=value) strings.
The most of them you can see in [open vSwitch documentation page](http://openvswitch.org/support/).

802.1q vlan access ports
------------------------
### Using standart linux way
We can use tagged vlans over ordinary network interfaces and over bonds. 
L23networks support two variants of naming vlan interfaces:
* *vlanXXX* -- 802.1q tag gives from the vlan interface name, but you need specify 
parent intarface name in the **vlandev** parameter.
* *eth0.101* -- 802.1q tag and parent interface name gives from the vlan interface name

If you need using 802.1q vlans over bonds -- you can use only first variant.

In this example we can see both variants:

    l23network::l3::ifconfig {'vlan6':
        ipaddr  => '192.168.6.1',
        netmask => '255.255.255.0',
        vlandev => 'bond0',
    } 
    l23network::l3::ifconfig {'vlan5': 
        ipaddr  => 'none',
        vlandev => 'bond0',
    } 
    L23network:L3:Ifconfig['bond0'] -> L23network:L3:Ifconfig['vlan6'] -> L23network:L3:Ifconfig['vlan5']

    l23network::l3::ifconfig {'eth0':
        ipaddr  => '192.168.0.5',
        netmask => '255.255.255.0',
        gateway => '192.168.0.1',
    } ->
    l23network::l3::ifconfig {'eth0.101':
        ipaddr  => '192.168.101.1',
        netmask => '255.255.255.0',
    } ->
    l23network::l3::ifconfig {'eth0.102':
        ipaddr  => 'none',    
    } 

### Using open vSwitch
In the open vSwitch all internal traffic are virtually tagged.
For creating 802.1q tagged access port you need specify vlan tag when adding port to bridge. 
In example above we create two ports with tags 10 and 20:

    l23network::l2::bridge{'bridge0': } ->
    l23network::l2::port{'vl10':
      bridge  => 'bridge0',
      type    => 'internal',
      port_properties => ['tag=10'],
    } ->
    l23network::l2::port{'vl20':
      bridge  => 'bridge0',
      type    => 'internal',
      port_properties => ['tag=20'],
    }
    
Information about vlans in open vSwitch you can get in [open vSwitch documentation page](http://openvswitch.org/support/config-cookbooks/vlan-configuration-cookbook/).

**IMPORTANT:** You can't use vlan interface names like vlanXXX if you not want double-tagging you network traffic.

---
When I began write this module, I seen to https://github.com/ekarlso/puppet-vswitch. Elcarso, big thanks...
