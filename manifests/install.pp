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
  $install_method    = 'package',
  $mirror_url        = 'http://mirror.cogentco.com/pub/apache',
  $archive_checksum  = {},
  $zoo_dir           = '/usr/lib/zookeeper',
  $package_dir       = '/var/tmp/zookeeper',
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

  if ($install_method == 'package') {
    include '::zookeeper::install::package'
    $_manual_clean = $manual_clean
  } elsif ($install_method == 'archive') {
    include '::zookeeper::install::archive'

    $clean_cmp = versioncmp($ensure, '3.4') ? {
      '-1'    => true,
      default => false,
    }

    $_manual_clean = $manual_clean ? {
      undef   => $clean_cmp,
      default => $manual_clean,
    }
  } else {
    fail("specify a valid install method for zookeeper")
  }

  anchor { 'zookeeper::install::end': }

  class { 'zookeeper::post_install':
    ensure            => $ensure,
    ensure_account    => $ensure_account,
    ensure_cron       => $ensure_cron,
    user              => $user,
    group             => $group,
    datastore         => $datastore,
    snap_retain_count => $snap_retain_count,
    cleanup_sh        => $cleanup_sh,
    manual_clean      => $_manual_clean,
    require           => Anchor['zookeeper::install::end'],
  }

}

