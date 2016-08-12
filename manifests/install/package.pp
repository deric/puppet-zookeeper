# Class: zookeeper::install::package
#
# This module manages Zookeeper installation through a package manager
#
# Parameters: None
#
# Actions: None
#
#
# Should not be included directly
#
class zookeeper::install::package(
  $ensure             = $::zookeeper::install::ensure,
  $snap_retain_count  = $::zookeeper::install::snap_retain_count,
  $cleanup_sh         = $::zookeeper::install::cleanup_sh,
  $datastore          = $::zookeeper::install::datastore,
  $user               = $::zookeeper::install::user,
  $group              = $::zookeeper::install::group,
  $ensure_account     = $::zookeeper::install::ensure_account,
  $service_provider   = $::zookeeper::install::service_provider,
  $ensure_cron        = $::zookeeper::install::ensure_cron,
  $service_package    = $::zookeeper::install::service_package,
  $packages           = $::zookeeper::install::packages,
  $cdhver             = $::zookeeper::install::cdhver,
  $install_java       = $::zookeeper::install::install_java,
  $java_package       = $::zookeeper::install::java_package,
  $repo               = $::zookeeper::install::repo,
  $manual_clean       = $::zookeeper::install::manual_clean,
) {

  $repo_source = is_hash($repo) ? {
        true  => 'custom',
        false =>  $repo,
  }
  case $::osfamily {
    'Debian': {
      class { 'zookeeper::os::debian':
        ensure           => $ensure,
        service_provider => $service_provider,
        service_package  => $service_package,
        packages         => $packages,
        before           => Anchor['zookeeper::install::end'],
        require          => Anchor['zookeeper::install::begin'],
        install_java     => $install_java,
        java_package     => $java_package
      }
    }
    'RedHat': {
      class { 'zookeeper::repo':
        source => $repo_source,
        cdhver => $cdhver,
        config => $repo
      }

      class { 'zookeeper::os::redhat':
        ensure       => $ensure,
        packages     => $packages,
        require      => Anchor['zookeeper::install::begin'],
        before       => Anchor['zookeeper::install::end'],
        install_java => $install_java,
        java_package => $java_package
      }
    }
    default: {
      fail("Module '${module_name}' is not supported on OS: '${::operatingsystem}', family: '${::osfamily}'")
    }
  }
}
