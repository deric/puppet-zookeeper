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
  $ensure            = present,
  $snap_retain_count = 3,
  $cleanup_sh        = '/usr/lib/zookeeper/bin/zkCleanup.sh',
  $datastore         = '/var/lib/zookeeper',
  $user              = 'zookeeper',
  $group             = 'zookeeper',
  $ensure_account    = present,
  $service_provider  = 'init.d',
  $ensure_cron       = true,
  $service_package   = 'zookeeperd',
  $packages          = ['zookeeper'],
  $cdhver            = undef,
  $install_java      = false,
  $java_package      = undef,
  $repo              = undef,
  $manual_clean      = undef,
) {
  anchor { 'zookeeper::install::begin': }
  anchor { 'zookeeper::install::end': }

  $repo_source = is_hash($repo) ? {
      true  => 'custom',
      false => $repo
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

  class { 'zookeeper::post_install':
    ensure            => $ensure,
    ensure_account    => $ensure_account,
    ensure_cron       => $ensure_cron,
    user              => $user,
    group             => $group,
    datastore         => $datastore,
    snap_retain_count => $snap_retain_count,
    cleanup_sh        => $cleanup_sh,
    manual_clean      => $manual_clean,
    require           => Anchor['zookeeper::install::end'],
  }

}
