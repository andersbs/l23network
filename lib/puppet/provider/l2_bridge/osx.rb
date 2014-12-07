require File.join(File.dirname(__FILE__), '..','..','..','puppet/provider/osx_base')

Puppet::Type.type(:l2_bridge).provide(:osx, :parent => Puppet::Provider::Osx_base) do
  defaultfor :osfamily => :Darwin
  #confine :kernel => :Linux
  commands :ifconfig => "/sbin/ifconfig"

  def exists?
    return true
  end

  def create
    return true
  end

  def destroy
    return true
  end

end
