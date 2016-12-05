# OS specific configuration should be defined here
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::params {
  $_defaults = {
    'packages' => ['zookeeper']
  }

  case $::osfamily {
    'Debian': {
      case $::operatingsystem {
        'Debian': {
          case $::operatingsystemmajrelease {
            '7': { $initstyle = 'init' }
            '8': { $initstyle = 'systemd' }
            default: { $initstyle = undef }
          }
        }
        'Ubuntu': {
          case $::operatingsystemmajrelease {
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
        'shell'            => '/bin/false',
      }
      # 'environment' file probably read just by Debian
      # see #16, #81
      $environment_file = 'environment'
    }
    'RedHat': {
      case $::operatingsystemmajrelease {
        '6': { $initstyle = 'redhat' }
        '7': { $initstyle = 'systemd' }
        default: { $initstyle = undef }
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
      fail("Module '${module_name}' is not supported on OS: '${::operatingsystem}', family: '${::osfamily}'")
    }
  }
  $_params = merge($_defaults, $_os_overrides)

  # meta options
  $ensure = present
  $ensure_account = present
  $ensure_cron = true
  $group = 'zookeeper'
  $packages = $_params['packages']
  $shell = $_params['shell']
  $user = 'zookeeper'

  # installation options
  $archive_checksum = {}
  $archive_dl_site = 'http://apache.org/dist/zookeeper'
  $archive_dl_timeout = 600
  $archive_dl_url = undef
  $archive_install_dir = '/opt'
  $archive_symlink = true
  $archive_symlink_name = "${archive_install_dir}/zookeeper"
  $archive_version = '3.4.8'
  $cdhver = undef
  $install_java = false
  $install_method = 'package'
  $java_bin = '/usr/bin/java'
  $java_opts = ''
  $java_package = undef
  $repo = undef

  # service options
  $manage_service = true
  $manage_service_file = false
  $pid_dir = '/var/run'
  $pid_file = undef
  $service_ensure = 'running'
  $service_name = $_params['service_name']
  $service_provider = $_params['service_provider']
  # systemd_unit_want and _after can be overridden to
  # donate the matching directives in the [Unit] section
  $systemd_unit_want = undef
  $systemd_unit_after = 'network.target'

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
  $use_sasl_auth = false
  $zoo_dir = '/usr/lib/zookeeper'
  $zoo_main = 'org.apache.zookeeper.server.quorum.QuorumPeerMain'

  # log4j properties
  $log4j_prop = 'INFO,ROLLINGFILE'
  $peer_type = 'UNSET'
  $rollingfile_threshold = 'INFO'
  $console_threshold = 'INFO'
  $tracefile_threshold = 'TRACE'

  # sasl options
  $keytab_path = '/etc/zookeeper/conf/zookeeper.keytab'
  $principal = "zookeeper/${::fqdn}"
  $realm = $::domain
  $store_key = true
  $use_keytab = true
  $use_ticket_cache = false
}
