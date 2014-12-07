require File.join(File.dirname(__FILE__), '..','..','..','puppet/provider/ovs_base')

Puppet::Type.type(:l2_bridge).provide(:ovs, :parent => Puppet::Provider::Ovs_base) do
  confine :osfamily => :Linux
  commands :vsctl => "/usr/bin/ovs-vsctl"

  def exists?
    vsctl("br-exists", @resource[:bridge])
  rescue Puppet::ExecutionFailure
    return false
  end

  def create
    vsctl('add-br', @resource[:bridge])
    notice("bridge '#{@resource[:bridge]}' created.")
    # We do self.attr_setter=(value) instead of attr=value because this doesn't
    # work in Puppet (our guess).
    # TODO (adanin): Fix other places like this one. See bug #1366009
    self.external_ids=(@resource[:external_ids]) if @resource[:external_ids]
  end

  def destroy
    vsctl("del-br", @resource[:bridge])
  end

  def external_ids
    result = vsctl("br-get-external-id", @resource[:bridge])
    rv = {}
    result.split("\n").each{|pair|
      kv = pair.split(/\s*\=\s*/)
      rv[pp[0]] = kv[1]
    }
    return rv
  end

  def external_ids=(value)
    # erase old
    result = vsctl("br-get-external-id", @resource[:bridge])
    result.split("\n").each{|pair|
      kv = pair.split(/\s*\=\s*/)
      vsctl("br-set-external-id", @resource[:bridge], kv[0])  # erase k/v pair
    }
    # add new
    value.each_pair do |k,v|
      vsctl("br-set-external-id", @resource[:bridge], k, v)
    end
  end
end
