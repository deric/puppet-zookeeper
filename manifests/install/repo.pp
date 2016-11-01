# == Class zookeeper::install::repo
#
# This class manages yum repository for Zookeeper packages
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::install::repo {

  if $::zookeeper::repo_source {
    case $::zookeeper::repo_source {
      undef: {} # nothing to do
      'cloudera': {
        if $::zookeeper::cdhver == undef {
          fail('Cloudera repo is required, but no CDH version is provided.')
        }
        $osrel = $::operatingsystemmajrelease
        case $::zookeeper::cdhver {
          '4': {
            case $::hardwaremodel {
              'i386', 'x86_64': {
                case $osrel {
                  '6', '7': {
                    $release = '6'
                  }
                  default: {
                    fail("Yum repository '${::zookeeper::repo_source}' is not supported for redhat version ${osrel}")
                  }
                }
              }
              default: {
                fail("Yum repository '${::zookeeper::repo_source}' is not supported for architecture ${::hardwaremodel}")
              }
            }
          }
          '5': {
            case $::hardwaremodel {
              'x86_64': {
                case $osrel { # CentOS uses osrel=2015
                  '6', '7', '2015': {
                    $release = $osrel
                  }
                  default: {
                    fail("Yum repository '${::zookeeper::repo_source}' is not supported for redhat version ${osrel}")
                  }
                }
              }
              default: {
                fail("Yum repository '${::zookeeper::repo_source}' is not supported for architecture ${::hardwaremodel}")
              }
            }
          }
          default: {
            fail("CDH version'${::zookeeper::cdhver}' is not a supported cloudera repo.")
          }
        }
        # Parameter ensure is not supported before Puppet 3.5
        # Puppet 4 compatibility: force variable to be a String
        if versioncmp("${::puppetversion}", '3.5.0') >= 0 { # lint:ignore:only_variable_string
          yumrepo { "cloudera-cdh${::zookeeper::cdhver}":
            ensure   => $::zookeeper::ensure,
            descr    => "Cloudera's Distribution for Hadoop, Version ${::zookeeper::cdhver}",
            baseurl  => "http://archive.cloudera.com/cdh${::zookeeper::cdhver}/redhat/${release}/${::hardwaremodel}/cdh/${::zookeeper::cdhver}/",
            gpgkey   => "http://archive.cloudera.com/cdh${::zookeeper::cdhver}/redhat/${release}/${::hardwaremodel}/cdh/RPM-GPG-KEY-cloudera",
            gpgcheck => 1
          }
        } else {
          yumrepo { "cloudera-cdh${::zookeeper::cdhver}":
            descr    => "Cloudera's Distribution for Hadoop, Version ${::zookeeper::cdhver}",
            baseurl  => "http://archive.cloudera.com/cdh${::zookeeper::cdhver}/redhat/${osrel}/${::hardwaremodel}/cdh/${::zookeeper::cdhver}/",
            gpgkey   => "http://archive.cloudera.com/cdh${::zookeeper::cdhver}/redhat/${osrel}/${::hardwaremodel}/cdh/RPM-GPG-KEY-cloudera",
            gpgcheck => 1
          }
        }
      }
      'custom':{
        $_config = $::zookeeper::repo
        validate_hash($_config)
        if $_config['name'] == undef or $_config['url'] == undef or $_config['descr'] == undef {
          fail('Invalid parameter settings for custom repo')
        }
        $osrel = $::operatingsystemmajrelease
        case $osrel {
          '6', '7': {
            # Puppet 4 compatibility: force variable to be a String
            if versioncmp("${::puppetversion}", '3.0.0') < 0 { # lint:ignore:only_variable_string
              # parameter 'sslverify' is not supported before puppet 3.0
              yumrepo { $_config['name']:
                descr    => $_config['descr'],
                baseurl  => $_config['url'],
                enabled  => 1,
                gpgcheck => 0
              }
            # Puppet 4 compatibility: force variable to be a String
            } elsif versioncmp("${::puppetversion}", '3.5.0') >= 0 { # lint:ignore:only_variable_string
              # Parameter ensure is not supported before Puppet 3.5
              yumrepo { $_config['name']:
                ensure    => $::zookeeper::ensure,
                descr     => $_config['descr'],
                baseurl   => $_config['url'],
                enabled   => 1,
                sslverify => empty($_config['sslverify']) ? {
                  true  => 0,
                  false => $_config['sslverify']
                },
                gpgcheck  => empty($_config['gpgcheck']) ? {
                  true  => 0,
                  false => $_config['gpgcheck']
                },
              }
            } else {
              yumrepo { $_config['name']:
                descr     => $_config['descr'],
                baseurl   => $_config['url'],
                enabled   => 1,
                sslverify => empty($_config['sslverify']) ? {
                  true  => 0,
                  false => $_config['sslverify']
                },
                gpgcheck  => empty($_config['gpgcheck']) ? {
                  true  => 0,
                  false => $_config['gpgcheck']
                },
              }
            }
          }
          default: {
            fail("Redhat '${osrel}' is not a supported.")
          }
        }
      }
      default: {
        fail("\"${module_name}\" provides no repository information for yum repository \"${::zookeeper::repo_source}\"")
      }
    }
  }
}
