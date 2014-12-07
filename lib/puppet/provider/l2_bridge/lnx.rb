require File.join(File.dirname(__FILE__), '..','..','..','puppet/provider/lnx_base')

Puppet::Type.type(:l2_bridge).provide(:lnx, :parent => Puppet::Provider::Lnx_base) do
  confine :osfamily => :Linux
  commands :brctl => "/usr/sbin/brctl"

  def exists?
    result = brctl("show", @resource[:bridge], '1>/dev/null')
    rv = true
    if result =~ /No\s+such\s+device/
      rv = false
    end
    return rv
  end

  def create
    brctl('addbr', @resource[:bridge])
    notice("bridge '#{@resource[:bridge]}' created.")
  end

  def destroy
    brctl("delbr", @resource[:bridge])
  end

end
