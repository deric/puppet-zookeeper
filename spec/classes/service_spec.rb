require 'spec_helper'

describe 'zookeeper::service' do
  let(:facts) do
    {
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
    :operatingsystemmajrelease => '7',
    :puppetversion => Puppet.version,
  }
  end

  let :pre_condition do
    'class {"zookeeper":
       zoo_dir => "/usr/lib/zookeeper",
       log_dir => "/var/log/zookeeper",
     }'
  end

  it { is_expected.to contain_package('zookeeperd') }
  it do
    is_expected.to contain_service('zookeeper').with(
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
      :puppetversion => Puppet.version,
    }
    end

    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let :pre_condition do
      'class {"zookeeper":
         manage_service_file => true,
         service_provider    => "systemd",
         systemd_path        => "/usr/lib/systemd/system",
         zoo_dir             => "/usr/lib/zookeeper",
         log_dir             => "/var/log/zookeeper",
       }'
    end

    it { should contain_package('zookeeper') }

    it do
      is_expected.to contain_file(
        '/usr/lib/systemd/system/zookeeper-server.service'
      ).with({
        'ensure' => 'present',
      })
    end

    it do
      is_expected.to contain_file(
        '/usr/lib/systemd/system/zookeeper-server.service'
      ).with_content(/zookeeper\.jar/)
    end

    it do
      is_expected.to contain_service('zookeeper-server').with(
        :ensure => 'running',
        :enable => true
      )
    end

    context 'custom service name' do
      let :pre_condition do
        'class {"zookeeper":
           manage_service_file => true,
           service_provider    => "systemd",
           service_name        => "my-zookeeper",
         }'
      end

      it do
        is_expected.to contain_file(
          '/etc/systemd/system/my-zookeeper.service'
        ).with({
          'ensure' => 'present',
        })
      end

      it do
        is_expected.to contain_service('my-zookeeper').with(
          :ensure => 'running',
          :enable => true
        )
      end
    end

    context 'install from archive' do
      let :pre_condition do
        'class {"zookeeper":
           manage_service_file => true,
           service_provider    => "systemd",
           install_method      => "archive",
           archive_version     => "3.4.9"
         }'
      end

      it do
        is_expected.to contain_file(
          '/etc/systemd/system/zookeeper-server.service'
        ).with_content(/zookeeper-3\.4\.9\.jar/)
      end

    end

    context 'do not manage systemd' do
      let :pre_condition do
        'class {"zookeeper":
           manage_service_file => false,
           zoo_dir             => "/usr/lib/zookeeper",
           log_dir             => "/var/log/zookeeper",
         }'
      end

      it do
        is_expected.not_to contain_file(
          '/usr/lib/systemd/system/zookeeper.service'
        ).with({
          'ensure' => 'present',
        })
      end

      it do
        is_expected.not_to contain_file(
          '/etc/systemd/system/zookeeper.service'
        ).with({
          'ensure' => 'present',
        })
      end
    end

    context 'systemd dependencies' do
      let :pre_condition do
        'class {"zookeeper":
           service_provider    => "systemd",
           manage_service_file => true,
           manage_service      => true,
           systemd_unit_after  => "network-online.target openvpn-client@.service",
           systemd_unit_want   => "network-online.target openvpn-client@.service",
         }'
      end

      it do
        is_expected.to contain_file(
          '/etc/systemd/system/zookeeper-server.service'
        ).with({
          'ensure' => 'present',
        })
      end

      it do
        is_expected.to contain_file(
          '/etc/systemd/system/zookeeper-server.service'
        ).with_content(/Wants=network-online.target openvpn-client@.service/)
      end

      it do
        is_expected.to contain_service('zookeeper-server').with(
          :ensure => 'running',
          :enable => true
        )
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
      :operatingsystemmajrelease => '6',
      :puppetversion => puppet,
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :puppetversion => Puppet.version,
    }
    end

    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let :pre_condition do
      'class {"zookeeper":
         zoo_dir             => "/usr/lib/zookeeper",
         log_dir             => "/var/log/zookeeper",
         manage_service_file => true,
         service_provider    => "init",
       }'
    end

    it do
      is_expected.to contain_file(
        '/etc/init.d/zookeeper'
      ).with({
        'ensure' => 'present',
      })
    end

    it do
      is_expected.to contain_service('zookeeper').with(
        :ensure   => 'running',
        :enable   => true,
        :provider => 'init',
      )
    end
  end

  context 'Debian 9' do
    puppet = Puppet.version
    let(:facts) do
      {
      :operatingsystem => 'Debian',
      :osfamily => 'Debian',
      :lsbdistcodename => 'stretch',
      :operatingsystemmajrelease => '9',
      :puppetversion => puppet,
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :puppetversion => Puppet.version,
    }
    end

    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let :pre_condition do
      'class {"zookeeper":
         service_provider    => "systemd",
         manage_service_file => true,
         manage_service      => true,
         systemd_unit_after  => "network-online.target openvpn-client@.service",
         systemd_unit_want   => "network-online.target openvpn-client@.service",
       }'
    end

    it do
      is_expected.to contain_file(
        '/etc/systemd/system/zookeeper.service'
      ).with({
        'ensure' => 'present',
      })
    end

    it do
      is_expected.to contain_file(
        '/etc/systemd/system/zookeeper.service'
      ).with_content(/Wants=network-online.target openvpn-client@.service/)
    end

    it do
      is_expected.to contain_service('zookeeper').with(
        :ensure => 'running',
        :enable => true
      )
    end
  end
end
