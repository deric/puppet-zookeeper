require 'spec_helper'

describe 'zookeeper::config', :type => :class do
  let(:facts) do
    {
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
    :ipaddress => '192.168.1.1',
  }
  end

  shared_examples 'common' do |os, codename|
    let(:facts) do
      {
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :ipaddress => '192.168.1.1',
    }
    end

    it do
      is_expected.to contain_file(cfg_dir).with({
      'ensure'  => 'directory',
      'owner'   => user,
      'group'   => group,
    })
    end

    it do
      is_expected.to contain_file(log_dir).with({
      'ensure'  => 'directory',
      'owner'   => user,
      'group'   => group,
    })
    end

    it do
      is_expected.to contain_file(id_file).with({
      'ensure'  => 'file',
      'owner'   => user,
      'group'   => group,
    }).with_content(myid)
    end

    context 'extra parameters' do
      snap_cnt = 15000
      # set custom params
      let(:params) do
        {
        :log4j_prop    => 'ERROR',
        :snap_count    => snap_cnt,
      }
      end

      it do
        is_expected.to contain_file('/etc/zookeeper/conf/environment').with_content(/ERROR/)
      end

      it do
        is_expected.to contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/snapCount=15000/)
      end

      # leave the default value to be determined by ZooKeeper
      it 'does not set maxClientCnxns by default' do
        # due to problem with should_not not matcher, we're using more complicated way
        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/^#maxClientCnxns=/)
      end

      # by default do not set client IP address
      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/^#clientPortAddress=/)
      end
    end

    context 'max allowed connections' do
      max_conn = 15

      let(:params) do
        {
        :max_allowed_connections => max_conn
      }
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/maxClientCnxns=#{max_conn}/)
      end
    end

    context 'set client ip address' do
      ipaddress = '192.168.1.1'
      let(:params) do
        {
        :client_ip => ipaddress
      }
      end

      it do
        should contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/clientPortAddress=#{ipaddress}/)
      end
    end

    context 'setting tick time' do
      tick_time = 3000
      let(:params) do
        {
        :tick_time => tick_time,
      }
      end

      it do
        should contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/tickTime=#{tick_time}/)
      end
    end

    context 'setting init and sync limit' do
      init_limit = 15
      sync_limit = 10
      let(:params) do
        {
        :init_limit => init_limit,
        :sync_limit => sync_limit,
      }
      end

      it do
        should contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/initLimit=#{init_limit}/)
      end

      it do
        should contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/syncLimit=#{sync_limit}/)
      end
    end

    context 'setting leader' do
      let(:params) do
        {
        :leader => false,
      }
      end

      it do
        should contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/leaderServes=no/)
      end
    end

    context 'set peer_type to observer' do
      let(:params) do
        {
        :peer_type => 'observer'
      }
      end

      it do
        should contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/peerType=observer/)
      end
    end
  end

  context 'on debian-like system' do
    let(:user)    { 'zookeeper' }
    let(:group)   { 'zookeeper' }
    let(:cfg_dir) { '/etc/zookeeper/conf' }
    let(:log_dir) { '/var/lib/zookeeper' }
    let(:id_file) { '/etc/zookeeper/conf/myid' }
    let(:myid)    { /1/ }

    it_behaves_like 'common', 'Debian', 'wheezy'
  end

  context 'custom parameters' do
    # set custom params
    let(:params) do
      {
      :id      => '2',
      :user    => 'zoo',
      :group   => 'zoo',
      :cfg_dir => '/var/lib/zookeeper/conf',
      :log_dir => '/var/lib/zookeeper/log',
    }
    end

    let(:user)    { 'zoo' }
    let(:group)   { 'zoo' }
    let(:cfg_dir) { '/var/lib/zookeeper/conf' }
    let(:log_dir) { '/var/lib/zookeeper/log' }
    let(:id_file) { '/var/lib/zookeeper/conf/myid' }
    let(:myid)    { /2/ }

    it_behaves_like 'common', 'Debian', 'wheezy'
  end

  context 'myid link' do
    it do
      should contain_file(
        '/var/lib/zookeeper/myid'
      ).with({
      'ensure' => 'link',
      'target' => '/etc/zookeeper/conf/myid',
    })
    end
  end

  context 'without datalogstore parameter' do
    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/# dataLogDir=\/disk2\/zookeeper/)
    end
  end

  context 'with datalogstore parameter' do
    let(:params) do
      {
      :datalogstore => '/zookeeper/transaction/device',
    }
    end

    let(:datalogstore) { '/zookeeper/transaction/device' }

    it do
      should contain_file(datalogstore).with({
      'ensure' => 'directory',
    })
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/dataLogDir=\/zookeeper\/transaction\/device/)
    end
  end

  context 'setting quorum of servers with custom ports' do
    let(:params) do
      {
      :election_port => 3000,
      :leader_port   => 4000,
      :servers       => ['192.168.1.1', '192.168.1.2']
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.1=192.168.1.1:3000:4000/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.2=192.168.1.2:3000:4000/)
    end
  end

  context 'setting quorum of servers with custom ports with servers as hash' do
    let(:params) do
      {
        :election_port => 3000,
        :leader_port   => 4000,
        :servers       => {'12' => '192.168.1.1', '23' => '192.168.1.2'}
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.12=192.168.1.1:3000:4000/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.23=192.168.1.2:3000:4000/)
    end
  end

  context 'setting quorum of servers with default ports' do
    let(:params) do
      {
      :servers => ['192.168.1.1', '192.168.1.2']
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.1=192.168.1.1:2888:3888/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.2=192.168.1.2:2888:3888/)
    end
  end

  context 'setting quorum of servers with default ports with servers as hash' do
    let(:params) do
      {
        :servers => {'12' => '192.168.1.1', '23' => '192.168.1.2'}
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.12=192.168.1.1:2888:3888/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.23=192.168.1.2:2888:3888/)
    end
  end

  context 'setting quorum of servers with default ports with observer' do
    let(:params) do
      {
      :servers => ['192.168.1.1', '192.168.1.2', '192.168.1.3', '192.168.1.4', '192.168.1.5'],
      :observers => ['192.168.1.4', '192.168.1.5']
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.1=192.168.1.1:2888:3888/)
    end

    it do
      should_not contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.1=192.168.1.1:2888:3888:observer/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.2=192.168.1.2:2888:3888/)
    end

    it do
      should_not contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.2=192.168.1.2:2888:3888:observer/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.3=192.168.1.3:2888:3888/)
    end

    it do
      should_not contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.3=192.168.1.3:2888:3888:observer/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.4=192.168.1.4:2888:3888:observer/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.5=192.168.1.5:2888:3888:observer/)
    end
  end

  context 'setting quorum of servers with default ports with observer with servers as hash' do
    let(:params) do
      {
        :servers => {'12' => '192.168.1.1',
                     '23' => '192.168.1.2',
                     '34' => '192.168.1.3',
                     '45' => '192.168.1.4',
                     '56' => '192.168.1.5'},
        :observers => ['192.168.1.4', '192.168.1.5']
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.12=192.168.1.1:2888:3888/)
    end

    it do
      should_not contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.12=192.168.1.1:2888:3888:observer/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.23=192.168.1.2:2888:3888/)
    end

    it do
      should_not contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.23=192.168.1.2:2888:3888:observer/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.34=192.168.1.3:2888:3888/)
    end

    it do
      should_not contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.34=192.168.1.3:2888:3888:observer/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.45=192.168.1.4:2888:3888:observer/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.56=192.168.1.5:2888:3888:observer/)
    end
  end

  context 'setting minSessionTimeout' do
    let(:params) do
      {
      :min_session_timeout => 5000
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/minSessionTimeout=5000/)
    end
  end

  context 'setting maxSessionTimeout' do
    let(:params) do
      {
      :max_session_timeout => 50000
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/maxSessionTimeout=50000/)
    end
  end


  context 'make sure port is not included in server IP/hostname' do
    let(:params) do
      {
      :servers => ['192.168.1.1:2888', '192.168.1.2:2333'],
    }
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.1=192.168.1.1:2888:3888/)
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/server.2=192.168.1.2:2888:3888/)
    end
  end
end
