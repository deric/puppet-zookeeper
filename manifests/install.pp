# Class: zookeeper::install
#
# This module manages Zookeeper installation
#
# Parameters: None
#
# Actions: None
#
#
# Should not be included directly
#
class zookeeper::install(
  $cdhver             = $::zookeeper::params::cdhver,
  $cleanup_sh         = $::zookeeper::params::cleanup_sh,
  $datastore          = $::zookeeper::params::datastore,
  $ensure             = $::zookeeper::params::ensure,
  $ensure_cron        = $::zookeeper::params::ensure_cron,
  $install_java       = $::zookeeper::params::install_java,
  $java_package       = $::zookeeper::params::java_package,
  $manual_clean       = $::zookeeper::params::manual_clean,
  $packages           = $::zookeeper::params::packages,
  $repo               = $::zookeeper::params::repo,
  $repo_source        = $::zookeeper::params::repo_source,
  $service_package    = $::zookeeper::params::service_package,
  $snap_retain_count  = $::zookeeper::params::snap_retain_count,
  $start_with         = $::zookeeper::params::start_with,
  $user               = $::zookeeper::params::user
) {
  anchor { 'zookeeper::install::begin': }
  anchor { 'zookeeper::install::end': }

  case $::osfamily {
    'Debian': {
      class { 'zookeeper::os::debian':
        before            => Anchor['zookeeper::install::end'],
        cleanup_sh        => $cleanup_sh,
        datastore         => $datastore,
        ensure            => $ensure,
        ensure_cron       => $ensure_cron,
        install_java      => $install_java,
        java_package      => $java_package,
        packages          => $packages,
        require           => Anchor['zookeeper::install::begin'],
        service_package   => $service_package,
        snap_retain_count => $snap_retain_count,
        start_with        => $start_with,
        user              => $user
      }
    }
    'RedHat': {
      class { 'zookeeper::repo':
        cdhver => $cdhver,
        config => $repo,
        ensure => $ensure,
        source => $repo_source
      }

      class { 'zookeeper::os::redhat':
        before            => Anchor['zookeeper::install::end'],
        cleanup_sh        => $cleanup_sh,
        datastore         => $datastore,
        ensure            => $ensure,
        ensure_cron       => $ensure_cron,
        install_java      => $install_java,
        java_package      => $java_package,
        packages          => $packages,
        require           => Anchor['zookeeper::install::begin'],
        snap_retain_count => $snap_retain_count,
        user              => $user
      }
    }
    default: {
      fail("Module '${module_name}' is not supported on OS: '${::operatingsystem}', family: '${::osfamily}'")
    }
  }
}
