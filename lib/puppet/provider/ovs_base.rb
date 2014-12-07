# require 'csv'
# require 'puppet/util/inifile'

class Puppet::Provider::Ovs_base < Puppet::Provider

  def vendor_specific
    notice("Resource '#{@resource[:name]}': Vendor_specific field don't implemented for default providers.")
    return {}
  end
  def vendor_specific=(value)
    notice("Resource '#{@resource[:name]}': Vendor_specific field don't implemented for default providers.")
  end

end