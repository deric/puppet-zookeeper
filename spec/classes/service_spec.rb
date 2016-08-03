require 'spec_helper'

describe 'zookeeper::service' do
  let(:facts) do
    {
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
  }
  end

  let(:params) do
    {
    :zoo_dir => '/usr/lib/zookeeper',
    :log_dir => '/var/log/zookeeper',
  }
  end

  it { should contain_package('zookeeperd') }
  it do
    should contain_service('zookeeper').with(
      :ensure => 'running',
      :enable => true
    )
  end

  context 'RHEL 7' do
    puppet = Puppet.version
    let(:facts) do
      {
      :operatingsystem => 'RedHat',
      :osfamily => 'RedHat',
      :lsbdistcodename => '7',
      :operatingsystemmajrelease => '7',
      :puppetversion => puppet,
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
    end

    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) do
      {
      :zoo_dir          => '/usr/lib/zookeeper',
      :log_dir          => '/var/log/zookeeper',
      :service_provider => 'systemd',
    }
    end

    it { should contain_package('zookeeper') }

    it do
      should contain_file(
        '/usr/lib/systemd/system/zookeeper.service'
      ).with({
        'ensure' => 'present',
      })
    end

    it do
      should contain_service('zookeeper').with(
        :ensure => 'running',
        :enable => true
      )
    end

    context 'do not manage systemd' do
      let(:params) do
        {
        :manage_service_file => false,
        :zoo_dir => '/usr/lib/zookeeper',
        :log_dir => '/var/log/zookeeper',
      }
      end

      it do
        should_not contain_file(
          '/usr/lib/systemd/system/zookeeper.service'
        ).with({
          'ensure' => 'present',
        })
      end
    end
  end

  context 'Debian 7' do
    puppet = Puppet.version
    let(:facts) do
      {
      :operatingsystem => 'Debian',
      :osfamily => 'Debian',
      :lsbdistcodename => 'wheezy',
      :puppetversion => puppet,
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
    end

    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) do
      {
      :zoo_dir             => '/usr/lib/zookeeper',
      :log_dir             => '/var/log/zookeeper',
      :manage_service_file => true,
      :service_provider    => 'init',
    }
    end

    it do
      should contain_file(
        '/etc/init.d/zookeeper'
      ).with({
        'ensure' => 'present',
      })
    end

    it do
      should contain_service('zookeeper').with(
        :ensure   => 'running',
        :enable   => true,
        :provider => 'init',
      )
    end
  end
end
