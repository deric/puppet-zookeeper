# Class: zookeeper::install::archive
#
# This module manages Zookeeper installation from an archive file supported by
# the 'archive' type
#
# Parameters: None
#
# Actions: None
#
#
# Should not be included directly
#
class zookeeper::install::archive(
  $mirror_url        = $::zookeeper::install::mirror_url,
  $install_dir       = $::zookeeper::install::zoo_dir,
  $archive_checksum  = $::zookeeper::install::archive_checksum,
  $package_dir       = $::zookeeper::install::package_dir,
  $ensure            = $::zookeeper::install::ensure,
  $snap_retain_count = $::zookeeper::install::snap_retain_count,
  $cleanup_sh        = $::zookeeper::install::cleanup_sh,
  $datastore         = $::zookeeper::install::datastore,
  $user              = $::zookeeper::install::user,
  $group             = $::zookeeper::install::group,
  $ensure_account    = $::zookeeper::install::ensure_account,
  $service_provider  = $::zookeeper::install::service_provider,
  $ensure_cron       = $::zookeeper::install::ensure_cron,
  $service_package   = $::zookeeper::install::service_package,
  $packages          = $::zookeeper::install::packages,
  $cdhver            = $::zookeeper::install::cdhver,
  $install_java      = $::zookeeper::install::install_java,
  $java_package      = $::zookeeper::install::java_package,
  $repo              = $::zookeeper::install::repo,
  $manual_clean      = $::zookeeper::install::manual_clean,
) {

  include '::archive'

  $basefilename = "zookeeper-${ensure}.tar.gz"
  $package_url = "${mirror_url}/zookeeper/zookeeper-${ensure}/${basefilename}"
  $extract_path = "${install_dir}-${ensure}"

  package { ['zookeeper','zookeeperd']:
    ensure => absent
  }

  file { $install_dir:
    ensure => link,
    target => $extract_path
  }

  file { $package_dir:
    ensure  => directory,
    owner   => 'zookeeper',
    group   => 'zookeeper',
    require => [
      Group['zookeeper'],
      User['zookeeper'],
    ],
  }

  file { $extract_path:
    ensure  => directory,
    owner   => 'zookeeper',
    group   => 'zookeeper',
    require => [
      Group['zookeeper'],
      User['zookeeper'],
    ],
  }

  archive { "${package_dir}/${basefilename}":
    ensure          => present,
    extract         => true,
    extract_command => 'tar xfz %s --strip-components=1',
    extract_path    => $extract_path,
    source          => $package_url,
    checksum        => $archive_checksum['hash'],
    checksum_type   => $archive_checksum['type'],
    creates         => "${extract_path}/lib",
    cleanup         => true,
    user            => 'zookeeper',
    group           => 'zookeeper',
    require         => [
      File[$package_dir],
      File[$install_dir],
      Group['zookeeper'],
      User['zookeeper'],
    ],
  }
}
