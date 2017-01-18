require 'spec_helper'

describe 'zookeeper', :type => :class do
  let(:facts) do
    {
    :operatingsystem           => 'Debian',
    :osfamily                  => 'Debian',
    :lsbdistcodename           => 'wheezy',
    :operatingsystemmajrelease => '7',
    :ipaddress                 => '192.168.1.1',
  }
  end

  it { is_expected.to contain_class('zookeeper::config') }
  it { is_expected.to contain_class('zookeeper::install') }
  it { is_expected.to contain_class('zookeeper::service') }
  it { is_expected.to compile.with_all_deps }

  context 'allow installing multiple packages' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) do
      {
        :packages => [ 'zookeeper', 'zookeeper-bin' ],
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_package('zookeeper').with({:ensure => 'present'}) }
    it { is_expected.to contain_package('zookeeper-bin').with({:ensure => 'present'}) }
    it { is_expected.to contain_service('zookeeper').with({:ensure => 'running'}) }
    # datastore exec is not included by default
    it { is_expected.not_to contain_exec('initialize_datastore') }

    it { is_expected.to contain_user('zookeeper').with({:ensure => 'present'}) }
    it { is_expected.to contain_group('zookeeper').with({:ensure => 'present'}) }
  end

  context 'Cloudera packaging' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) do
      {
      :packages             => ['zookeeper','zookeeper-server'],
      :service_name         => 'zookeeper-server',
      :initialize_datastore => true
    }
    end

    it { should contain_package('zookeeper').with({:ensure => 'present'}) }
    it { should contain_package('zookeeper-server').with({:ensure => 'present'}) }
    it { should contain_service('zookeeper-server').with({:ensure => 'running'}) }
    it { should contain_exec('initialize_datastore') }
  end

  context 'setting minSessionTimeout' do
    let(:params) do
      {
      :min_session_timeout => 3000
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/minSessionTimeout=3000/)
    end
  end

  context 'setting maxSessionTimeout' do
    let(:params) do
      {
      :max_session_timeout => 60000
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/maxSessionTimeout=60000/)
    end
  end

  context 'disable service management' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) do
      {
      :manage_service => false,
    }
    end

    it { should contain_package('zookeeper').with({:ensure => 'present'}) }
    it { should_not contain_service('zookeeper').with({:ensure => 'running'}) }
    it { should_not contain_class('zookeeper::service') }
  end

  context 'use Cloudera RPM repo' do
    let(:facts) do
      {
      :ipaddress => '192.168.1.1',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :hardwaremodel => 'x86_64',
      :puppetversion => Puppet.version,
    }
    end

    let(:params) do
      {
      :repo => 'cloudera',
      :cdhver => '5',
    }
    end

    it { should contain_class('zookeeper::install::repo') }
    it { should contain_yumrepo('cloudera-cdh5') }

    context 'custom RPM repo' do
      let(:params) do
        {
        :repo => {
          'name'  => 'myrepo',
          'url'   => 'http://repo.url',
          'descr' => 'custom repo',
        },
        :cdhver => '5',
      }
      end
      it { should contain_yumrepo('myrepo').with({:baseurl => 'http://repo.url'}) }
    end
  end

  context 'service provider' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    # provider is detected based on facts
    context 'do not set provider by default' do
      it { is_expected.to contain_package('zookeeper').with({:ensure => 'present'}) }
      it do
        is_expected.to contain_service('zookeeper').with({
        :ensure => 'running',
        :provider => 'init',
      })
      end
    end

    context 'autodetect provider on RedHat 7' do
      let(:facts) do
        {
        :ipaddress => '192.168.1.1',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7',
      }
      end
      it { should contain_package('zookeeper').with({:ensure => 'present'}) }
      it { should contain_package('zookeeper-server').with({:ensure => 'present'}) }
      it do
        should contain_service('zookeeper-server').with({
        :ensure => 'running',
        :provider => 'systemd',
      })
      end
    end

    it { should contain_class('zookeeper::service') }
  end

  context 'allow passing specific version' do
    let(:facts) do
      {
      :ipaddress => '192.168.1.1',
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :operatingsystemmajrelease => '14.04',
      :lsbdistcodename => 'trusty',
    }
    end

    let(:version) {'3.4.5+dfsg-1'}

    let(:params) do
      {
      :ensure => version,
    }
    end

    it { should contain_package('zookeeper').with({:ensure => version}) }
    it { should contain_package('zookeeperd').with({:ensure => version}) }

    it { should contain_user('zookeeper').with({:ensure => 'present'}) }
  end

  context 'upstart is used on Ubuntu' do
    let(:facts) do
      {
      :ipaddress => '192.168.1.1',
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :operatingsystemmajrelease => '14.04',
      :lsbdistcodename => 'trusty',
    }
    end

    let(:params) do
      {
    }
    end

    it { should contain_package('zookeeper').with({:ensure => 'present'}) }
    it { should contain_package('zookeeperd').with({:ensure => 'present'}) }
    it do
      should contain_service('zookeeper').with({
      :ensure => 'running',
      :provider => 'upstart',
    })
    end
  end

  context 'set pid file for init provider' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:facts) do
      {
      :ipaddress => '192.168.1.1',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '6',
    }
    end

    let(:params) do
      {
      :zoo_dir             => '/usr/lib/zookeeper',
      :log_dir             => '/var/log/zookeeper',
      :manage_service      => true,
      :manage_service_file => true,
      :service_provider    => 'init',
    }
    end

    context 'set service provider' do
      it { is_expected.to contain_package('zookeeper').with({:ensure => 'present'}) }
      it do
        is_expected.to contain_service('zookeeper-server').with({
        :ensure => 'running',
        :provider => 'init',
      })
      end
    end

    it do
      is_expected.to contain_file(
        '/etc/init.d/zookeeper-server'
      ).with_content(/pidfile=\/var\/run\/zookeeper.pid/)
    end
  end

  context 'create env file' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    context 'on RedHat' do
      let(:facts) do
        {
        :ipaddress => '192.168.1.1',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '6',
      }
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/java.env'
        )
      end
    end

    context 'on Debian' do
      let(:facts) do
        {
        :ipaddress => '192.168.1.1',
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :lsbdistcodename => 'jessie',
        :operatingsystemmajrelease => '8',
      }
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/environment'
        )
      end
    end

  end

  context 'managed by exhibitor' do
    let(:params) do
      {
        :service_provider => 'exhibitor',
        :service_name => 'zookeeper',
        :cfg_dir => '/opt/zookeeper/conf',
      }
    end

    it { is_expected.not_to contain_class('zookeeper::service') }
    it { is_expected.not_to contain_service('zookeeper') }
    it { is_expected.not_to contain_file('/opt/zookeeper/conf/zoo.cfg') }
    it { is_expected.not_to contain_file('/opt/zookeeper/conf/myid') }
  end

  context 'install from archive' do
    let(:params) do
      {
        install_method: 'archive',
        archive_version: '3.4.9',
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('Zookeeper::Install::Archive') }

    it { is_expected.not_to contain_package('zookeeper').with({:ensure => 'present'}) }
    it { is_expected.to contain_service('zookeeper').with({:ensure => 'running'}) }

    it { is_expected.to contain_user('zookeeper').with({:ensure => 'present'}) }
    it { is_expected.to contain_group('zookeeper').with({:ensure => 'present'}) }

  end
end
