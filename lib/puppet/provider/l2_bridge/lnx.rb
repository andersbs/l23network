Puppet::Type.type(:l2_bridge).provide(:lnx) do
  confine :osfamily => :Darwin
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

  def external_ids
    notice("Bridge '#{@resource[:bridge]}': External_ids feature don't implemented for this provider.")
    return {}
  end

  def external_ids=(value)
    notice("Bridge '#{@resource[:bridge]}': External_ids feature don't implemented for this provider.")
  end
end
