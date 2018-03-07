## 1.0.0 [UNRELEASED]
* Drop Puppet 3 support (still might work with `FUTURE_PARSER=true`)

## 0.7.7
- [Full diff](https://github.com/deric/puppet-zookeeper/compare/v0.7.6...v0.7.7)
- Drop testing on Ruby 1.9.3
- Include Puppet 5 in build matrix
- Fixes:
  - [Replace sh with bash in systemd unit](https://github.com/deric/puppet-zookeeper/pull/113) #113

## 0.7.6
- [Full diff](https://github.com/deric/puppet-zookeeper/compare/v0.7.5...v0.7.6)
- Fixes:
  - [zookeeper does not start under debian stretch](https://github.com/deric/puppet-zookeeper/issues/109) #109

## 0.7.5
- [Full diff](https://github.com/deric/puppet-zookeeper/compare/v0.7.4...v0.7.5)
- New features:
  - Support Debian 9
  - [Allow configuring log file size](https://github.com/deric/puppet-zookeeper/pull/105)
  - [Allow customizing systed path](https://github.com/deric/puppet-zookeeper/commit/96ae6ee6fd398249d9218c8b242ac39d950bdd9a)
- Fixes:
  - [Properly configure log dir](https://github.com/deric/puppet-zookeeper/issues/108) #108
  - [Fix systemd wants directive](https://github.com/deric/puppet-zookeeper/issues/103) #103
  - [replace all resource-style class with plain `include`](https://github.com/deric/puppet-zookeeper/pull/106)

## 0.7.4
- [Full diff](https://github.com/deric/puppet-zookeeper/compare/v0.7.3...v0.7.4)
- New features:
  - [Allow service restarts to be skipped on change](https://github.com/deric/puppet-zookeeper/pull/100) #100
  - [Provide option to remove host and realm from Kerberos principal](https://github.com/deric/puppet-zookeeper/pull/99)
- Fixes:
  - [systemd classpath overwritten](https://github.com/deric/puppet-zookeeper/issues/101) #102

## 0.7.3
- New features:
  - [Enable possibility of system users for zookeeper](https://github.com/deric/puppet-zookeeper/pull/98) #98

- Fixes:
  - [Make service run even if bin/zkEnv.sh does not exist](https://github.com/deric/puppet-zookeeper/pull/94) #94
  - [Ensure that `/etc/zookeeper` directory exists when installing from archive](https://github.com/deric/puppet-zookeeper/issues/96) #96
- [Full diff](https://github.com/deric/puppet-zookeeper/compare/v0.7.2...v0.7.3)

## 0.7.2
- New or changed features:
  - [Basic acceptance tests](https://github.com/deric/puppet-zookeeper/issues/90)
- Other changes and fixes:
  - [Service filename should be equal to the service name](https://github.com/deric/puppet-zookeeper/pull/91)
  - [Fix service settings when installing from archive](https://github.com/deric/puppet-zookeeper/pull/92)
- [Full diff](https://github.com/deric/puppet-zookeeper/compare/v0.7.1...v0.7.2)

## 0.7.1
* New or changed features:
  * [Exihibitor support](https://github.com/deric/puppet-zookeeper/pull/85)
* Other changes and fixes:
  * [Fixed duplicate java.env declaration when using SASL #89](https://github.com/deric/puppet-zookeeper/issues/89)
  * [Dependency cycle with archive install method #87](https://github.com/deric/puppet-zookeeper/issues/87)

## 0.7.0
* New or changed features:
    * Support installation from source package instead of binary package
    * Ability to install arbitrary versions of Zookeeper from source packages
* Other changes and fixes:
    * Remove deprecated parameters `service_package`, `start_with`, `manage_systemd`
    * Use correct value for parameter `zoo_dir` in `zookeeper::service`
    * Move all parameters to `params.pp` (and remove them from private classes)
    * Overall improvements to the code (style, simplification, deduplication)
* Compatibility warnings:
    * All classes except the main `zookeeper` class are private classes and should not be used directly
    * Fails when using removed parameters `service_package`, `start_with`, `manage_systemd`
