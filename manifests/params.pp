
class zookeeper::params{
  $cdhver                  = undef
  $cfg_dir                 = '/etc/zookeeper/conf'
  $cleanup_sh              = '/usr/lib/zookeeper/bin/zkCleanup.sh'
  # fact from which we get public ip address
  $client_ip               = undef # use e.g. $::ipaddress if you want to bind to single interface
  $client_port             = 2181
  # datalogstore used to put transaction logs in separate location than snapshots
  $datalogstore            = undef
  $datastore               = '/var/lib/zookeeper'
  $election_port           = 2888
  $ensure                  = present
  $ensure_cron             = true
  $export_tag               = 'zookeeper'
  $group                   = 'zookeeper'
  $id                      = '1'
  $init_limit               = 10
  $initialize_datastore    = false
  $install_java            = false
  $java_bin                = '/usr/bin/java'
  $java_opts               = ''
  $java_package            = undef
  $leader                   = true
  $leader_port             = 3888
  $log_dir                 = '/var/log/zookeeper'
  $log4j_prop              = 'INFOROLLINGFILE'
  $manage_service          = true
  $manage_systemd          = true
  $manual_clean             = false
  $max_allowed_connections = undef
  $max_session_timeout     = undef
  $min_session_timeout     = undef
  $observers               = []
  $packages                = ['zookeeper']
  $peer_type               = 'UNSET'
  $pid_dir                 = '/var/run/zookeeper'
  $pid_file                = '$PIDDIR/zookeeper.pid'
  # interval in hours purging enabled when >= 1
  $purge_interval          = 0
  $repo                    = undef
  $repo_source              = ''
  $rollingfile_threshold   = 'ERROR'
  $servers                 = []
  $service_ensure           = 'running'
  $service_name            = 'zookeeper'
  $service_package         = 'zookeeperd'
  $snap_count              = 10000
  # since zookeeper 3.4 for earlier version cron task might be used
  $snap_retain_count       = 3
  $start_with              = 'init.d'
  $sync_limit               = 5
  $tick_limit               = 2000
  $tick_time                = 10
  $tracefile_threshold     = 'TRACE'
  $user                    = 'zookeeper'
  $zoo_main                = 'org.apache.zookeeper.server.quorum.QuorumPeerMain'
}
