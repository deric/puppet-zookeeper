# Class: zookeeper::install
#
# This module manages installation tasks.
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::install inherits zookeeper {
  anchor { 'zookeeper::install::begin': }

  $os_family = $facts['os']['family']

  # Repo management
  case $os_family {
    'RedHat', 'Suse': {
      include zookeeper::install::repo
      Anchor['zookeeper::install::begin']
      -> Class['zookeeper::install::repo']
    }
    default: {} # nothing to do
  }

  # Java installation
  if ($zookeeper::install_java) {
    if !$zookeeper::java_package {
      fail('Java installation is required, but no java package was provided.')
    }

    validate_string($zookeeper::java_package)

    # Make sure the Java package is only installed once.
    anchor { 'zookeeper::install::java': }

    ensure_resource('package', $zookeeper::java_package,
      {'ensure' => $zookeeper::ensure, 'allow_virtual' => true,
      'before'  => Anchor['zookeeper::install::intermediate'],
      'require' => Anchor['zookeeper::install::begin']}
    )
  }

  anchor { 'zookeeper::install::intermediate': }

  # Package installation
  case $zookeeper::install_method {
    'archive': {
      include zookeeper::install::archive
      Anchor['zookeeper::install::intermediate']
      -> Class['zookeeper::install::archive']
      -> Anchor['zookeeper::install::end']
    }
    'package': {
      include zookeeper::install::package
      Anchor['zookeeper::install::intermediate']
      -> Class['zookeeper::install::package']
      -> Anchor['zookeeper::install::end']
    }
    default: {
      fail('Valid installation methods are `package` or `archive`')
    }
  }

  anchor { 'zookeeper::install::end': }

  # Post installation tasks
  class { 'zookeeper::post_install':
    require => Anchor['zookeeper::install::end'],
  }
}
