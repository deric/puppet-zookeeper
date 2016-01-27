# Class: zookeeper::service

class zookeeper::service(
  $cfg_dir        = $::zookeeper::params::cfg_dir,
  $group          = $::zookeeper::params::group,
  $manage_systemd = $::zookeeper::params::manage_systemd,
  $service_ensure = $::zookeeper::params::service_ensure,
  $service_name   = $::zookeeper::params::service_name,
  $user           = $::zookeeper::params::user
){
  require zookeeper::install

  case $::osfamily {
    'redhat': {
      case $::operatingsystemmajrelease {
        '6': { $initstyle = 'upstart' }
        '7': { $initstyle = 'systemd' }
        default: { $initstyle = 'unknown' }
      }
    }
    default: { $initstyle = 'unknown' }
  }

  if ($initstyle == 'systemd' and $manage_systemd == true) {
    file { '/usr/lib/systemd/system/zookeeper.service':
      ensure  => 'present',
      content => template('zookeeper/zookeeper.service.erb'),
    } ~>
    exec { 'systemctl daemon-reload # for zookeeper':
      refreshonly => true,
      path        => $::path,
      notify      => Service[$service_name]
    }
  }

  service { $service_name:
    ensure     => $service_ensure,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => [
      Class['zookeeper::install'],
      File["${cfg_dir}/zoo.cfg"]
    ]
  }
}
