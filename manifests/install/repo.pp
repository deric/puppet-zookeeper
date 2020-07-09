# == Class zookeeper::install::repo
#
# This class manages yum repository for Zookeeper packages
#
# PRIVATE CLASS - do not use directly (use main `zookeeper` class).
class zookeeper::install::repo inherits zookeeper::install {
  if $facts['os']['family'] == 'RedHat' {
    $os_name = downcase($facts['os']['family'])
  } else {
    $os_name = downcase($facts['os']['name'])
  }
  $os_release = $facts['os']['release']['major']
  $os_hardware = $facts['os']['hardware']

  if $zookeeper::repo_source {
    case $zookeeper::repo_source {
      undef: {} # nothing to do
      'cloudera': {
        if $zookeeper::cdhver == undef {
          fail('Cloudera repo is required, but no CDH version is provided.')
        }
        case $zookeeper::cdhver {
          '4': {
            case $os_hardware {
              'i386', 'x86_64': {
                case $os_release {
                  '6', '7': {
                    $release = '6'
                  }
                  default: {
                    fail("Yum repository '${zookeeper::repo_source}' is not supported for ${os_name} version ${os_release}")
                  }
                }
              }
              default: {
                fail("Yum repository '${zookeeper::repo_source}' is not supported for architecture ${os_hardware}")
              }
            }
          }
          '5': {
            case $os_hardware {
              'x86_64': {
                case $os_release { # CentOS uses os_release=2015
                  '6', '7', '12', '2015': {
                    $release = $os_release
                  }
                  default: {
                    fail("Yum repository '${zookeeper::repo_source}' is not supported for ${os_name} version ${os_release}")
                  }
                }
              }
              default: {
                fail("Yum repository '${zookeeper::repo_source}' is not supported for architecture ${os_hardware}")
              }
            }
          }
          default: {
            fail("CDH version'${zookeeper::cdhver}' is not a supported cloudera repo.")
          }
        }
        # Puppet 4 compatibility: force variable to be a String
        yumrepo { "cloudera-cdh${zookeeper::cdhver}":
          ensure   => $zookeeper::ensure,
          descr    => "Cloudera's Distribution for Hadoop, Version ${zookeeper::cdhver}",
          baseurl  => "http://archive.cloudera.com/cdh${zookeeper::cdhver}/${os_name}/${release}/${os_hardware}/cdh/${zookeeper::cdhver}/",
          gpgkey   => "http://archive.cloudera.com/cdh${zookeeper::cdhver}/${os_name}/${release}/${os_hardware}/cdh/RPM-GPG-KEY-cloudera",
          gpgcheck => 1,
        }
      }
      'custom':{
        $_config = $zookeeper::repo
        validate_hash($_config)
        if $_config['name'] == undef or $_config['url'] == undef or $_config['descr'] == undef {
          fail('Invalid parameter settings for custom repo')
        }
        case $os_release {
          '6', '7', '12': {
            # Puppet 4 compatibility: force variable to be a String
            yumrepo { $_config['name']:
              ensure    => $zookeeper::ensure,
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
          default: {
            fail("${facts['os']['family']} '${os_release}' is not a supported.")
          }
        }
      }
      default: {
        fail("\"${module_name}\" provides no repository information for yum repository \"${zookeeper::repo_source}\"")
      }
    }
  }
}
