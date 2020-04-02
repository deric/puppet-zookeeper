# OS specific configuration should be defined here
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::params {
  $_defaults = {
    'packages' => ['zookeeper'],
  }

  $os_family = $facts['os']['family']
  $os_name = $facts['os']['name']
  $os_release = $facts['os']['release']['major']

  case $os_family {
    'Debian': {
      case $os_name {
        'Debian', 'Ubuntu': {
          $initstyle = 'systemd'
        }
        default: { $initstyle = undef }
      }

      $_os_overrides = {
        'packages'         => ['zookeeper', 'zookeeperd'],
        'service_name'     => 'zookeeper',
        'service_provider' => $initstyle,
        'shell'            => '/bin/false',
      }
      # 'environment' file probably read just by Debian
      # see #16, #81
      $environment_file = 'environment'
    }
    'RedHat': {
      case $os_name {
        'RedHat', 'CentOS': {
          if versioncmp($os_release, '7') < 0 {
            $initstyle = 'redhat'
          } else {
            $initstyle = 'systemd'
          }
        }
        default: {
          $initstyle = undef
        }
      }

      $_os_overrides = {
        'packages'         => ['zookeeper', 'zookeeper-server'],
        'service_name'     => 'zookeeper-server',
        'service_provider' => $initstyle,
        'shell'            => '/sbin/nologin',
      }
      $environment_file = 'java.env'
    }

    default: {
      fail("Module '${module_name}' is not supported on OS: '${os_name}', family: '${os_family}'")
    }
  }
  $_params = merge($_defaults, $_os_overrides)

  # meta options
  $ensure = present
  $ensure_account = present
  $ensure_cron = true
  $group = 'zookeeper'
  $system_group = false
  $packages = $_params['packages']
  $shell = $_params['shell']
  $user = 'zookeeper'
  $system_user = false

  # installation options
  $archive_checksum = {}
  $archive_dl_site = undef
  $archive_dl_timeout = 600
  $archive_dl_url = undef
  $archive_install_dir = '/opt'
  $archive_symlink = true
  $archive_symlink_name = "${archive_install_dir}/zookeeper"
  $archive_version = '3.4.8'
  $cdhver = '5'
  $install_java = false
  $install_method = 'package'
  $java_bin = '/usr/bin/java'
  $java_opts = ''
  $java_package = undef
  $repo = 'cloudera'
  $proxy_server = undef
  $proxy_type = undef

  # service options
  $manage_service = true
  $manage_service_file = false
  $pid_dir = '/var/run'
  $pid_file = undef
  $restart_on_change = true
  $service_ensure = 'running'
  $service_name = $_params['service_name']
  $service_provider = $_params['service_provider']
  # systemd_unit_want and _after can be overridden to
  # donate the matching directives in the [Unit] section
  $systemd_unit_want = undef
  $systemd_unit_after = 'network.target'
  $systemd_path = '/etc/systemd/system'

  $zk_dir = '/etc/zookeeper'
  # zookeeper config
  $cfg_dir = '/etc/zookeeper/conf'
  $cleanup_sh = '/usr/share/zookeeper/bin/zkCleanup.sh'
  $client_ip = undef # use e.g. $::ipaddress if you want to bind to single interface
  $client_port = 2181
  $datastore = '/var/lib/zookeeper'
  # datalogstore used to put transaction logs in separate location than snapshots
  $datalogstore = undef
  $election_port = 2888
  $export_tag = 'zookeeper'
  $id = '1'
  $init_limit = 10
  $initialize_datastore = false
  $leader = true
  $leader_port = 3888
  $log_dir = '/var/log/zookeeper'
  $manual_clean = false
  $max_allowed_connections = undef
  $max_session_timeout = undef
  $min_session_timeout = undef
  $observers = []
  # interval in hours, purging enabled when >= 1
  $purge_interval = 0
  $servers = []
  $snap_count = 10000
  # since zookeeper 3.4, for earlier version cron task might be used
  $snap_retain_count = 3
  $sync_limit = 5
  $tick_time = 2000
  $global_outstanding_limit = 1000
  $use_sasl_auth = false
  $zoo_dir = '/usr/lib/zookeeper'
  $zoo_main = 'org.apache.zookeeper.server.quorum.QuorumPeerMain'

  # log4j properties
  $log4j_prop = 'INFO,ROLLINGFILE'
  $peer_type = 'UNSET'
  $rollingfile_threshold = 'INFO'
  $console_threshold = 'INFO'
  $tracefile_threshold = 'TRACE'
  $maxfilesize = '256MB'
  $maxbackupindex = 20
  $extra_appenders = {}

  # sasl options
  $sasl_krb5 = true
  $sasl_users = {}
  $keytab_path = '/etc/zookeeper/conf/zookeeper.keytab'
  $principal = "zookeeper/${facts['networking']['fqdn']}"
  $realm = pick($trusted['domain'], $trusted['certname'])
  $store_key = true
  $use_keytab = true
  $use_ticket_cache = false
  $remove_host_principal = false
  $remove_realm_principal = false
  # whitelist of Four Letter Words commands, see https://zookeeper.apache.org/doc/r3.4.12/zookeeperAdmin.html#sc_zkCommands
  $whitelist_4lw = []
}
