# require 'csv'
# require 'puppet/util/inifile'

class Puppet::Provider::Lnx_base < Puppet::Provider

  def external_ids
    notice("Resource '#{@resource[:name]}': External_ids feature don't implemented for this provider.")
    return {}
  end
  def external_ids=(value)
    notice("Resource '#{@resource[:name]}': External_ids feature don't implemented for this provider.")
  end

  def vendor_specific
    notice("Resource '#{@resource[:name]}': Vendor_specific field don't implemented for default providers.")
    return {}
  end
  def vendor_specific=(value)
    notice("Resource '#{@resource[:name]}': Vendor_specific field don't implemented for default providers.")
  end

end