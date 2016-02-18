# OS specific configuration should be defined here
#
class zookeeper::params {
  $_defaults = {
    'packages' => ['zookeeper']
  }

  case $::osfamily {
    'Debian': {
      $_os_overrides = {
        'packages'     => ['zookeeper', 'zookeeperd'],
        'service_name' => 'zookeeper',
      }
    }
    'Redhat': {
      case $::operatingsystemmajrelease {
        '6': { $initstyle = 'upstart' }
        '7': { $initstyle = 'systemd' }
        default: { $initstyle = undef }
      }
      $_os_overrides = {
        'packages'     => ['zookeeper', 'zookeeper-server'],
        'service_name' => 'zookeeper-server',
        'start_with'   => $initstyle,
      }
    }

    default: {
      $_os_overrides = {}
    }
  }
  $_params = merge($_defaults, $_os_overrides)


  $packages = $_params['packages']
}