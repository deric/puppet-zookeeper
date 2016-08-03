require 'spec_helper'

describe 'zookeeper::sasl', :type => :class do
  let(:facts) do
    {
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :majdistrelease  => '8',
    :lsbdistcodename => 'jessie',
  }
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
    ).with_content('export JVMFLAGS="-Djava.security.auth.login.config=/etc/zookeeper/conf/jaas.conf"')
  end
end