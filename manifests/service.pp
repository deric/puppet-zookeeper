# Class: zookeeper::service
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::service inherits zookeeper {

  case $zookeeper::install_method {
    'archive': {
      $_zoo_dir = "${zookeeper::archive_install_dir}/${module_name}"
    }
    'package': {
      $_zoo_dir = $zookeeper::zoo_dir
    }
    default: {
      fail("Install method '${zookeeper::install_method}' is not supported.")
    }
  }

  if $zookeeper::manage_service_file == true {
    if $zookeeper::service_provider == 'systemd'  {
      file { "${zookeeper::systemd_path}/${zookeeper::service_name}.service":
        ensure  => 'present',
        content => template("${module_name}/zookeeper.service.erb"),
      }
      ~> exec { 'systemctl daemon-reload # for zookeeper':
        refreshonly => true,
        path        => $::path,
        notify      => Service[$zookeeper::service_name],
      }
    } elsif (
      $zookeeper::service_provider == 'init'
      or $zookeeper::service_provider == 'redhat'
    )  {
      file { "/etc/init.d/${zookeeper::service_name}":
        ensure  => present,
        content => template("${module_name}/zookeeper.${facts['os']['family']}.init.erb"),
        mode    => '0755',
        before  => Service[$zookeeper::service_name],
        notify  => Service[$zookeeper::service_name],
      }
    }
  }

  service { $zookeeper::service_name:
    ensure     => $zookeeper::service_ensure,
    hasstatus  => true,
    hasrestart => true,
    provider   => $zookeeper::service_provider,
    enable     => true,
    require    => [
      Class['::zookeeper::install'],
      File["${zookeeper::cfg_dir}/zoo.cfg"]
    ],
  }

  if $zookeeper::restart_on_change {
    File[$zookeeper::log_dir] ~> Service[$zookeeper::service_name]
    File["${zookeeper::cfg_dir}/myid"] ~> Service[$zookeeper::service_name]
    File["${zookeeper::cfg_dir}/zoo.cfg"] ~> Service[$zookeeper::service_name]
    File["${zookeeper::cfg_dir}/${zookeeper::environment_file}"] ~> Service[$zookeeper::service_name]
    File["${zookeeper::cfg_dir}/log4j.properties"] ~> Service[$zookeeper::service_name]
  }
}
