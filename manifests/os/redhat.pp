#
# ZooKeeper installation on Redhat
class zookeeper::os::redhat(
  $ensure            = present,
  $packages          = ['zookeeper'],
  $manual_clean      = false,
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
    anchor { 'zookeeper::os::redhat::java': }

    # parameter allow_virtual is not supported before Puppet 3.6
    if versioncmp($::puppetversion, '3.6.0') >= 0 {
      ensure_resource('package', $java_package,
        {'ensure' => $ensure, 'allow_virtual' => true,
        'before' => Anchor['zookeeper::os::redhat::java']}
      )
    } else {
      ensure_resource('package', $java_package,
        {'ensure' => $ensure,
        'before' => Anchor['zookeeper::os::redhat::java']}
      )
    }

    ensure_resource('package', $packages,
      {'ensure' => $ensure, 'require' => Anchor['zookeeper::os::redhat::java']}
    )
  } else {
    # allow installing multiple packages, like zookeeper, zookeeper-bin etc.
    ensure_resource('package', $packages, {'ensure' => $ensure})
  }


}
