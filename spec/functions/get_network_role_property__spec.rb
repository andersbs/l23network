require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/parser/functions/lib/l23network_scheme.rb'

describe 'get_network_role_property' do
  #let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  before(:each) do
    #L23network::Scheme.set = {
    L23network::Scheme.set_config('xxx', {
      :endpoints => {
        :eth0 => {:IP => 'dhcp'},
        :"br-ex" => {
          :gateway => '10.1.3.1',
          :IP => ['10.1.3.11/24'],
        },
        :"br-mgmt" => { :IP => ['10.20.1.11/25'] },
        :"br-storage" => { :IP => ['192.168.1.2/24'] },
        :"br-prv" => { :IP => 'none' },
      },
      :roles => {
        :management => 'br-mgmt',
        :private => 'br-prv',
        :ex => 'br-ex',
        :storage => 'br-storage',
        :admin => 'eth0',
      },
    })
  end

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('get_network_role_property')).to eq('function_get_network_role_property')
  end

  # it 'should return interface name for "private" network role' do
  #       require 'pry'
  #       binding.pry
  #   should run.with_params('private', 'interface').and_return('br-prv')
  # end

  # it 'should raise for non-existing role name' do
  #   should run.with_params('not_exist', 'interface').and_raise_error(Puppet::ParseError)
  # end

  # it 'should return ip address for "management" network role' do
  #   should run.with_params('management', 'ipaddr').and_return('10.20.1.11')
  # end

  # it 'should return cidr-notated ip address for "management" network role' do
  #   should run.with_params('management', 'cidr').and_return('10.20.1.11/25')
  # end

  # it 'should return netmask for "management" network role' do
  #   should run.with_params('management', 'netmask').and_return('255.255.255.128')
  # end

  # it 'should return ip address and netmask for "management" network role' do
  #   should run.with_params('management', 'ipaddr_netmask_pair').and_return(['10.20.1.11','255.255.255.128'])
  # end

  # it 'should return NIL for "admin" network role' do
  #   should run.with_params('admin', 'netmask').and_return(nil)
  # end
  # it 'should return NIL for "admin" network role' do
  #   should run.with_params('admin', 'ipaddr').and_return(nil)
  # end
  # it 'should return NIL for "admin" network role' do
  #   should run.with_params('admin', 'cidr').and_return(nil)
  # end
  # it 'should return NIL for "admin" network role' do
  #   should run.with_params('admin', 'ipaddr_netmask_pair').and_return(nil)
  # end

end