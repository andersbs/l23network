require File.join(File.dirname(__FILE__), '..','..','puppet/provider')

class Puppet::Provider::Cfg_file_ubuntu < Puppet::Provider::Cfg_file_base

  def separator_char
    ' '
  end

  def file
    "/etc/network/interfaces.d/#{resource[:file]}"
  end

end