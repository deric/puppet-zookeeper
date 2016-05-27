# Class: zookeeper::config
#
# This module manages the zookeeper configuration directories
#
# Parameters:
# [* id *]  zookeeper instance id: between 1 and 255
#
# [* servers *] an Array - specify all zookeeper servers
# The fist port is used by followers to connect to the leader
# The second one is used for leader election
#     server.1=zookeeper1:2888:3888
#     server.2=zookeeper2:2888:3888
#     server.3=zookeeper3:2888:3888
#
#
# Actions: None
#
# Requires: zookeeper::install, zookeeper
#
# Sample Usage: include zookeeper::config
#
class zookeeper::config(
  $id                      = '1',
  $datastore               = '/var/lib/zookeeper',
  $datalogstore            = undef,
  $initialize_datastore    = false,
  # use either IP address, or a fact, e.g.: $::ipaddress
  $client_ip               = undef,
  $client_port             = 2181,
  $election_port           = 2888,
  $leader_port             = 3888,
  $snap_count              = 10000,
  $log_dir                 = '/var/log/zookeeper',
  $cfg_dir                 = '/etc/zookeeper/conf',
  $user                    = 'zookeeper',
  $group                   = 'zookeeper',
  $java_bin                = '/usr/bin/java',
  $java_opts               = '',
  $pid_dir                 = '/var/run',
  $pid_file                = undef,
  $zoo_main                = 'org.apache.zookeeper.server.quorum.QuorumPeerMain',
  $log4j_prop              = 'INFO,ROLLINGFILE',
  $servers                 = [''],
  $observers               = [''],
  # since zookeeper 3.4, for earlier version cron task might be used
  $snap_retain_count       = 3,
  # interval in hours, purging enabled when >= 1
  $purge_interval          = 0,
  # log4j properties
  $rollingfile_threshold   = 'ERROR',
  $tracefile_threshold     = 'TRACE',
  $max_allowed_connections = undef,
  $export_tag              = 'zookeeper',
  $peer_type               = 'UNSET',
  $tick_time               = 2000,
  $init_limit              = 10,
  $sync_limit              = 5,
  $leader                  = true,
  $min_session_timeout     = undef,
  $max_session_timeout     = undef,
  # systemd_unit_want and _after can be overridden to
  # donate the matching directives in the [Unit] section
  $systemd_unit_want       = undef,
  $systemd_unit_after      = 'network.target',
) {
  require ::zookeeper::install

  if $pid_file {
    $pid_path = $pid_file
  } else {
    $pid_path = "${pid_dir}/zookeeper.pid"
  }

  file { $cfg_dir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    recurse => true,
    mode    => '0644',
  }

  file { $log_dir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    recurse => false,
    mode    => '0644',
  }

  file { $datastore:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    recurse => false, # intentionally, puppet run would take too long #41
  }

  if $datalogstore {
    file { $datalogstore:
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      recurse => false, # intentionally, puppet run would take too long #41
    }
  }

  # we should notify Class['::zookeeper::service'] however it's not configured
  # at this point (first run), so we have to subscribe from service declaration
  file { "${cfg_dir}/myid":
    ensure  => file,
    content => template('zookeeper/conf/myid.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0644',
    require => File[$cfg_dir],
  }

  file { "${datastore}/myid":
    ensure  => 'link',
    target  => "${cfg_dir}/myid",
    require => File["${cfg_dir}/myid"]
  }

  file { "${cfg_dir}/zoo.cfg":
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('zookeeper/conf/zoo.cfg.erb'),
  }

  file { "${cfg_dir}/environment":
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('zookeeper/conf/environment.erb'),
  }

  file { "${cfg_dir}/log4j.properties":
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('zookeeper/conf/log4j.properties.erb'),
  }

  # Initialize the datastore if required
  if $initialize_datastore {
    exec { 'initialize_datastore':
      command => "/usr/bin/zookeeper-server-initialize --myid=${id}",
      user    => $user,
      creates => "${datastore}/version-2",
      require => File[$datastore],
    }
  }
}
