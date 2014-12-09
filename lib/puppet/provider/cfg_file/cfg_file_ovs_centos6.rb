require File.join(File.dirname(__FILE__), '..','..','..','puppet/provider/cfg_file_ubuntu')

Puppet::Type.type(:cfg_file).provide(:ovs_centos6) do

  def exists?
    true
  end

  def create
    true
  end

  def destroy
    true
  end

  def config
    {}
  end

  def config=(value)
    true
  end

end
