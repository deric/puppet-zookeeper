# Class: zookeeper::service
#
# Should not be included directly
#
class zookeeper::service(
  $zoo_dir,
  $log_dir,
  $pid_file            = undef,
  $service_provider    = undef,    # init mechanism
  $cfg_dir             = '/etc/zookeeper/conf',
  $service_name        = 'zookeeper',
  $service_ensure      = 'running',
  $manage_service_file = true,
  $user                = 'zookeeper',
  $group               = 'zookeeper',
  $zoo_main            = 'org.apache.zookeeper.server.quorum.QuorumPeerMain',
  $log4j_prop          = 'INFO,ROLLINGFILE'
){
  require zookeeper::install

  if ($service_provider == 'systemd' and $manage_service_file == true) {
    file { '/usr/lib/systemd/system/zookeeper.service':
      ensure  => 'present',
      content => template('zookeeper/zookeeper.service.erb'),
    } ~>
    exec { 'systemctl daemon-reload # for zookeeper':
      refreshonly => true,
      path        => $::path,
      notify      => Service[$service_name]
    }
  } elsif ($service_provider == 'init' and $manage_service_file == true) {
    file {"/etc/init.d/${service_name}":
      ensure  => present,
      content => template('zookeeper/zookeeper.init.erb'),
      mode    => '0755',
      notify  => Service[$service_name]
    }
  }

  service { $service_name:
    ensure     => $service_ensure,
    hasstatus  => true,
    hasrestart => true,
    provider   => $service_provider,
    enable     => true,
    require    => [
      Class['zookeeper::install'],
      File["${cfg_dir}/zoo.cfg"]
    ]
  }
}
