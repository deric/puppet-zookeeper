#
# ZooKeeper installation on Debian
class zookeeper::os::debian(
  $ensure            = present,
  $service_provider  = 'init.d',
  # cloudera package is called zookeeper-server
  $service_package   = 'zookeeperd',
  $packages          = ['zookeeper'],
  $install_java      = false,
  $java_package      = undef
) {

  validate_bool($install_java)

  # if $install_java, try to make sure a JDK package is installed
  if ($install_java){
    if !$java_package {
      fail ( 'Java installation is required, but no java package was provided.' )
    }

    validate_string($java_package)

    # make sure the Java package is only installed once.
    anchor { 'zookeeper::os::debian::java': }

    # parameter allow_virtual is not supported before Puppet 3.6
    if versioncmp($::puppetversion, '3.6.0') >= 0 {
      ensure_resource('package', $java_package,
        {'ensure' => $ensure, 'allow_virtual' => true,
        'before' => Anchor['zookeeper::os::debian::java']}
      )
    } else {
      ensure_resource('package', $java_package,
        {'ensure' => $ensure,
        'before' => Anchor['zookeeper::os::debian::java']}
      )
    }

    ensure_resource('package', $packages,
      {'ensure' => $ensure, 'require' => Anchor['zookeeper::os::debian::java']}
    )
  } else {
    # allow installing multiple packages, like zookeeper, zookeeper-bin etc.
    ensure_resource('package', $packages, {'ensure' => $ensure})
  }

  # make sure, that service package was not installed earlier
  if ($service_provider == 'init.d' and (!member($packages, $service_package))) {
    package { [$service_package]: #init.d scripts for zookeeper
      ensure  => $ensure,
    }
  }

}
