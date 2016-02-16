# == Class zookeeper::repo
#
# This class manages yum repository for Zookeeper packages
#

class zookeeper::repo(
  $source     = undef,
  $cdhver     = undef,
  $ensure     = present,
  $config     = undef,
) {

  if $source {
    case $::osfamily {
      'redhat': {
        case $source {
          undef: {} #nothing to do
          'cloudera': {
            if $cdhver == undef {
              fail('Cloudera repo is required, but no CDH version is provider.')
            }
            $osrel = $::operatingsystemmajrelease
            case $cdhver {
              '4': {
                case $::hardwaremodel {
                  'i386', 'x86_64': {
                    case $osrel {
                      '6', '7': {
                        $release = '6'
                      }
                      default: {
                        fail("Yum repository '${source}' is not supported for redhat version ${osrel}")
                      }
                    }
                  }
                  default: {
                    fail("Yum repository '${source}' is not supported for architecture ${::hardwaremodel}")
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
                        fail("Yum repository '${source}' is not supported for redhat version ${osrel}")
                      }
                    }
                  }
                  default: {
                    fail("Yum repository '${source}' is not supported for architecture ${::hardwaremodel}")
                  }
                }
              }
              default: {
                fail("CDH version'${cdhver}' is not a supported cloudera repo.")
              }
            }
            # parameter ensure is not supported before Puppet 3.5
            # Puppet 4 compatibility: force variable to be a String
            if versioncmp("${::puppetversion}", '3.5.0') >= 0 { # lint:ignore:only_variable_string
              yumrepo { "cloudera-cdh${cdhver}":
                ensure   => $ensure,
                descr    => "Cloudera's Distribution for Hadoop, Version ${cdhver}",
                baseurl  => "http://archive.cloudera.com/cdh${cdhver}/redhat/${release}/${::hardwaremodel}/cdh/${cdhver}/",
                gpgkey   => "http://archive.cloudera.com/cdh${cdhver}/redhat/${release}/${::hardwaremodel}/cdh/RPM-GPG-KEY-cloudera",
                gpgcheck => 1
              }
            } else {
              yumrepo { "cloudera-cdh${cdhver}":
                descr    => "Cloudera's Distribution for Hadoop, Version ${cdhver}",
                baseurl  => "http://archive.cloudera.com/cdh${cdhver}/redhat/${osrel}/${::hardwaremodel}/cdh/${cdhver}/",
                gpgkey   => "http://archive.cloudera.com/cdh${cdhver}/redhat/${osrel}/${::hardwaremodel}/cdh/RPM-GPG-KEY-cloudera",
                gpgcheck => 1
              }
            }
          }
          'custom':{
            validate_hash($config)
            if $config['name'] == undef or $config['url'] == undef or $config['descr'] == undef {
              fail('Invalid parameter settings for custom repo')
            }
            $osrel = $::operatingsystemmajrelease
            case $osrel {
              '6', '7': {
                # Puppet 4 compatibility: force variable to be a String
                if versioncmp("${::puppetversion}", '3.0.0') < 0 { # lint:ignore:only_variable_string
                  # parameter 'sslverify' is not supported before puppet 3.0
                  yumrepo { $config['name']:
                    descr    => $config['descr'],
                    baseurl  => $config['url'],
                    enabled  => 1,
                    gpgcheck => 0
                  }
                # Puppet 4 compatibility: force variable to be a String
                } elsif versioncmp("${::puppetversion}", '3.5.0') >= 0 { # lint:ignore:only_variable_string
                  # parameter ensure is not supported before Puppet 3.5
                  yumrepo { $config['name']:
                    ensure    => $ensure,
                    descr     => $config['descr'],
                    baseurl   => $config['url'],
                    enabled   => 1,
                    sslverify => empty($config['sslverify']) ? {
                      true  => 0,
                      false => $config['sslverify']
                    },
                    gpgcheck  => empty($config['gpgcheck']) ? {
                      true  => 0,
                      false => $config['gpgcheck']
                    },
                  }
                } else {
                  yumrepo { $config['name']:
                    descr     => $config['descr'],
                    baseurl   => $config['url'],
                    enabled   => 1,
                    sslverify => empty($config['sslverify']) ? {
                      true  => 0,
                      false => $config['sslverify']
                    },
                    gpgcheck  => empty($config['gpgcheck']) ? {
                      true  => 0,
                      false => $config['gpgcheck']
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
            fail("\"${module_name}\" provides no repository information for yum repository \"${source}\"")
          }
        }
      }
      default: {
        fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
      }
    }
  }
}
