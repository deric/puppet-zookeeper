# Class: zookeeper::service

class zookeeper::service(
  $zoo_dir,
  $log_dir,
  $start_with     = undef,    # init mechanism
  $cfg_dir        = '/etc/zookeeper/conf',
  $service_name   = 'zookeeper',
  $service_ensure = 'running',
  $manage_systemd = true,
  $user           = 'zookeeper',
  $group          = 'zookeeper'
){
  require zookeeper::install

  if ($start_with == 'systemd' and $manage_systemd == true) {
    file { '/usr/lib/systemd/system/zookeeper.service':
      ensure  => 'present',
      content => template('zookeeper/zookeeper.service.erb'),
      replace => 'no'
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
