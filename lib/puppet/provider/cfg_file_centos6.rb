require File.join(File.dirname(__FILE__), '..','..','puppet/provider')

class Puppet::Provider::Cfg_file_centos6 < Puppet::Provider::Cfg_file_base

  def separator_char
    '='
  end

  def file
    "/etc/sysconfig/network-scripts/#{resource[:file]}"
  end

end