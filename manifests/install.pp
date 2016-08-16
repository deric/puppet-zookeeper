# Class: zookeeper::install
#
# This module manages installation tasks.
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::install {
  anchor { 'zookeeper::install::begin': }

  # Repo management
  case $::osfamily {
    'RedHat': {
      class { 'zookeeper::install::repo':
        require => Anchor['zookeeper::install::begin']
      }
    }
    default: {} # nothing to do
  }

  # Java installation
  if ($::zookeeper::install_java) {
    if !$::zookeeper::java_package {
      fail('Java installation is required, but no java package was provided.')
    }

    validate_string($::zookeeper::java_package)

    # Make sure the Java package is only installed once.
    anchor { 'zookeeper::install::java': }

    # parameter allow_virtual is not supported before Puppet 3.6
    if versioncmp($::puppetversion, '3.6.0') >= 0 {
      ensure_resource('package', $::zookeeper::java_package,
        {'ensure' => $::zookeeper::ensure, 'allow_virtual' => true,
        'before'  => Anchor['zookeeper::install::intermediate'],
        'require' => Anchor['zookeeper::install::begin']}
      )
    } else {
      ensure_resource('package', $::zookeeper::java_package,
        {'ensure' => $::zookeeper::ensure,
        'before'  => Anchor['zookeeper::install::intermediate'],
        'require' => Anchor['zookeeper::install::begin']}
      )
    }
  }

  anchor { 'zookeeper::install::intermediate': }

  # Package installation
  case $::zookeeper::install_method {
    'archive': {
      class { 'zookeeper::install::archive':
        before  => Anchor['zookeeper::install::end'],
        require => Anchor['zookeeper::install::intermediate'],
      }
    }
    'package': {
      class { 'zookeeper::install::package':
        before  => Anchor['zookeeper::install::end'],
        require => Anchor['zookeeper::install::intermediate'],
      }
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
