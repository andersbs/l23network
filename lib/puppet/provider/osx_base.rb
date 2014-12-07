# require 'csv'
# require 'puppet/util/inifile'

class Puppet::Provider::Osx_base < Puppet::Provider

  def external_ids
    return {}
  end
  def external_ids=(value)
    fail("Resource '#{@resource[:name]}': External_ids feature don't implemented for provider '#{@resource[:provider]}'.")
  end

  def vendor_specific
    return {}
  end
  def vendor_specific=(value)
    fail("Resource '#{@resource[:name]}': Vendor_specific field don't implemented for provider '#{@resource[:provider]}'.")
  end

end