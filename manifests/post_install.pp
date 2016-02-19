# Class: zookeeper::post_install
#
# In order to maintain compatibility with older releases, there are
# some post-install task to ensure same behaviour on all platforms.
#
# Should not be called directly
#
class zookeeper::post_install(
  $ensure,
  $ensure_account,
  $ensure_cron,
  $user,
  $group,
  $datastore,
  $snap_retain_count,
  $cleanup_sh,
  $manual_clean = undef,
){

  # make sure user and group exists for ZooKeeper #49, if the OS package
  # doesn't handle its creation
  if ($ensure_account){
    ensure_resource('group',
      [$group],
      {'ensure' => $ensure_account}
    )

    case $::osfamily {
      'Redhat': {
        $shell = '/sbin/nologin'
      }
      default: {
        # sane default for most OS
        $shell = '/bin/false'
      }
    }

    ensure_resource('user',
      [$user],
      {
        'ensure'  => $ensure_account,
        'home'    => $datastore,
        'comment' => 'Zookeeper',
        'gid'     => $group,
        'shell'   => $shell,
        'require' => Group[$group]
      }
    )
  }
  if ($manual_clean) {
    # user defined value
    $clean = $manual_clean
  } else {
    # autodetect
    # since ZooKeeper 3.4 there's no need for purging snapshots with cron
    case $::osfamily {
      'Debian': {
          case $::operatingsystem {
            'Debian': {
              case $::lsbdistcodename {
                'wheezy', 'squeeze': { # 3.3.5
                  $clean = true
                }
                default: { # future releases
                  $clean = false
                }
              }
            }
            'Ubuntu': {
              case $::lsbdistcodename {
                'precise': { # 3.3.5
                  $clean = true
                }
                default: {
                  $clean = false
                }
              }
            }
            default: {
              fail ("Family: '${::osfamily}' OS: '${::operatingsystem}' is not supported yet")
            }
          }
      }
      'Redhat': {
        $clean = false
      }
      default: {
        fail ("Family: '${::osfamily}' OS: '${::operatingsystem}' is not supported yet")
      }
    }
  }



  # if !$cleanup_count, then ensure this cron is absent.
  if ($clean and $snap_retain_count > 0 and $ensure != 'absent') {

    if ($ensure_cron){
      ensure_resource('package', 'cron', {
        ensure => 'installed',
      })

      cron { 'zookeeper-cleanup':
          ensure  => present,
          command => "${cleanup_sh} ${datastore} ${snap_retain_count}",
          hour    => 2,
          minute  => 42,
          user    => $user,
      }
    }else {
      file { '/etc/cron.daily/zkcleanup':
        ensure  => present,
        content =>  "${cleanup_sh} ${datastore} ${snap_retain_count}",
      }
    }
  }

  # package removal
  if($clean and $ensure == 'absent'){
    if ($ensure_cron){
      cron { 'zookeeper-cleanup':
        ensure  => $ensure,
      }
    }else{
      file { '/etc/cron.daily/zkcleanup':
        ensure  => $ensure,
      }
    }
  }
}