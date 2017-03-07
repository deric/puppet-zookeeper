require 'spec_helper'

describe 'zookeeper::service' do
  let(:facts) do
    {
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
    :operatingsystemmajrelease => '6',
  }
  end

  let :pre_condition do
    'class {"zookeeper":
       zoo_dir => "/usr/lib/zookeeper",
       log_dir => "/var/log/zookeeper",
     }'
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

    let :pre_condition do
      'class {"zookeeper":
         manage_service_file => true,
         service_provider    => "systemd",
         zoo_dir             => "/usr/lib/zookeeper",
         log_dir             => "/var/log/zookeeper",
       }'
    end

    it { should contain_package('zookeeper') }

    it do
      should contain_file(
        '/usr/lib/systemd/system/zookeeper-server.service'
      ).with({
        'ensure' => 'present',
      })
    end

    it do
      should contain_file(
        '/usr/lib/systemd/system/zookeeper-server.service'
      ).with_content(/zookeeper\.jar/)
    end

    it do
      should contain_service('zookeeper-server').with(
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
          should contain_file(
            '/usr/lib/systemd/system/my-zookeeper.service'
          ).with({
            'ensure' => 'present',
          })
        end

        it do
          should contain_service('my-zookeeper').with(
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
        should contain_file(
          '/usr/lib/systemd/system/zookeeper-server.service'
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
      :operatingsystemmajrelease => '6',
      :puppetversion => puppet,
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
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
