#require 'spec_helper'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/parser/functions/lib/l23network_scheme.rb'

describe 'l23network::l2::bridge', :type => :define do
  let(:title) { 'br21' }
  let(:facts) { {
    :osfamily => 'Debian',
    :kernelmajversion => '3.10'
  } }

  context 'provider => ovs' do
    let(:params) { {
      :provider => 'ovs'
    } }
    it do
      # todo(sv): move it to the class l23network test
      # should contain_service('openvswitch-switch').with({
      #   :ensure     => 'running',
      #   :enable     => 'true'
      # })
      should contain_l2_bridge('br21').with(
        'ensure'     => 'present',
        'provider'   => 'ovs',
      )
      #should contain_l2_bridge('bridge21').that_requires('Service[openvswitch-switch]')
    end
  end

  context 'provider => lnx' do
    let(:params) { {
      :provider => 'lnx'
    } }
    it do
      should contain_l2_bridge('br21').with(
        'ensure'     => 'present',
        'provider'   => 'lnx',
      )
    end
  end

end
# vim: set ts=2 sw=2 et :