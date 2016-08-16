# Class: zookeeper::install::archive
#
# This module manages archive installation
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::install::archive {

  $download_url = $::zookeeper::archive_dl_url ? {
    undef   => "${::zookeeper::archive_dl_site}/${module_name}-${::zookeeper::archive_version}/${module_name}-${::zookeeper::archive_version}.tar.gz",
    default => $::zookeeper::archive_dl_url,
  }

  archive { "${::zookeeper::archive_install_dir}/${module_name}-${::zookeeper::archive_version}.tar.gz":
    ensure        => present,
    user          => 'root',
    group         => 'root',
    source        => $download_url,
    extract_path  => $::zookeeper::archive_install_dir,
    # Extract files as the user doing the extracting, which is the user
    # that runs Puppet, usually root
    extract_flags => '-x --no-same-owner -f',
    creates       => "${::zookeeper::archive_install_dir}/${module_name}-${::zookeeper::archive_version}",
    extract       => true,
    cleanup       => true,
    notify        => Exec['chown_zookeeper_directory'],
  }

  $symlink_require = Archive["${::zookeeper::archive_install_dir}/${module_name}-${::zookeeper::archive_version}.tar.gz"]

  exec { 'chown_zookeeper_directory':
    command     => "chown -R ${::zookeeper::user}:${::zookeeper::group} ${::zookeeper::archive_install_dir}/${module_name}-${::zookeeper::archive_version}",
    path        => ['/bin','/sbin'],
    refreshonly => true,
    require     => $symlink_require,
  }

  if $::zookeeper::archive_symlink {

    file { $::zookeeper::archive_symlink_name:
      ensure  => link,
      require => $symlink_require,
      target  => "${::zookeeper::archive_install_dir}/${module_name}-${::zookeeper::archive_version}",
      owner   => $::zookeeper::user,
      group   => $::zookeeper::group,
    }

  }
}
