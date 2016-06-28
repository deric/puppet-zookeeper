require 'spec_helper'

describe 'zookeeper::sasl', :type => :class do
  let(:facts) {{
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :majdistrelease  => '8',
    :lsbdistcodename => 'jessie',
  }}

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('zookeeper::sasl') }

  it { is_expected.to contain_file(
        '/etc/zookeeper/conf/jaas.conf'
    ).with_content(/storeKey=true/)
  }

  it { is_expected.to contain_file(
        '/etc/zookeeper/conf/java.env'
    ).with_content('export JVMFLAGS="-Djava.security.auth.login.config=/etc/zookeeper/conf/jaas.conf"')
  }

end