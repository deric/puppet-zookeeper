# Class: zookeeper
#
# This module manages ZooKeeper
class zookeeper(
  # meta options
  $ensure                  = $::zookeeper::params::ensure,
  $ensure_account          = $::zookeeper::params::ensure_account,
  $ensure_cron             = $::zookeeper::params::ensure_cron,
  $group                   = $::zookeeper::params::group,
  $packages                = $::zookeeper::params::packages,
  $shell                   = $::zookeeper::params::shell,
  $user                    = $::zookeeper::params::user,
  # installation options
  $archive_checksum        = $::zookeeper::params::archive_checksum,
  $archive_dl_site         = $::zookeeper::params::archive_dl_site,
  $archive_dl_timeout      = $::zookeeper::params::archive_dl_timeout,
  $archive_dl_url          = $::zookeeper::params::archive_dl_url,
  $archive_install_dir     = $::zookeeper::params::archive_install_dir,
  $archive_symlink         = $::zookeeper::params::archive_symlink,
  $archive_symlink_name    = $::zookeeper::params::archive_symlink_name,
  $archive_version         = $::zookeeper::params::archive_version,
  $cdhver                  = $::zookeeper::params::cdhver,
  $install_java            = $::zookeeper::params::install_java,
  $install_method          = $::zookeeper::params::install_method,
  $java_bin                = $::zookeeper::params::java_bin,
  $java_opts               = $::zookeeper::params::java_opts,
  $java_package            = $::zookeeper::params::java_package,
  $repo                    = $::zookeeper::params::repo,
  # service options
  $manage_service          = $::zookeeper::params::manage_service,
  $manage_service_file     = $::zookeeper::params::manage_service_file,
  $pid_dir                 = $::zookeeper::params::pid_dir,
  $pid_file                = $::zookeeper::params::pid_file,
  $service_ensure          = $::zookeeper::params::service_ensure,
  $service_name            = $::zookeeper::params::service_name,
  $service_provider        = $::zookeeper::params::service_provider,
  $systemd_unit_want       = $::zookeeper::params::systemd_unit_want,
  $systemd_unit_after      = $::zookeeper::params::systemd_unit_after,
  # zookeeper config
  $cfg_dir                 = $::zookeeper::params::cfg_dir,
  $cleanup_sh              = $::zookeeper::params::cleanup_sh,
  $client_ip               = $::zookeeper::params::client_ip,
  $client_port             = $::zookeeper::params::client_port,
  $datastore               = $::zookeeper::params::datastore,
  $datalogstore            = $::zookeeper::params::datalogstore,
  $election_port           = $::zookeeper::params::election_port,
  $export_tag              = $::zookeeper::params::export_tag,
  $id                      = $::zookeeper::params::id,
  $init_limit              = $::zookeeper::params::init_limit,
  $initialize_datastore    = $::zookeeper::params::initialize_datastore,
  $leader                  = $::zookeeper::params::leader,
  $leader_port             = $::zookeeper::params::leader_port,
  $log_dir                 = $::zookeeper::params::log_dir,
  $manual_clean            = $::zookeeper::params::manual_clean,
  $max_session_timeout     = $::zookeeper::params::max_session_timeout,
  $min_session_timeout     = $::zookeeper::params::min_session_timeout,
  $observers               = $::zookeeper::params::observers,
  $purge_interval          = $::zookeeper::params::purge_interval,
  $servers                 = $::zookeeper::params::servers,
  $snap_count              = $::zookeeper::params::snap_count,
  $snap_retain_count       = $::zookeeper::params::snap_retain_count,
  $sync_limit              = $::zookeeper::params::sync_limit,
  $tick_time               = $::zookeeper::params::tick_time,
  $use_sasl_auth           = $::zookeeper::params::use_sasl_auth,
  $zoo_dir                 = $::zookeeper::params::zoo_dir,
  $zoo_main                = $::zookeeper::params::zoo_main,
  # log4j properties
  $environment_file        = $::zookeeper::params::environment_file,
  $log4j_prop              = $::zookeeper::params::log4j_prop,
  $max_allowed_connections = $::zookeeper::params::max_allowed_connections,
  $peer_type               = $::zookeeper::params::peer_type,
  $rollingfile_threshold   = $::zookeeper::params::rollingfile_threshold,
  $tracefile_threshold     = $::zookeeper::params::tracefile_threshold,
  $console_threshold       = $::zookeeper::params::console_threshold,
  # sasl options
  $keytab_path             = $::zookeeper::params::keytab_path,
  $principal               = $::zookeeper::params::principal,
  $realm                   = $::zookeeper::params::realm,
  $store_key               = $::zookeeper::params::store_key,
  $use_keytab              = $::zookeeper::params::use_keytab,
  $use_ticket_cache        = $::zookeeper::params::use_ticket_cache
) inherits ::zookeeper::params {

  validate_array($packages)
  validate_bool($ensure_cron)
  validate_bool($install_java)
  validate_bool($initialize_datastore)
  validate_bool($manage_service)
  validate_bool($use_sasl_auth)
  validate_hash($archive_checksum)
  validate_integer($id)
  validate_integer($init_limit)
  validate_integer($leader_port)
  validate_integer($snap_count)
  validate_integer($snap_retain_count)
  validate_integer($sync_limit)
  validate_integer($tick_time)

  if $pid_file {
    $pid_path = $pid_file
  } else {
    $pid_path = "${pid_dir}/zookeeper.pid"
  }

  $repo_source = is_hash($repo) ? {
    true  => 'custom',
    false => $repo
  }

  if $::zookeeper::ensure_account {
    group { $group:
      ensure => $ensure_account,
    }

    user { $user:
      ensure  => $ensure_account,
      home    => $datastore,
      comment => 'Zookeeper',
      gid     => $group,
      shell   => $shell,
      require => Group[$group]
    }
  }


  anchor { 'zookeeper::start': }->
  class { 'zookeeper::install': }->
  class { 'zookeeper::config': }

  if ($use_sasl_auth) {
    class { 'zookeeper::sasl':
      require => Class['::zookeeper::config'],
      before  => Class['::zookeeper::service'],
    }
  }

  if ($manage_service) and ($service_provider != 'exhibitor') {
    class { 'zookeeper::service':
      require => Class['::zookeeper::config'],
      before  => Anchor['zookeeper::end'],
    }
  }
  anchor { 'zookeeper::end': }

}
