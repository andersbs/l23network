Puppet::Type.newtype(:l2_bridge) do
    @doc = "Manage a Open vSwitch bridge (virtual switch)"
    desc @doc

    ensurable

    MAX_BR_NAME_LENGTH = 15

    newparam(:bridge) do
      isnamevar
      desc "The bridge to configure"
      #
      validate do |val|
        if not val =~ /^[a-z][0-9a-z\.\-\_]*[0-9a-z]$/
          fail("Wrong bridge name: '#{val}'")
        end
      end
    end

    newproperty(:vendor_specific) do
      desc "Vendor specific fields."
      #
      validate do |val|
        if val and val.class.to_s != 'Hash'
          fail("Vendor specific fields should be a hash if given.")
        end
      end
    end

    newproperty(:external_ids) do
      desc "External IDs for the bridge"
    end

    # global validator
    def validate
        # require 'pry'
        # binding.pry
        if provider.class.name != :ovs and self[:name].length > MAX_BR_NAME_LENGTH
          fail("Wrong bridge name '#{self[:name]}'.\n For provider '#{provider.class.name}' bridge name shouldn't has length more, than #{MAX_BR_NAME_LENGTH}.")
        end
    end

end
