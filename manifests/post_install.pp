# Class: zookeeper::post_install
#
# In order to maintain compatibility with older releases, there are
# some post-install task to ensure same behaviour on all platforms.
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::post_install {

  if ($::zookeeper::manual_clean) {
    # User defined value
    $_clean = $::zookeeper::manual_clean
  } else {
    # Autodetect:
    # Since ZooKeeper 3.4 there's no need for purging snapshots with cron
    case $::osfamily {
      'Debian': {
          case $::operatingsystem {
            'Debian': {
              case $::lsbdistcodename {
                'wheezy', 'squeeze': { # 3.3.5
                  $_clean = true
                }
                default: { # future releases
                  $_clean = false
                }
              }
            }
            'Ubuntu': {
              case $::lsbdistcodename {
                'precise': { # 3.3.5
                  $_clean = true
                }
                default: {
                  $_clean = false
                }
              }
            }
            default: {
              fail ("Family: '${::osfamily}' OS: '${::operatingsystem}' is not supported yet")
            }
          }
      }
      'Redhat': {
        $_clean = false
      }
      default: {
        fail ("Family: '${::osfamily}' OS: '${::operatingsystem}' is not supported yet")
      }
    }
  }

  # If !$cleanup_count, then ensure this cron is absent.
  if ($_clean and $::zookeeper::snap_retain_count > 0 and $::zookeeper::ensure != 'absent') {

    if ($::zookeeper::ensure_cron){
      ensure_resource('package', 'cron', {
        ensure => 'installed',
      })

      cron { 'zookeeper-cleanup':
          ensure  => present,
          command => "${::zookeeper::cleanup_sh} ${::zookeeper::datastore} ${::zookeeper::snap_retain_count}",
          hour    => 2,
          minute  => 42,
          user    => $::zookeeper::user,
      }
    }else {
      file { '/etc/cron.daily/zkcleanup':
        ensure  => present,
        content =>  "${::zookeeper::cleanup_sh} ${::zookeeper::datastore} ${::zookeeper::snap_retain_count}",
      }
    }
  }

  # Package removal
  if($_clean and $::zookeeper::ensure == 'absent'){
    if ($::zookeeper::ensure_cron){
      cron { 'zookeeper-cleanup':
        ensure  => $::zookeeper::ensure,
      }
    }else{
      file { '/etc/cron.daily/zkcleanup':
        ensure  => $::zookeeper::ensure,
      }
    }
  }
}
