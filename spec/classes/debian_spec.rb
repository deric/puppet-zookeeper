require 'spec_helper'

describe 'zookeeper::os::debian', :type => :class do
  context 'with java installation' do
    let(:facts) do
      {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
      :puppetversion => Puppet.version,
    }
    end

    let(:params) do
      {
      :install_java => true,
      :java_package => 'openjdk-7-jre-headless',
    }
    end

    it do
      should contain_package('openjdk-7-jre-headless').with({
      'ensure' => 'present',
      })
    end
    it do
      should contain_package('zookeeper').with({
      'ensure' => 'present',
      })
    end
  end

  context 'fail when no packge provided' do
    let(:facts) do
      {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
    }
    end

    let(:params) do
      {
      :install_java => true,
    }
    end

    it do
      expect do
        should compile
    end.to raise_error(/Java installation is required/) end
  end
end
