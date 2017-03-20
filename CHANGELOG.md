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
