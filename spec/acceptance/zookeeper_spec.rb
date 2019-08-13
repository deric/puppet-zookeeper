require 'spec_helper_acceptance'

describe 'zookeeper defintion', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  context 'basic setup' do
    it 'install zookeeper' do
      pp = <<-EOS
        class{'zookeeper':
          client_port => 2181,
        }
      EOS

      expect(apply_manifest(pp,
        :catch_failures => false,
        :debug => false
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

    describe command('/etc/init.d/zookeeper status') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match /running/ }
    end

    # give zookeeper some time to boot
    describe command('sleep 2 && netstat -tulpn') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match /2181/ }
    end

    describe command('cat /etc/zookeeper/conf/myid') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match /^1$/ }
    end

    describe file('/etc/zookeeper/conf/zoo.cfg') do
      it { is_expected.to be_file }
      it { is_expected.to be_writable.by('owner') }
      it { is_expected.to be_readable.by('group') }
      it { is_expected.to be_readable.by('others') }
    end

    describe command('cat /etc/zookeeper/conf/zoo.cfg') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match /^clientPort=2181$/ }
    end

    describe command('echo stat | nc 0.0.0.0 2181') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match /^Mode: standalone$/ }
    end
  end
end
