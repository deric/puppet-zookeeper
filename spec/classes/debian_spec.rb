require 'spec_helper'

describe 'zookeeper::os::debian', :type => :class do

  context 'with java installation' do
    let(:facts) {{
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
      :puppetversion => Puppet.version,
    }}

    let(:params) { {
      :install_java => true,
      :java_package => 'openjdk-7-jre-headless',
    } }

    it { should contain_package('openjdk-7-jre-headless').with({
      'ensure'  => 'present',
      }) }
    it { should contain_package('zookeeper').with({
      'ensure'  => 'present',
      }) }
  end

  context 'fail when no packge provided' do
    let(:facts) {{
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :lsbdistcodename => 'trusty',
    }}

    let(:params) { {
      :install_java => true,
    } }

    it { expect {
        should compile
    }.to raise_error(/Java installation is required/) }
  end

end
