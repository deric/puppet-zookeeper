# Class: zookeeper
#
# This module manages zookeeper
#
# Parameters:
#   id
#   user
#   group
#   log_dir
#
# Sample Usage:
#
#   class { 'zookeeper': }
#
class zookeeper(
  $id                      = '1',
  $datastore               = '/var/lib/zookeeper',
  # datalogstore used to put transaction logs in separate location than snapshots
  $datalogstore            = undef,
  $initialize_datastore    = false,
  # fact from which we get public ip address
  $client_ip               = undef, # use e.g. $::ipaddress if you want to bind to single interface
  $client_port             = 2181,
  $election_port           = 2888,
  $leader_port             = 3888,
  $log_dir                 = '/var/log/zookeeper',
  $cfg_dir                 = '/etc/zookeeper/conf',
  $zoo_dir                 = '/usr/lib/zookeeper',
  $user                    = 'zookeeper',
  $group                   = 'zookeeper',
  $ensure_account          = present,
  $java_bin                = '/usr/bin/java',
  $java_opts               = '',
  $pid_dir                 = '/var/run',
  $pid_file                = undef,
  $zoo_main                = 'org.apache.zookeeper.server.quorum.QuorumPeerMain',
  $log4j_prop              = 'INFO,ROLLINGFILE',
  $cleanup_sh              = '/usr/share/zookeeper/bin/zkCleanup.sh',
  $servers                 = [],
  $observers               = [],
  $ensure                  = present,
  $snap_count              = 10000,
  # since zookeeper 3.4, for earlier version cron task might be used
  $snap_retain_count       = 3,
  # interval in hours, purging enabled when >= 1
  $purge_interval          = 0,
  # log4j properties
  $rollingfile_threshold   = 'ERROR',
  $tracefile_threshold     = 'TRACE',
  $max_allowed_connections = undef,
  $peer_type               = 'UNSET',
  $start_with              = undef,
  $ensure_cron             = true,
  $service_package         = undef,
  $service_name            = $::zookeeper::params::service_name,
  $service_provider        = $::zookeeper::params::service_provider,
  $manage_service          = true,
  $manage_service_file     = false,
  $packages                = $::zookeeper::params::packages,
  $cdhver                  = undef,
  $install_java            = false,
  $java_package            = undef,
  $min_session_timeout     = undef,
  $max_session_timeout     = undef,
  $manage_systemd          = undef,
  $repo                    = undef,
  # systemd_unit_want and _after can be overridden to
  # donate the matching directives in the [Unit] section
  $systemd_unit_want       = undef,
  $systemd_unit_after      = 'network.target',
) inherits ::zookeeper::params {

  validate_array($packages)
  validate_bool($ensure_cron)
  validate_bool($manage_service)
  validate_bool($install_java)
  validate_bool($initialize_datastore)

  if($service_package) {
    warning('Parameter `service_package` is deprecated, use `packages` array instead.')
  }

  if ($start_with) {
    warning('Parameter `start_with` is deprecated, use `service_provider` instead. `start_with` will be removed in next major release.')
    $_service_provider = $start_with
  } else {
    $_service_provider = $service_provider
  }

  if ($manage_systemd) {
    warning('Parameter `manage_systemd` is deprecated, use `manage_service_file` instead. `manage_systemd` will be removed in next major release.')
    $_manage_service_file = $manage_systemd
  } else {
    $_manage_service_file = $manage_service_file
  }

  anchor { 'zookeeper::start': }->
  class { 'zookeeper::install':
    ensure            => $ensure,
    snap_retain_count => $snap_retain_count,
    datastore         => $datastore,
    user              => $user,
    group             => $group,
    ensure_account    => $ensure_account,
    cleanup_sh        => $cleanup_sh,
    service_provider  => $_service_provider,
    ensure_cron       => $ensure_cron,
    service_package   => $service_package,
    packages          => $packages,
    repo              => $repo,
    cdhver            => $cdhver,
    install_java      => $install_java,
    java_package      => $java_package,
  }->
  class { 'zookeeper::config':
    id                      => $id,
    datastore               => $datastore,
    datalogstore            => $datalogstore,
    initialize_datastore    => $initialize_datastore,
    client_ip               => $client_ip,
    client_port             => $client_port,
    election_port           => $election_port,
    leader_port             => $leader_port,
    log_dir                 => $log_dir,
    cfg_dir                 => $cfg_dir,
    user                    => $user,
    group                   => $group,
    java_bin                => $java_bin,
    java_opts               => $java_opts,
    pid_dir                 => $pid_dir,
    pid_file                => $pid_file,
    zoo_main                => $zoo_main,
    log4j_prop              => $log4j_prop,
    servers                 => $servers,
    observers               => $observers,
    snap_count              => $snap_count,
    snap_retain_count       => $snap_retain_count,
    purge_interval          => $purge_interval,
    rollingfile_threshold   => $rollingfile_threshold,
    tracefile_threshold     => $tracefile_threshold,
    max_allowed_connections => $max_allowed_connections,
    peer_type               => $peer_type,
    min_session_timeout     => $min_session_timeout,
    max_session_timeout     => $max_session_timeout,
    systemd_unit_want       => $systemd_unit_want,
    systemd_unit_after      => $systemd_unit_after,
  }

  if ($manage_service) {
    class { 'zookeeper::service':
      cfg_dir             => $cfg_dir,
      zoo_dir             => $zoo_dir,
      service_name        => $service_name,
      service_provider    => $_service_provider,
      manage_service_file => $_manage_service_file,
      require             => Class['zookeeper::config'],
      before              => Anchor['zookeeper::end'],
      user                => $user,
      group               => $group,
      pid_file            => $pid_file,
      zoo_main            => $zoo_main,
      log_dir             => $log_dir,
      log4j_prop          => $log4j_prop
    }
  }
  anchor { 'zookeeper::end': }

}
