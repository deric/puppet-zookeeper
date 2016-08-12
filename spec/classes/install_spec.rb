require 'spec_helper'

describe 'zookeeper::install', :type => :class do
  shared_examples 'debian-install' do |os, codename, puppet|
    let(:facts) do
      {
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :puppetversion => puppet,
    }
    end

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
        'minute' => '42',
      })
    end

    context 'without cron' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) do
        {
        :snap_retain_count => 0,
      }
      end

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeperd') }
      it { should_not contain_package('cron') }
    end

    context 'allow changing service package name' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) do
        {
        :service_package => 'zookeeper-server',
      }
      end

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeper-server') }
      it { should_not contain_package('zookeeperd') }
    end

    context 'allow installing multiple packages' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) do
        {
        :packages => [ 'zookeeper', 'zookeeper-bin' ],
      }
      end

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeper-bin') }
    end

    context 'removing package' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) do
        {
        :ensure => 'absent',
      }
      end

      it do
        should contain_package('zookeeper').with({
        'ensure' => 'absent',
        })
      end
      it do
        should contain_package('zookeeperd').with({
        'ensure' => 'absent',
        })
      end
      it { should_not contain_package('cron') }
    end
  end

  context 'on debian-like system' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) do
      {
      :snap_retain_count => 1,
    }
    end
    # ENV variable might contain characters which are not supported
    # by versioncmp function (like '~>')
    puppet = `puppet --version`

    it_behaves_like 'debian-install', 'Debian', 'squeeze', puppet
    it_behaves_like 'debian-install', 'Debian', 'wheezy', puppet
    it_behaves_like 'debian-install', 'Ubuntu', 'precise', puppet
  end

  context 'does not install cron script on trusty' do
    let(:facts) do
      {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
    }
    end

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
    let(:facts) do
      {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
    }
    end

    it do
      should contain_user('zookeeper').with({
      'ensure' => 'present',
      'shell' => '/bin/false',
    })
    end
  end

  shared_examples 'redhat-install' do |os, codename, puppet|
    let(:facts) do
      {
      :operatingsystem => os,
      :osfamily => 'RedHat',
      :lsbdistcodename => codename,
      :puppetversion => puppet,
    }
    end

    it { should contain_package('zookeeper') }
    it { should_not contain_package('cron') }

    context 'with cron' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) do
        {
        :snap_retain_count => 5,
        :manual_clean      => true,
      }
      end

      it { should contain_package('zookeeper') }
      it { should contain_package('cron') }

      it 'installs cron script' do
        should contain_cron('zookeeper-cleanup').with({
          'ensure'    => 'present',
          'command'   => '/usr/lib/zookeeper/bin/zkCleanup.sh /var/lib/zookeeper 5',
          'user'      => 'zookeeper',
          'hour'      => '2',
          'minute' => '42',
        })
      end
    end

    context 'allow installing multiple packages' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) do
        {
        :packages => [ 'zookeeper', 'zookeeper-devel' ],
      }
      end

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeper-devel') }
    end

    context 'removing package' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) do
        {
        :ensure => 'absent',
      }
      end

      it do
        should contain_package('zookeeper').with({
        'ensure' => 'absent',
        })
      end
      it do
        should_not contain_package('zookeeperd').with({
        'ensure' => 'present',
        })
      end
      it { should_not contain_package('cron') }
    end

    context 'with java installation' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let(:params) do
        {
        :install_java => true,
        :java_package => 'java-1.7.0-openjdk',
      }
      end

      it do
        should contain_package('java-1.7.0-openjdk').with({
        'ensure' => 'present',
        })
      end
      it do
        should contain_package('zookeeper').with({
        'ensure' => 'present',
        })
      end
    end
  end

  context 'on RedHat-like system' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }
    # ENV variable might contain characters which are not supported
    # by versioncmp function (like '~>')

    let(:params) do
      {
      :snap_retain_count => 1,
    }
    end

    it_behaves_like 'redhat-install', 'RedHat', '6', Puppet.version
    it_behaves_like 'redhat-install', 'CentOS', '5', Puppet.version
    it_behaves_like 'redhat-install', 'Fedora', '20', Puppet.version
  end


  context 'user account' do
    let(:facts) do
      {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
    }
    end
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) do
      {
      :ensure_account => 'present',
    }
    end

    it do
      should contain_user('zookeeper').with({
      :ensure => 'present'
    })
    end

    context 'remove user accounts' do
      let(:params) do
        {
        :ensure_account => 'absent',
      }
      end

      it do
        should contain_user('zookeeper').with({
        :ensure => 'absent'
      })
      end
    end

    context 'do not manage user accounts' do
      let(:params) do
        {
        :ensure_account => false,
      }
      end

      it { should_not contain_user('zookeeper') }
    end
  end

  context 'installing from tar archive' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }
    let(:package_dir) { '/tmp/zookeeper' }
    let(:zoo_dir) { '/opt/zookeeper' }
    let(:vers) { '3.4.5' }
    let(:mirror_url) { 'http://mirror.cogentco.com/pub/apache' }
    let(:basefilename) { "zookeeper-#{vers}.tar.gz" }
    let(:package_url) { "#{mirror_url}/zookeeper/zookeeper-#{vers}/zookeeper-#{vers}.tar.gz" }
    let(:extract_path) { "#{zoo_dir}-#{vers}" }

    let(:facts) {{
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
    }}

    let(:params) { {
      :install_method => 'archive',
      :package_dir    => package_dir,
      :zoo_dir        => zoo_dir,
      :ensure         => vers,
      :mirror_url     => mirror_url,
    } }

    it do
      should contain_file(package_dir).with({
        :ensure => 'directory',
        :owner  => user,
        :group  => group,
      })
    end
    it do
      should contain_file(extract_path).with({
        :ensure => 'directory',
        :owner  => user,
        :group  => group,
      })
    end
    it do
      should contain_file(zoo_dir).with({
        :ensure => 'link',
        :target => extract_path,
      })
    end
    it do
      should contain_archive("#{package_dir}/#{basefilename}").with({
        :extract_path => extract_path,
        :source       => package_url,
        :creates      => "#{extract_path}/lib",
        :user         => user,
        :group        => group,
      })
    end
	end

end
