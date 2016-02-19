require 'spec_helper'

describe 'zookeeper::install', :type => :class do

  shared_examples 'debian-install' do |os, codename, puppet|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :puppetversion => puppet,
    }}

    it { should contain_package('zookeeper') }
    it { should contain_package('zookeeperd') }
    it { should contain_package('cron') }
    it { should contain_class('zookeeper::post_install') }
    it { should compile.with_all_deps }

    it 'installs cron script' do
      should contain_cron('zookeeper-cleanup').with({
        'ensure'    => 'present',
        'command'   => '/usr/lib/zookeeper/bin/zkCleanup.sh /var/lib/zookeeper 1',
        'user'      => 'zookeeper',
        'hour'      => '2',
        'minute'      => '42',
      })
    end

    context 'without cron' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) { {
        :snap_retain_count => 0,
      } }

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeperd') }
      it { should_not contain_package('cron') }
    end

    context 'allow changing service package name' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) { {
        :service_package => 'zookeeper-server',
      } }

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeper-server') }
      it { should_not contain_package('zookeeperd') }
    end

    context 'allow installing multiple packages' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) { {
        :packages => [ 'zookeeper', 'zookeeper-bin' ],
      } }

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeper-bin') }
    end

    context 'removing package' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) { {
        :ensure => 'absent',
      } }

      it {

        should contain_package('zookeeper').with({
        'ensure'  => 'absent',
        })
      }
      it {
        should contain_package('zookeeperd').with({
        'ensure'  => 'absent',
        })
      }
      it { should_not contain_package('cron') }
    end
  end

  context 'on debian-like system' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) {{
      :snap_retain_count => 1,
    }}
    # ENV variable might contain characters which are not supported
    # by versioncmp function (like '~>')
    puppet = `puppet --version`

    it_behaves_like 'debian-install', 'Debian', 'squeeze', puppet
    it_behaves_like 'debian-install', 'Debian', 'wheezy', puppet
    it_behaves_like 'debian-install', 'Ubuntu', 'precise', puppet
  end

  context 'does not install cron script on trusty' do
    let(:facts) {{
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
    }}

    it { should_not contain_package('cron') }

    it 'installs cron script' do
      should_not contain_cron('zookeeper-cleanup').with({
        'ensure'    => 'present',
        'command'   => '/usr/lib/zookeeper/bin/zkCleanup.sh /var/lib/zookeeper 1',
        'user'      => 'zookeeper',
        'hour'      => '2',
        'minute'    => '42',
      })
    end
  end

  # create user with proper shell #50 (https://github.com/deric/puppet-zookeeper/issues/50)
  context 'ensure user resource exists' do
    let(:facts) {{
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
    }}

    it { should contain_user('zookeeper').with({
      'ensure' => 'present',
      'shell' => '/bin/false',
    }) }
  end

  shared_examples 'redhat-install' do |os, codename, puppet|
    let(:facts) {{
      :operatingsystem => os,
      :osfamily => 'RedHat',
      :lsbdistcodename => codename,
      :puppetversion => puppet,
    }}

    it { should contain_package('zookeeper') }
    it { should_not contain_package('cron') }

    context 'with cron' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) { {
        :snap_retain_count => 5,
        :manual_clean      => true,
      } }

      it { should contain_package('zookeeper') }
      it { should contain_package('cron') }

      it 'installs cron script' do
        should contain_cron('zookeeper-cleanup').with({
          'ensure'    => 'present',
          'command'   => '/usr/lib/zookeeper/bin/zkCleanup.sh /var/lib/zookeeper 5',
          'user'      => 'zookeeper',
          'hour'      => '2',
          'minute'      => '42',
        })
      end
    end

    context 'allow installing multiple packages' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) { {
        :packages => [ 'zookeeper', 'zookeeper-devel' ],
      } }

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeper-devel') }
    end

    context 'removing package' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) { {
        :ensure => 'absent',
      } }

      it {
        should contain_package('zookeeper').with({
        'ensure'  => 'absent',
        })
      }
      it {
        should_not contain_package('zookeeperd').with({
        'ensure'  => 'present',
        })
      }
      it { should_not contain_package('cron') }
    end

    context 'with java installation' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) { {
        :install_java => true,
        :java_package => 'java-1.7.0-openjdk',
      } }

      it { should contain_package('java-1.7.0-openjdk').with({
        'ensure'  => 'present',
        }) }
      it { should contain_package('zookeeper').with({
        'ensure'  => 'present',
        }) }
    end
  end

  context 'on RedHat-like system' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }
    # ENV variable might contain characters which are not supported
    # by versioncmp function (like '~>')

    let(:params) { {
      :snap_retain_count => 1,
    } }

    it_behaves_like 'redhat-install', 'RedHat', '6', Puppet.version
    it_behaves_like 'redhat-install', 'CentOS', '5', Puppet.version
    it_behaves_like 'redhat-install', 'Fedora', '20', Puppet.version
  end


  context 'user account' do
    let(:facts) {{
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
    }}
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) {{
      :ensure_account => 'present',
    }}

    it { should contain_user('zookeeper').with({
      :ensure => 'present'
    }) }

    context 'remove user accounts' do

      let(:params) {{
        :ensure_account => 'absent',
      }}

      it { should contain_user('zookeeper').with({
        :ensure => 'absent'
      }) }
    end

    context 'do not manage user accounts' do
      let(:params) {{
        :ensure_account => false,
      }}

      it { should_not contain_user('zookeeper') }
    end
  end

end