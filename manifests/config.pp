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
  $cfg_dir                 = $::zookeeper::params::cfg_dir,
  $client_ip               = $::zookeeper::params::client_ip,
  $client_port             = $::zookeeper::params::client_port,
  $datalogstore            = $::zookeeper::params::datalogstore,
  $datastore               = $::zookeeper::params::datastore,
  $election_port           = $::zookeeper::params::election_port,
  $export_tag              = $::zookeeper::params::export_tag,
  $group                   = $::zookeeper::params::group,
  $id                      = $::zookeeper::params::id,
  $init_limit              = $::zookeeper::params::init_limit,
  $initialize_datastore    = $::zookeeper::params::initialize_datastore,
  $java_bin                = $::zookeeper::params::java_bin,
  $java_opts               = $::zookeeper::params::java_opts,
  $leader                  = $::zookeeper::params::leader,
  $leader_port             = $::zookeeper::params::leader_port,
  $log_dir                 = $::zookeeper::params::log_dir,
  $log4j_prop              = $::zookeeper::params::log4j_prop,
  $max_allowed_connections = $::zookeeper::params::max_allowed_connections,
  $max_session_timeout     = $::zookeeper::params::max_session_timeout,
  $min_session_timeout     = $::zookeeper::params::min_session_timeout,
  $observers               = $::zookeeper::params::observers,
  $peer_type               = $::zookeeper::params::peer_type,
  $pid_dir                 = $::zookeeper::params::pid_dir,
  $pid_file                = $::zookeeper::params::pid_file,
  $purge_interval          = $::zookeeper::params::purge_interval,
  $rollingfile_threshold   = $::zookeeper::params::rollingfile_threshold,
  $servers                 = $::zookeeper::params::servers,
  $snap_count              = $::zookeeper::params::snap_count,
  $snap_retain_count       = $::zookeeper::params::snap_retain_count,
  $sync_limit              = $::zookeeper::params::sync_limit,
  $tick_time               = $::zookeeper::params::tick_time,
  $tracefile_threshold     = $::zookeeper::params::tracefile_threshold,
  $user                    = $::zookeeper::params::user,
  $zoo_main                = $::zookeeper::params::zoo_main,
) {
  require zookeeper::install


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

  file { "${cfg_dir}/myid":
    ensure  => file,
    content => template('zookeeper/conf/myid.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0644',
    require => File[$cfg_dir],
    notify  => Class['zookeeper::service'],
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
    notify  => Class['zookeeper::service'],
  }

  file { "${cfg_dir}/environment":
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('zookeeper/conf/environment.erb'),
    notify  => Class['zookeeper::service'],
  }

  file { "${cfg_dir}/log4j.properties":
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('zookeeper/conf/log4j.properties.erb'),
    notify  => Class['zookeeper::service'],
  }

  # keep track of all hosts in a cluster, experimental feature
  $ip = empty($client_ip) ? {
    true  => $::ipaddress,
    false => $client_ip
  }
  zookeeper::host { $ip:
    id            => $id,
    client_ip     => $ip,
    election_port => $election_port,
    leader_port   => $leader_port,
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
