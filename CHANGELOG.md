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
