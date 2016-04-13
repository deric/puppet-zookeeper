# OS specific configuration should be defined here
#
class zookeeper::params {
  $_defaults = {
    'packages' => ['zookeeper']
  }

  case $::osfamily {
    'Debian': {
      case $::operatingsystem {
        'Debian': {
          case $::majdistrelease {
            '7': { $initstyle = 'init' }
            '8': { $initstyle = 'systemd' }
            default: { $initstyle = undef }
          }
        }
        'Ubuntu': {
          case $::majdistrelease {
            '14.04': { $initstyle = 'upstart' }
            default: { $initstyle = undef }
          }
        }
        default: { $initstyle = undef }
      }

      $_os_overrides = {
        'packages'         => ['zookeeper', 'zookeeperd'],
        'service_name'     => 'zookeeper',
        'service_provider' => $initstyle,
      }
    }
    'Redhat': {
      case $::operatingsystemmajrelease {
        '6': { $initstyle = 'redhat' }
        '7': { $initstyle = 'systemd' }
        default: { $initstyle = undef }
      }
      $_os_overrides = {
        'packages'         => ['zookeeper', 'zookeeper-server'],
        'service_name'     => 'zookeeper-server',
        'service_provider' => $initstyle,
      }
    }

    default: {
      $_os_overrides = {}
    }
  }
  $_params = merge($_defaults, $_os_overrides)


  $packages = $_params['packages']
  $service_provider = $_params['service_provider']
  $service_name = $_params['service_name']
}
