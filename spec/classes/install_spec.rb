require 'spec_helper'

describe 'zookeeper::install' do
  shared_examples 'debian-install' do |os, codename, majrelease, puppet, precond|
    let(:facts) do
      {
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :operatingsystemmajrelease => majrelease,
      :puppetversion => puppet,
    }
    end

    # load class, handle custom params
    let :pre_condition do
      precond
    end

    it { should contain_package('zookeeper') }
    it { should contain_package('zookeeperd') }
    it { should contain_package('cron') }
    it { should contain_class('zookeeper::post_install') }
    it { should compile.with_all_deps }

    it 'installs cron script' do
      should contain_cron('zookeeper-cleanup').with({
        'ensure'    => 'present',
        'command'   => '/usr/share/zookeeper/bin/zkCleanup.sh /var/lib/zookeeper 1',
        'user'      => 'zookeeper',
        'hour'      => '2',
        'minute' => '42',
      })
    end

    context 'without cron' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let :pre_condition do
        'class {"zookeeper":
           snap_retain_count => 0,
         }'
      end

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeperd') }
      it { should_not contain_package('cron') }
    end

    context 'allow changing package names' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let :pre_condition do
        'class {"zookeeper":
           packages => [ "zookeeper", "zookeeper-server" ],
         }'
      end

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeper-server') }
      it { should_not contain_package('zookeeperd') }
    end

    context 'removing package' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let :pre_condition do
        'class {"zookeeper":
           ensure => absent,
         }'
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

    precond = 'class {"zookeeper":
      snap_retain_count => 1,
    }'

    # ENV variable might contain characters which are not supported
    # by versioncmp function (like '~>')
    puppet = `puppet --version`

    it_behaves_like 'debian-install', 'Debian', 'squeeze', '6', puppet, precond
    it_behaves_like 'debian-install', 'Debian', 'wheezy', '7', puppet, precond
    it_behaves_like 'debian-install', 'Ubuntu', 'precise', '12.04', puppet, precond
  end

  context 'does not install cron script on trusty' do
    let(:facts) do
      {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
      :operatingsystemmajrelease => '14.04',
    }
    end

    let :pre_condition do
      'class {"zookeeper": }'
    end

    it { should_not contain_package('cron') }

    it 'installs cron script' do
      should_not contain_cron('zookeeper-cleanup').with({
        'ensure'    => 'present',
        'command'   => '/usr/share/zookeeper/bin/zkCleanup.sh /var/lib/zookeeper 1',
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
      :operatingsystemmajrelease => '14.04',
    }
    end

    let :pre_condition do
      'class {"zookeeper": }'
    end

    it do
      should contain_user('zookeeper').with({
      'ensure' => 'present',
      'shell' => '/bin/false',
    })
    end
  end

  shared_examples 'redhat-install' do |os, codename, puppet, precond|
    let(:facts) do
      {
      :operatingsystem => os,
      :osfamily => 'RedHat',
      :lsbdistcodename => codename,
      :operatingsystemmajrelease => codename,
      :puppetversion => puppet,
    }
    end

    # load class, handle custom params
    let :pre_condition do
      precond
    end

    it { should contain_package('zookeeper') }
    it { should_not contain_package('cron') }

    context 'with cron' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let :pre_condition do
        'class {"zookeeper":
           snap_retain_count => 5,
           manual_clean      => true,
         }'
      end

      it { should contain_package('zookeeper') }
      it { should contain_package('cron') }

      it 'installs cron script' do
        should contain_cron('zookeeper-cleanup').with({
          'ensure'    => 'present',
          'command'   => '/usr/share/zookeeper/bin/zkCleanup.sh /var/lib/zookeeper 5',
          'user'      => 'zookeeper',
          'hour'      => '2',
          'minute' => '42',
        })
      end
    end

    context 'allow installing multiple packages' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let :pre_condition do
        'class {"zookeeper":
           packages => [ "zookeeper", "zookeeper-devel" ],
         }'
      end

      it { should contain_package('zookeeper') }
      it { should contain_package('zookeeper-devel') }
    end

    context 'removing package' do
      let(:user) { 'zookeeper' }
      let(:group) { 'zookeeper' }

      let :pre_condition do
        'class {"zookeeper":
           ensure => "absent",
         }'
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

      let :pre_condition do
        'class {"zookeeper":
           install_java => true,
           java_package => "java-1.7.0-openjdk",
         }'
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

    precond = 'class {"zookeeper":
      snap_retain_count => "1",
    }'

    it_behaves_like 'redhat-install', 'RedHat', '6', Puppet.version, precond
    it_behaves_like 'redhat-install', 'CentOS', '5', Puppet.version, precond
    it_behaves_like 'redhat-install', 'Fedora', '20', Puppet.version, precond
  end


  context 'user account' do
    let(:facts) do
      {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
      :operatingsystemmajrelease => '14.04',
    }
    end
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let :pre_condition do
      'class {"zookeeper":
         ensure_account => "present",
       }'
    end

    it do
      should contain_user('zookeeper').with({
      :ensure => 'present'
    })
    end

    context 'remove user accounts' do
      let :pre_condition do
        'class {"zookeeper":
          ensure_account => "absent",
        }'
      end

      it do
        should contain_user('zookeeper').with({
        :ensure => 'absent'
      })
      end
    end

    context 'do not manage user accounts' do
      let :pre_condition do
        'class {"zookeeper":
          ensure_account => false,
        }'
      end

      it { should_not contain_user('zookeeper') }
    end
  end

  context 'installing from tar archive' do
    let(:install_dir) { '/opt' }
    let(:zoo_dir) { '/opt/zookeeper' }
    let(:vers) { '3.4.8' }
    let(:mirror_url) { 'http://apache.org/dist' }
    let(:basefilename) { "zookeeper-#{vers}.tar.gz" }
    let(:package_url) { "#{mirror_url}/zookeeper/zookeeper-#{vers}/zookeeper-#{vers}.tar.gz" }
    let(:extract_path) { "#{zoo_dir}-#{vers}" }

    let(:facts) {{
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
      :operatingsystemmajrelease => '14.04',
    }}

    let :pre_condition do
      'class {"zookeeper":
         install_method => "archive",
         archive_version => "3.4.8",
         archive_install_dir => "/opt",
         zoo_dir => "/opt/zookeeper",
       }'
    end

    it do
      should contain_file(zoo_dir).with({
        :ensure => 'link',
        :target => extract_path,
      })
    end
    it do
      should contain_archive("#{install_dir}/#{basefilename}").with({
        :extract_path => install_dir,
        :source       => package_url,
        :creates      => extract_path,
        :user         => 'root',
        :group        => 'root',
      })
    end
  end
end
