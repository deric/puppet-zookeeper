require 'spec_helper'

describe 'zookeeper' do
  context 'on debian with java installation' do
    let(:facts) do
      {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
      :operatingsystemmajrelease => '14.04',
      :puppetversion => Puppet.version,
    }
    end

    let :pre_condition do
      'class {"zookeeper":
         install_java => true,
         java_package => "openjdk-7-jre-headless",
       }'
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

  context 'on debian fail when no packge provided' do
    let(:facts) do
      {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
      :operatingsystemmajrelease => '14.04',
    }
    end

    let :pre_condition do
      'class {"zookeeper":
         install_java => true,
       }'
    end

    it do
      expect do
        should compile
    end.to raise_error(/Java installation is required/) end
  end
end
