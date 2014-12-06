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
      defaultto {}
      validate do |val|
        if val and val.class.to_s != 'Hash'
          fail("Vendor specific fields should be a hash if given.")
        end
      end
    end

    newproperty(:external_ids) do
      desc "External IDs for the bridge"
      defaultto ''
      validate do |val|
        if @resource.provider.class.name != :ovs
          warn("!!! External_ids implemented only for OVS bridges.")
        end
        if val and val.class.to_s != 'Hash'
          fail("external_ids should be a hash if given.")
        end
        val.each { |pair|
          err = false
          if not pair[0] =~ /^[a-z][0-9a-z\.\-\_]*[0-9a-z]$/
            err = "Non-string simbol in external_ids key name: '#{pair}'"
          end
          if not pair[1] =~ /[0-9a-z\.\-\_]*/
            err = "Non-string simbol in external_ids value for key '#{pair[0]}': '#{pair}'"
          end
          if err
            fail(err)
          end
        }
      end
    end

    # global validator
    def validate
        # require 'pry'
        # binding.pry
        if provider.class.name != :ovs and self[:name].length > MAX_BR_NAME_LENGTH
          # validate name for differetn providers may only in global validator, because
          # 'provider' option don't accessible while validating name
          fail("Wrong bridge name '#{self[:name]}'.\n For provider '#{provider.class.name}' bridge name shouldn't has length more, than #{MAX_BR_NAME_LENGTH}.")
        end
    end

end
