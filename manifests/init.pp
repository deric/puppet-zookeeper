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
  $cdhver                   = $::zookeeper::params::cdhver,
  $cfg_dir                  = $::zookeeper::params::cfg_dir,
  $cleanup_sh               = $::zookeeper::params::cleanup_sh,
  $client_ip                = $::zookeeper::params::client_ip,
  $client_port              = $::zookeeper::params::client_port,
  $datalogstore             = $::zookeeper::params::datalogstore,
  $datastore                = $::zookeeper::params::datastore,
  $election_port            = $::zookeeper::params::election_port,
  $ensure                   = $::zookeeper::params::ensure,
  $ensure_cron              = $::zookeeper::params::ensure_cron,
  $export_tag               = $::zookeeper::params::export_tag,
  $group                    = $::zookeeper::params::group,
  $id                       = $::zookeeper::params::id,
  $init_limit               = $::zookeeper::params::init_limit,
  $initialize_datastore     = $::zookeeper::params::initialize_datastore,
  $install_java             = $::zookeeper::params::install_java,
  $java_bin                 = $::zookeeper::params::java_bin,
  $java_opts                = $::zookeeper::params::java_opts,
  $java_package             = $::zookeeper::params::java_package,
  $leader                   = $::zookeeper::params::leader,
  $leader_port              = $::zookeeper::params::leader_port,
  $log_dir                  = $::zookeeper::params::log_dir,
  $log4j_prop               = $::zookeeper::params::log4j_prop,
  $manage_service           = $::zookeeper::params::manage_service,
  $manage_systemd           = $::zookeeper::params::manage_systemd,
  $manual_clean             = $::zookeeper::params::manual_clean,
  $max_allowed_connections  = $::zookeeper::params::max_allowed_connections,
  $max_session_timeout      = $::zookeeper::params::max_session_timeout,
  $min_session_timeout      = $::zookeeper::params::min_session_timeout,
  $observers                = $::zookeeper::params::observers,
  $packages                 = $::zookeeper::params::packages,
  $peer_type                = $::zookeeper::params::peer_type,
  $pid_dir                  = $::zookeeper::params::pid_dir,
  $pid_file                 = $::zookeeper::params::pid_file,
  $purge_interval           = $::zookeeper::params::purge_interval,
  $repo                     = $::zookeeper::params::repo,
  $repo_source              = $::zookeeper::params::repo_source,
  $rollingfile_threshold    = $::zookeeper::params::rollingfile_threshold,
  $servers                  = $::zookeeper::params::servers,
  $service_ensure           = $::zookeeper::params::service_ensure,
  $service_name             = $::zookeeper::params::service_name,
  $service_package          = $::zookeeper::params::service_package,
  $snap_count               = $::zookeeper::params::snap_count,
  $snap_retain_count        = $::zookeeper::params::snap_retain_count,
  $start_with               = $::zookeeper::params::start_with,
  $sync_limit               = $::zookeeper::params::sync_limit,
  $tick_time                = $::zookeeper::params::tick_time,
  $tracefile_threshold      = $::zookeeper::params::tracefile_threshold,
  $user                     = $::zookeeper::params::user,
  $zoo_main                 = $::zookeeper::params::zoo_main
) inherits zookeeper::params {
  notify{"${tick_time} tick time":}
  notify{"${init_limit} init_limit":}
  notify{"${sync_limit} sync_limit":}
  notify{"${zoo_main} zoo_main":}

  validate_array($packages)
  validate_bool($ensure_cron)
  validate_bool($manage_service)
  # TODO: more validation needed

  anchor { 'zookeeper::start': }->
  class { 'zookeeper::install':
    cdhver            => $cdhver,
    cleanup_sh        => $cleanup_sh,
    datastore         => $datastore,
    ensure            => $ensure,
    ensure_cron       => $ensure_cron,
    install_java      => $install_java,
    java_package      => $java_package,
    manual_clean      => $manual_clean,
    packages          => $packages,
    repo              => $repo,
    repo_source       => $repo_source,
    service_package   => $service_package,
    snap_retain_count => $snap_retain_count,
    start_with        => $start_with,
    user              => $user,
  }->
  class { 'zookeeper::config':
    cfg_dir                 => $cfg_dir,
    client_ip               => $client_ip,
    client_port             => $client_port,
    datalogstore            => $datalogstore,
    datastore               => $datastore,
    election_port           => $election_port,
    export_tag              => $export_tag,
    group                   => $group,
    id                      => $id,
    init_limit              => $init_limit,
    initialize_datastore    => $initialize_datastore,
    java_bin                => $java_bin,
    java_opts               => $java_opts,
    leader_port             => $leader_port,
    log_dir                 => $log_dir,
    log4j_prop              => $log4j_prop,
    max_allowed_connections => $max_allowed_connections,
    max_session_timeout     => $max_session_timeout,
    min_session_timeout     => $min_session_timeout,
    observers               => $observers,
    peer_type               => $peer_type,
    pid_dir                 => $pid_dir,
    pid_file                => $pid_file,
    purge_interval          => $purge_interval,
    rollingfile_threshold   => $rollingfile_threshold,
    servers                 => $servers,
    snap_count              => $snap_count,
    snap_retain_count       => $snap_retain_count,
    sync_limit              => $sync_limit,
    tick_time               => $tick_time,
    tracefile_threshold     => $tracefile_threshold,
    user                    => $user,
    zoo_main                => $zoo_main,
  }

  if ($manage_service) {
    class { 'zookeeper::service':
      before          => Anchor['zookeeper::end'],
      cfg_dir         => $cfg_dir,
      group           => $group,
      manage_systemd  => $manage_systemd,
      require         => Class['zookeeper::config'],
      service_ensure  => $service_ensure,
      service_name    => $service_name,
      user            => $user
    }
  }
  anchor { 'zookeeper::end': }

}
