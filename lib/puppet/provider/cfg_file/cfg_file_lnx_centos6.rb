require File.join(File.dirname(__FILE__), '..','..','..','puppet/provider/cfg_file_ubuntu')

Puppet::Type.type(:cfg_file).provide(:lnx_ubuntu, :parent => Puppet::Provider::Cfg_file_ubuntu) do
  commands(
    :sed => "/bin/sed"
  )

  def exists?
    get_value(key)
  end

  def create
    set_value(key, resource[:value])
  end

  def destroy
    if exists?
      sed("-ire", "/^\s*#{key}\s*#{separator_char}.*$/D", file)
    end
  end

  def config
    get_value(key)
  end

  def config=(value)
    set_value(key, value)
  end

end
