# Class: zookeeper::sasl
#
# This module manages Zookeeper sasl auth
#
# Should not be included directly
#
class zookeeper::sasl(
  $use_keytab       = true,
  $cfg_dir          = '/etc/zookeeper/conf',
  $user             = $::zookeeper::params::user,
  $group            = $::zookeeper::params::group,
  $keytab_path      = '/etc/zookeeper/conf/zookeeper.keytab',
  $store_key        = true,
  $use_ticket_cache = false,
  $realm            = $::domain,
  $principal        = "zookeeper/${::fqdn}",
) inherits ::zookeeper::params {

  file{"${cfg_dir}/jaas.conf":
    ensure  => present,
    owner   => $user,
    group   => $group,
    content => template('zookeeper/conf/jaas.conf.erb'),
  }

  file{"${cfg_dir}/java.env":
    ensure  => present,
    owner   => $user,
    group   => $group,
    content => template('zookeeper/conf/java.env.erb'),
  }
}

