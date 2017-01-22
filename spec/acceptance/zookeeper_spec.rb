require 'spec_helper_acceptance'

describe 'zookeeper defintion', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  context 'basic setup' do
    it 'install zookeeper' do
      pp = <<-EOS
        class{'zookeeper':
          service_provider => 'init', #systemd requires host with systemd
        }
      EOS

      expect(apply_manifest(pp,
        :catch_failures => false,
        :debug => true
      ).exit_code).to be_zero
   end

   describe file('/etc/zookeeper') do
     it { is_expected.to be_directory }
   end

   describe file('/etc/zookeeper/conf') do
     it { is_expected.to be_directory }
   end

    describe user('zookeeper') do
      it { is_expected.to exist }
    end

    describe group('zookeeper') do
      it { is_expected.to exist }
    end

    describe service('zookeeper') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe command('cat /etc/zookeeper/conf/myid') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match /^1$/ }
    end
 end
end