# Fact: l23_os
#
# Purpose: Return return os_name for using inside l23 network module
#
Facter.add(:l23_os) do
  setcode do
    osfamily = Facter.value(:osfamily)
    case osfamily
      when /(?i)darwin/
        return 'osx'
      when /(?i)debian/
        return 'ubuntu'
      when /(?i)redhat/
        #todo: divide centos6 and centos7
        return 'cantos6'
    end
  end
end