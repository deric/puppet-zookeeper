require 'spec_helper'

describe 'zookeeper::sasl' do
  context 'Debian' do
    let(:facts) do
      {
      :operatingsystem => 'Debian',
      :osfamily => 'Debian',
      :operatingsystemmajrelease => '8',
      :lsbdistcodename => 'jessie',
      :puppetversion => Puppet.version,
    }
    end

    let :pre_condition do
      'class {"zookeeper":
         use_sasl_auth => true,
       }'
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('zookeeper::sasl') }

    it do
      is_expected.to contain_file(
        '/etc/zookeeper/conf/jaas.conf'
      ).with_content(/storeKey=true/)
    end

    it do
      is_expected.to contain_file(
        '/etc/zookeeper/conf/environment'
      ).with_content(/JAVA_OPTS=".* -Djava.security.auth.login.config=\/etc\/zookeeper\/conf\/jaas.conf"/)
    end
  end

  context 'RedHat' do
    let(:facts) do
      {
      :operatingsystem => 'RedHat',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :lsbdistcodename => '7',
      :puppetversion => Puppet.version,
    }
    end

    let :pre_condition do
      'class {"zookeeper":
         use_sasl_auth => true,
       }'
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('zookeeper::sasl') }

    it do
      is_expected.to contain_file(
        '/etc/zookeeper/conf/jaas.conf'
      ).with_content(/storeKey=true/)
    end

    it do
      is_expected.to contain_file(
        '/etc/zookeeper/conf/java.env'
      ).with_content(/JAVA_OPTS=".* -Djava.security.auth.login.config=\/etc\/zookeeper\/conf\/jaas.conf"/)
    end
  end
 
  context 'remove host and realm from principal' do
    let(:facts) do
      {
      :operatingsystem => 'Debian',
      :osfamily => 'Debian',
      :operatingsystemmajrelease => '8',
      :lsbdistcodename => 'jessie',
      :puppetversion => Puppet.version,
    }
    end

    let :pre_condition do
      'class {"zookeeper":
         use_sasl_auth => true,
         remove_host_principal => true,
         remove_realm_principal => true,
       }'
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('zookeeper::sasl') }

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/kerberos.removeHostFromPrincipal=true/)
    end
   
    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/kerberos.removeRealmFromPrincipal=true/)
    end

  end
end
