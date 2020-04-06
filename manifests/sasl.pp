# Class: zookeeper::sasl
#
# This module manages Zookeeper sasl auth
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::sasl inherits zookeeper {
  file{"${zookeeper::cfg_dir}/jaas.conf":
    ensure  => present,
    owner   => $zookeeper::user,
    group   => $zookeeper::group,
    content => template("${module_name}/conf/jaas.conf.erb"),
  }
}
