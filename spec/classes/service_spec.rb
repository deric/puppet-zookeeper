require 'spec_helper'

describe 'zookeeper::service' do
  let(:facts) {{
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
  }}

  let(:params){{
    :zoo_dir => '/usr/lib/zookeeper',
    :log_dir => '/var/log/zookeeper',
  }}

  it { should contain_package('zookeeperd') }
  it { should contain_service('zookeeper').with(
    :ensure => 'running',
    :enable => true
  )}

  context 'RHEL 7' do
    puppet = Puppet.version
    let(:facts) {{
      :operatingsystem => 'RedHat',
      :osfamily => 'RedHat',
      :lsbdistcodename => '7',
      :operatingsystemmajrelease => '7',
      :puppetversion => puppet,
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }}

    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params){{
      :zoo_dir          => '/usr/lib/zookeeper',
      :log_dir          => '/var/log/zookeeper',
      :service_provider => 'systemd',
    }}

    it { should contain_package('zookeeper') }

    it { should contain_file(
      '/usr/lib/systemd/system/zookeeper.service'
      ).with({
        'ensure'  => 'present',
      })
    }

    it { should contain_service('zookeeper').with(
      :ensure => 'running',
      :enable => true
    )}

    context 'do not manage systemd' do
      let(:params){{
        :manage_systemd => false,
        :zoo_dir => '/usr/lib/zookeeper',
        :log_dir => '/var/log/zookeeper',
      }}

      it { should_not contain_file(
        '/usr/lib/systemd/system/zookeeper.service'
        ).with({
          'ensure'  => 'present',
        })
      }
    end
  end
end
