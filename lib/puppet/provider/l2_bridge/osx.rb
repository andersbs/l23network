Puppet::Type.type(:l2_bridge).provide(:osx) do
  defaultfor :osfamily => :Darwin
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

  def external_ids
    return true
  end

  def external_ids=(value)
    return 'none'
  end
end
