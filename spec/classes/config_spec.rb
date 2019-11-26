require 'spec_helper'

describe 'zookeeper::config' do
  let(:facts) do
    {
    :operatingsystem => 'Debian',
    :osfamily => 'Debian',
    :lsbdistcodename => 'wheezy',
    :operatingsystemmajrelease => '7',
    :ipaddress => '192.168.1.1',
    :puppetversion => Puppet.version,
  }
  end

  shared_examples 'common' do |os, codename, majrelease, precond|
    let(:facts) do
      {
      :operatingsystem => os,
      :osfamily => 'Debian',
      :lsbdistcodename => codename,
      :operatingsystemmajrelease => majrelease,
      :ipaddress => '192.168.1.1',
      :puppetversion => Puppet.version,
    }
    end

    # load class, handle custom params
    let :pre_condition do
      precond
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
      # set custom params
      let :pre_condition do
        'class {"zookeeper":
           log4j_prop => "ERROR",
           snap_count => 15000,
         }'
      end

      it do
        is_expected.to contain_file('/etc/zookeeper/conf/environment').with_content(/ERROR/)
        is_expected.to contain_file('/etc/zookeeper/conf/environment').with_content(/CLASSPATH/)
      end

      it do
        is_expected.to contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/snapCount=15000/)
      end

      # leave the default value to be determined by ZooKeeper
      it 'does not set maxClientCnxns by default' do
        # due to problem with should_not not matching, we're using more complicated way
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

    context 'admin server options' do
      enable = false
      port = '3000'
      url = '/alternative'
      let :pre_condition do
        "class {'zookeeper':
           archive_version => '3.5.5',
           admin_enable_server => #{enable},
           admin_server_port => #{port},
           admin_command_url => '#{url}'
         }"
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/admin.enableServer=#{enable}/)

        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/admin.serverPort=#{port}/)

        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/admin.commandURL=#{url}/)
      end
    end

    context 'admin server disables if version < 3.5.5' do
      enable = false
      port = '3000'
      url = '/alternative'
      let :pre_condition do
        "class {'zookeeper':
           archive_version => '3.5.4',
           admin_enable_server => #{enable},
           admin_server_port => #{port},
           admin_command_url => '#{url}'
         }"
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).without_content(/admin.enableServer=#{enable}/)

        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).without_content(/admin.serverPort=#{port}/)

        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).without_content(/admin.commandURL=#{url}/)
      end
    end

    context 'install from archive' do
      let :pre_condition do
        'class {"zookeeper":
           install_method: "archive",
           archive_version: "3.4.9",
        }'

        it {is_expected.to contain_file('/etc/zookeeper/conf/environment').without_content(/CLASSPATH/)}

      end
    end

    context 'extra environment_file parameter' do
       # set custom params
       let :pre_condition do
         'class {"zookeeper":
            log4j_prop => "ERROR",
            environment_file => "java.env",
          }'
       end

       it do
         should contain_file('/etc/zookeeper/conf/java.env').with_content(/ERROR/)
         should_not contain_file('/etc/zookeeper/environment')
       end
    end

    context 'max allowed connections' do
      let :pre_condition do
        'class {"zookeeper":
           max_allowed_connections => 15,
         }'
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/maxClientCnxns=15/)
      end
    end

    context 'set client ip address' do
      let :pre_condition do
        'class {"zookeeper":
           client_ip => "192.168.1.1",
         }'
      end

      it do
        should contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/clientPortAddress=192.168.1.1/)
      end
    end

    context 'setting tick time' do
      let :pre_condition do
        'class {"zookeeper":
           tick_time => 3000,
         }'
      end

      it do
        should contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/tickTime=3000/)
      end
    end

    context 'setting init and sync limit' do
      let :pre_condition do
        'class {"zookeeper":
           init_limit => 15,
           sync_limit => 10,
         }'
      end

      it do
        should contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/initLimit=15/)
      end

      it do
        should contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/syncLimit=10/)
      end
    end

    context 'setting leader' do
      let :pre_condition do
        'class {"zookeeper":
           leader => false,
         }'
      end

      it do
        should contain_file('/etc/zookeeper/conf/zoo.cfg').with_content(/leaderServes=no/)
      end
    end

    context 'set peer_type to observer' do
      let :pre_condition do
        'class {"zookeeper":
           peer_type => "observer",
         }'
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
    let(:myid)    { /^1/ }

    precond = 'class {"zookeeper": }'

    it_behaves_like 'common', 'Debian', 'wheezy', '7', precond
  end

  context 'custom parameters' do
    # set custom params
    precond = 'class {"zookeeper":
      id      => "2",
      user    => "zoo",
      group   => "zoo",
      cfg_dir => "/var/lib/zookeeper/conf",
      log_dir => "/var/lib/zookeeper/log",
    }'

    let(:user)    { 'zoo' }
    let(:group)   { 'zoo' }
    let(:cfg_dir) { '/var/lib/zookeeper/conf' }
    let(:log_dir) { '/var/lib/zookeeper/log' }
    let(:id_file) { '/var/lib/zookeeper/conf/myid' }
    let(:myid)    { /^2/ }

    it_behaves_like 'common', 'Debian', 'wheezy', '7', precond
  end

  context 'myid link' do
    let :pre_condition do
      'class {"zookeeper":}'
    end

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
    let :pre_condition do
      'class {"zookeeper":}'
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/# dataLogDir=\/disk2\/zookeeper/)
    end
  end

  context 'with datalogstore parameter' do
    let :pre_condition do
      'class {"zookeeper":
         datalogstore => "/zookeeper/transaction/device",
       }'
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
    let :pre_condition do
      'class {"zookeeper":
         election_port => 3000,
         leader_port   => 4000,
         servers       => ["192.168.1.1", "192.168.1.2"],
       }'
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
    let :pre_condition do
      'class {"zookeeper":
         election_port => 3000,
         leader_port   => 4000,
         servers       => {"12" => "192.168.1.1", "23" => "192.168.1.2"},
       }'
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
    let :pre_condition do
      'class {"zookeeper":
         servers => ["192.168.1.1", "192.168.1.2"]
       }'
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
    let :pre_condition do
      'class {"zookeeper":
         servers => {"12" => "192.168.1.1", "23" => "192.168.1.2"},
       }'
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
    let :pre_condition do
      'class {"zookeeper":
         servers   => ["192.168.1.1", "192.168.1.2", "192.168.1.3", "192.168.1.4", "192.168.1.5"],
         observers => ["192.168.1.4", "192.168.1.5"]
       }'
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
    let :pre_condition do
      'class {"zookeeper":
         servers   => {"12" => "192.168.1.1",
                       "23" => "192.168.1.2",
                       "34" => "192.168.1.3",
                       "45" => "192.168.1.4",
                       "56" => "192.168.1.5"},
         observers => ["192.168.1.4", "192.168.1.5"]
       }'
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
    let :pre_condition do
      'class {"zookeeper":
         min_session_timeout => 5000
       }'
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/minSessionTimeout=5000/)
    end
  end

  context 'setting maxSessionTimeout' do
    let :pre_condition do
      'class {"zookeeper":
         max_session_timeout => 50000
       }'
    end

    it do
      should contain_file(
        '/etc/zookeeper/conf/zoo.cfg'
      ).with_content(/maxSessionTimeout=50000/)
    end
  end

  context 'make sure port is not included in server IP/hostname' do
    let :pre_condition do
      'class {"zookeeper":
         servers => ["192.168.1.1:2888", "192.168.1.2:2333"]
       }'
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

  context 'configure logging' do
    context 'by default set to INFO' do
      let :pre_condition do
        'class {"zookeeper": }'
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/log4j.properties'
        ).with_content(/zookeeper.log.threshold=INFO/)
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/log4j.properties'
        ).with_content(/zookeeper.console.threshold=INFO/)
      end
    end

    context 'allow changing rollingfile loglevel' do
      let :pre_condition do
        'class {"zookeeper":
           rollingfile_threshold => "TRACE",
         }'
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/log4j.properties'
        ).with_content(/zookeeper.log.threshold=TRACE/)
      end
    end

    context 'allow changing console loglevel' do
      let :pre_condition do
        'class {"zookeeper":
           console_threshold => "TRACE",
         }'
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/log4j.properties'
        ).with_content(/zookeeper.console.threshold=TRACE/)
      end
    end

    context 'allow changing tracefile loglevel' do
      let :pre_condition do
        'class {"zookeeper":
           tracefile_threshold => "DEBUG",
         }'
      end

      it do
        is_expected.to contain_file(
          '/etc/zookeeper/conf/log4j.properties'
        ).with_content(/log4j.appender.TRACEFILE.Threshold=DEBUG/)
      end
    end

    context 'setting 4lw whitelist' do
      let :pre_condition do
        'class {"zookeeper":
           whitelist_4lw => ["ruok","stat"]
         }'
      end

      it do
        should contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/4lw.commands.whitelist=ruok,stat/)
      end
    end

    context 'set global outstanding limit' do
      let :pre_condition do
        'class {"zookeeper":
           global_outstanding_limit => 2000
         }'
      end

      it do
        should contain_file(
          '/etc/zookeeper/conf/zoo.cfg'
        ).with_content(/globalOutstandingLimit=2000/)
      end
    end


  end

end
