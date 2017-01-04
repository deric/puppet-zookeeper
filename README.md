#puppet-zookeeper

[![Puppet
Forge](http://img.shields.io/puppetforge/v/deric/zookeeper.svg)](https://forge.puppetlabs.com/deric/zookeeper) [![Build Status](https://travis-ci.org/deric/puppet-zookeeper.png?branch=master)](https://travis-ci.org/deric/puppet-zookeeper) [![Puppet Forge
Downloads](http://img.shields.io/puppetforge/dt/deric/zookeeper.svg)](https://forge.puppetlabs.com/deric/zookeeper/scores)

A puppet receipt for [Apache Zookeeper](http://zookeeper.apache.org/). ZooKeeper is a high-performance coordination service for maintaining configuration information, naming, providing distributed synchronization, and providing group services.

## Requirements

  * Puppet 3.x, Puppet 4.x
  * Ruby 1.9.3, 2.0.0, 2.1.x
  * Binary or source package of ZooKeeper

## Basic Usage:

```puppet
class { 'zookeeper': }
```

## Cluster setup

When running ZooKeeper in the distributed mode each node must have unique ID (`1-255`). The easiest way how to setup multiple ZooKeepers, is by using Hiera.

`hiera/host/zk1.example.com.yaml`:
```yaml
zookeeper::id: '1'
```
`hiera/host/zk2.example.com.yaml`:
```yaml
zookeeper::id: '2'
```
`hiera/host/zk3.example.com.yaml`:
```yaml
zookeeper::id: '3'
```
A ZooKeeper quorum should consist of odd number of nodes (usually `3` or `5`).
For defining a quorum it is enough to list all IP addresses of all its members.

```puppet
class { 'zookeeper':
  servers => {
    1 => '192.168.1.1',
    2 => '192.168.1.2',
    3 => '192.168.1.3',
  },
}
```
In case that an array is passed as `servers`, first ZooKeeper will be assigned `ID = 1`. This would produce following configuration:
```
server.1=192.168.1.1:2888:3888
server.2=192.168.1.2:2888:3888
server.3=192.168.1.3:2888:3888
```
where first port is `election_port` and second one `leader_port`. Both ports could be customized for each ZooKeeper instance.

```puppet
class { 'zookeeper':
  election_port => 2889,
  leader_port   => 3889,
  servers       => {
    1 => '192.168.1.1',
    2 => '192.168.1.2',
    3 => '192.168.1.3',
  }
}
```

### Observers

[Observers](http://zookeeper.apache.org/doc/r3.3.0/zookeeperObservers.html) were introduced in ZooKeeper 3.3.0. To enable this feature simply state which of ZooKeeper servers are observing:

```puppet
class { 'zookeeper':
  servers   => ['192.168.1.1', '192.168.1.2', '192.168.1.3', '192.168.1.4', '192.168.1.5'],
  observers => ['192.168.1.4', '192.168.1.5']
}
```
**Note**: Currently observer server needs to be listed between standard servers (this behavior might change in feature).

### Set binding interface

By default ZooKeeper should bind to all interfaces. When you specify `client_ip` only single interface
will be used. If `$::ipaddress` is not your public IP (e.g. you are using Docker) make sure to setup correct IP:

```puppet
class { 'zookeeper':
  client_ip => $::ipaddress_eth0
}
```

or in Hiera:

```yaml
zookeeper::client_ip: "%{::ipaddress_eth0}"
```

This is a workaround for a a [Facter issue](https://tickets.puppetlabs.com/browse/FACT-380).

### ZooKeeper service

Use `service_provider` to override Puppet detection for starting service.

```puppet
class { 'zookeeper':
  service_provider    => 'init',
  manage_service_file => false,
}
```

Some reasonable values are:

  * `init` - RHEL6, Debian 7
  * `upstart` - Ubuntu
  * `systemd` - RHEL 7, Debian 8
  * `runit`
  * `exhibitor` - zookeeper process and config will be managed by exhibitor (https://github.com/soabase/exhibitor). Exhibitor is not managed by this module.
  * `none` - service won't be installed

Parameter `manage_service_file` controls whether service definition should be managed by Puppet (default: `false`). Currently supported for `systemd` and `init`.


### Systemd Unit 'After' and 'Want' control
By default the module will create the following Unit section in /etc/systemd/system/multi-user.target.wants/zookeeper.service
````
[Unit]
Description=Apache ZooKeeper
After=network.target
````

Both After and Want (omitted when using the module defaults) can be controled using this module.

E.g on CentOS 7 those might have to be configured for 'netwrok-online.target' using the following syntax:

```puppet
class { 'zookeeper':
   systemd_unit_after => 'network-online.target',
   systemd_unit_want => 'network-online.target',
}
```

Which will modify the Unit section to look like:

````
[Unit]
Description=Apache ZooKeeper
Want=network-online.target
After=network-online.target
````

##  Parameters

   - `id` - cluster-unique zookeeper's instance id (1-255)
   - `datastore`
   - `datalogstore` - specifying this configures the `dataLogDir` ZooKeeper config values and allows for transaction logs to be stored in a different location, improving IO performance
   - `log_dir`
   - `purge_interval` - automatically will delete ZooKeeper logs (available since ZooKeeper 3.4.0)
   - `snap_retain_count` - number of snapshots that will be kept after purging (since ZooKeeper 3.4.0)
   - `min_session_timeout` - the minimum session timeout in milliseconds that the server will allow the client to negotiate. Defaults to 2 times the **tickTime** (since ZooKeeper 3.3.0)
   - `max_session_timeout` - the maximum session timeout in milliseconds that the server will allow the client to negotiate. Defaults to 20 times the **tickTime** (since ZooKeeper 3.3.0)
   - `manage_service` (default: `true`) whether Puppet should ensure running service
   - `manage_service_file` when enabled on RHEL 7.0 a systemd config will be managed
   - `ensure_account` controls whether `zookeeper` user and group will be ensured (set to `false` to disable this feature)
   - `install_method` controls whether ZooKeeper ist installed from binary (`package`) or source (`archive`) packages
   - `archive_version` allows to specify an arbitrary version of ZooKeeper when using source packages
   - `archive_install_dir` controls the installation directory when using source packages (defaults to `/opt`)
   - `archive_symlink` controls the name of a version-independent symlink when using source packages
   - `archive_dl_url` allows to change the download URL for source packages (defaults to apache.org)

and many others, see the `params.pp` file for more details.

If your distribution has multiple packages for ZooKeeper, you can provide all package names
as an array.

```puppet
class { 'zookeeper':
  packages => ['zookeeper', 'zookeeper-java']
}
```
## Logging

ZooKeeper uses log4j, following variables can be configured:

```puppet
class { 'zookeeper':
  console_threshold     => 'INFO',
  rollingfile_threshold => 'INFO',
  tracefile_threshold   => 'TRACE',
}
```
supported values are: `ALL`, `DEBUG`, `ERROR`, `FATAL`, `INFO`, `OFF`, `TRACE` and `WARN`.

## Hiera Support

All parameters could be defined in hiera files, e.g. `common.yaml`, `Debian.yaml` or `zookeeper.yaml`:

```yaml
zookeeper::id: 1
zookeeper::client_port: 2181
zookeeper::datastore: '/var/lib/zookeeper'
zookeeper::datalogstore: '/disk2/zookeeper'
```

## Cloudera package

In Cloudera distribution ZooKeeper package does not provide init scripts (same as in Debian). Package containing init scripts
is called `zookeeper-server` and the service as well. Moreover there's initialization script which should be called after installation.
So, the configuration might look like this:

```puppet
class { 'zookeeper':
  packages             => ['zookeeper', 'zookeeper-server'],
  service_name         => 'zookeeper-server',
  initialize_datastore => true
}
```

### Managing repository

For RedHat family currently we support also managing a `cloudera` yum repo versions 4, and 5. It can be enabled with `repo` parameter:

```puppet
class { 'zookeeper':
  repo   => 'cloudera',
  cdhver => '5',
}
```

#### Custom RPM repository

Optionally you can specify a custom repository, using a hash configuration.

```puppet
class { 'zookeeper':
  cdhver     => '5',
  repo       =>  {
    name  => 'myrepo',
    url   => 'http://cusom.url',
    descr => 'description'
  }
}
```

## Source package

Source packages provide the ability to install arbitrary versions of ZooKeeper on any platform. Note that you'll likely have to use the `manage_service_file` in order to be able to control the ZooKeeper service (because source packages do not install service files).

```puppet
class { 'zookeeper':
  install_method  => 'archive',
  archive_version => '3.4.8',
}
```

## Java installation

Default: `false`

By changing these two parameters you can ensure, that given Java package will be installed before ZooKeeper packages.

```puppet
class { 'zookeeper':
  install_java => true,
  java_package => 'openjdk-7-jre-headless'
}
```

## Install

### Librarian (recommended)

For [puppet-librarian](https://github.com/rodjek/librarian-puppet) just add to `Puppetfile`

from Forge:
```ruby
mod 'deric-zookeeper'
```

latest (development) version from GitHub
```ruby
mod 'deric-zookeeper', git: 'git://github.com/deric/puppet-zookeeper.git'
```

### submodules

If you are versioning your puppet conf with git just add it as submodule, from your repository root:

    git submodule add git://github.com/deric/puppet-zookeeper.git modules/zookeeper

## Dependencies

  * stdlib `> 2.3.3` - function `ensure_resources` is required
  * puppet-archive `> 0.4.4` - provides capabilities to use archives instead of binary packages

## Supported platforms

  * Debian/Ubuntu
    * Debian 6 Squeeze: you can get ZooKeeper package from [Wheezy](http://packages.debian.org/wheezy/zookeeper) or [Sid](http://packages.debian.org/sid/zookeeper) repo.
    * Debian 7 Wheezy: available in apt repository
  * RedHat/CentOS/Fedora

### Tested on:

  * Debian 6 - Squeeze, 7 - Wheezy, 8 - Jessie
  * Ubuntu 12.04.03 LTS, 14.04
  * RHEL 6, RHEL 7, CentOS 6
