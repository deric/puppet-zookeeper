# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`zookeeper`](#zookeeper)
* [`zookeeper::config`](#zookeeper--config): Class: zookeeper::config  This module manages the configuration directories  PRIVATE CLASS - do not use directly (use main `zookeeper` class)
* [`zookeeper::install`](#zookeeper--install): Class: zookeeper::install  This module manages installation tasks.
* [`zookeeper::install::archive`](#zookeeper--install--archive): Class: zookeeper::install::archive  This module manages archive installation  PRIVATE CLASS - do not use directly (use main `zookeeper` class
* [`zookeeper::install::package`](#zookeeper--install--package): Class: zookeeper::install::package  This module manages package installation  PRIVATE CLASS - do not use directly (use main `zookeeper` class
* [`zookeeper::install::repo`](#zookeeper--install--repo): == Class zookeeper::install::repo  This class manages yum repository for Zookeeper packages
* [`zookeeper::params`](#zookeeper--params): OS specific configuration should be defined here  PRIVATE CLASS - do not use directly (use main `zookeeper` class).
* [`zookeeper::post_install`](#zookeeper--post_install): Class: zookeeper::post_install  In order to maintain compatibility with older releases, there are some post-install task to ensure same behav
* [`zookeeper::sasl`](#zookeeper--sasl): Class: zookeeper::sasl  This module manages Zookeeper sasl auth  PRIVATE CLASS - do not use directly (use main `zookeeper` class).
* [`zookeeper::service`](#zookeeper--service): Class: zookeeper::service

## Classes

### <a name="zookeeper"></a>`zookeeper`

The zookeeper class.

#### Parameters

The following parameters are available in the `zookeeper` class:

* [`environment_file`](#-zookeeper--environment_file)
* [`log4j_prop`](#-zookeeper--log4j_prop)
* [`maxfilesize`](#-zookeeper--maxfilesize)
* [`maxbackupindex`](#-zookeeper--maxbackupindex)
* [`max_allowed_connections`](#-zookeeper--max_allowed_connections)
* [`peer_type`](#-zookeeper--peer_type)
* [`rollingfile_threshold`](#-zookeeper--rollingfile_threshold)
* [`tracefile_threshold`](#-zookeeper--tracefile_threshold)
* [`console_threshold`](#-zookeeper--console_threshold)
* [`extra_appenders`](#-zookeeper--extra_appenders)
* [`audit_threshold`](#-zookeeper--audit_threshold)
* [`audit_maxfilesize`](#-zookeeper--audit_maxfilesize)
* [`audit_maxbackupindex`](#-zookeeper--audit_maxbackupindex)
* [`logrotate_timebased`](#-zookeeper--logrotate_timebased)
* [`logrotate_days`](#-zookeeper--logrotate_days)
* [`sasl_users`](#-zookeeper--sasl_users)
* [`keytab_path`](#-zookeeper--keytab_path)
* [`principal`](#-zookeeper--principal)
* [`realm`](#-zookeeper--realm)
* [`sasl_krb5`](#-zookeeper--sasl_krb5)
* [`store_key`](#-zookeeper--store_key)
* [`use_keytab`](#-zookeeper--use_keytab)
* [`use_ticket_cache`](#-zookeeper--use_ticket_cache)
* [`remove_host_principal`](#-zookeeper--remove_host_principal)
* [`remove_realm_principal`](#-zookeeper--remove_realm_principal)
* [`whitelist_4lw`](#-zookeeper--whitelist_4lw)
* [`metrics_provider_classname`](#-zookeeper--metrics_provider_classname)
* [`metrics_provider_http_port`](#-zookeeper--metrics_provider_http_port)
* [`metrics_provider_export_jvm_info`](#-zookeeper--metrics_provider_export_jvm_info)
* [`ensure`](#-zookeeper--ensure)
* [`ensure_account`](#-zookeeper--ensure_account)
* [`ensure_cron`](#-zookeeper--ensure_cron)
* [`group`](#-zookeeper--group)
* [`system_group`](#-zookeeper--system_group)
* [`packages`](#-zookeeper--packages)
* [`shell`](#-zookeeper--shell)
* [`user`](#-zookeeper--user)
* [`system_user`](#-zookeeper--system_user)
* [`archive_checksum`](#-zookeeper--archive_checksum)
* [`archive_dl_site`](#-zookeeper--archive_dl_site)
* [`archive_dl_timeout`](#-zookeeper--archive_dl_timeout)
* [`archive_dl_url`](#-zookeeper--archive_dl_url)
* [`archive_install_dir`](#-zookeeper--archive_install_dir)
* [`archive_symlink`](#-zookeeper--archive_symlink)
* [`archive_symlink_name`](#-zookeeper--archive_symlink_name)
* [`archive_version`](#-zookeeper--archive_version)
* [`repo_user`](#-zookeeper--repo_user)
* [`repo_password`](#-zookeeper--repo_password)
* [`proxy_server`](#-zookeeper--proxy_server)
* [`proxy_type`](#-zookeeper--proxy_type)
* [`cdhver`](#-zookeeper--cdhver)
* [`install_java`](#-zookeeper--install_java)
* [`install_method`](#-zookeeper--install_method)
* [`java_bin`](#-zookeeper--java_bin)
* [`java_opts`](#-zookeeper--java_opts)
* [`java_package`](#-zookeeper--java_package)
* [`repo`](#-zookeeper--repo)
* [`manage_service`](#-zookeeper--manage_service)
* [`manage_service_file`](#-zookeeper--manage_service_file)
* [`pid_dir`](#-zookeeper--pid_dir)
* [`pid_file`](#-zookeeper--pid_file)
* [`restart_on_change`](#-zookeeper--restart_on_change)
* [`service_ensure`](#-zookeeper--service_ensure)
* [`service_name`](#-zookeeper--service_name)
* [`service_provider`](#-zookeeper--service_provider)
* [`systemd_unit_want`](#-zookeeper--systemd_unit_want)
* [`systemd_unit_after`](#-zookeeper--systemd_unit_after)
* [`systemd_path`](#-zookeeper--systemd_path)
* [`zk_dir`](#-zookeeper--zk_dir)
* [`cfg_dir`](#-zookeeper--cfg_dir)
* [`cleanup_sh`](#-zookeeper--cleanup_sh)
* [`client_ip`](#-zookeeper--client_ip)
* [`client_port`](#-zookeeper--client_port)
* [`secure_client_port`](#-zookeeper--secure_client_port)
* [`secure_port_only`](#-zookeeper--secure_port_only)
* [`ssl`](#-zookeeper--ssl)
* [`ssl_clientauth`](#-zookeeper--ssl_clientauth)
* [`keystore_location`](#-zookeeper--keystore_location)
* [`keystore_type`](#-zookeeper--keystore_type)
* [`keystore_password`](#-zookeeper--keystore_password)
* [`truststore_location`](#-zookeeper--truststore_location)
* [`truststore_type`](#-zookeeper--truststore_type)
* [`truststore_password`](#-zookeeper--truststore_password)
* [`ssl_hostname_verification`](#-zookeeper--ssl_hostname_verification)
* [`ssl_ciphersuites`](#-zookeeper--ssl_ciphersuites)
* [`ssl_protocol`](#-zookeeper--ssl_protocol)
* [`keystore_quorum_location`](#-zookeeper--keystore_quorum_location)
* [`keystore_quorum_type`](#-zookeeper--keystore_quorum_type)
* [`keystore_quorum_password`](#-zookeeper--keystore_quorum_password)
* [`truststore_quorum_location`](#-zookeeper--truststore_quorum_location)
* [`truststore_quorum_type`](#-zookeeper--truststore_quorum_type)
* [`truststore_quorum_password`](#-zookeeper--truststore_quorum_password)
* [`ssl_quorum_hostname_verification`](#-zookeeper--ssl_quorum_hostname_verification)
* [`ssl_quorum_ciphersuites`](#-zookeeper--ssl_quorum_ciphersuites)
* [`ssl_quorum_protocol`](#-zookeeper--ssl_quorum_protocol)
* [`ssl_quorum`](#-zookeeper--ssl_quorum)
* [`port_unification`](#-zookeeper--port_unification)
* [`datastore`](#-zookeeper--datastore)
* [`datalogstore`](#-zookeeper--datalogstore)
* [`election_port`](#-zookeeper--election_port)
* [`export_tag`](#-zookeeper--export_tag)
* [`id`](#-zookeeper--id)
* [`init_limit`](#-zookeeper--init_limit)
* [`initialize_datastore`](#-zookeeper--initialize_datastore)
* [`initialize_datastore_bin`](#-zookeeper--initialize_datastore_bin)
* [`leader`](#-zookeeper--leader)
* [`leader_port`](#-zookeeper--leader_port)
* [`log_dir`](#-zookeeper--log_dir)
* [`manual_clean`](#-zookeeper--manual_clean)
* [`max_session_timeout`](#-zookeeper--max_session_timeout)
* [`min_session_timeout`](#-zookeeper--min_session_timeout)
* [`observers`](#-zookeeper--observers)
* [`purge_interval`](#-zookeeper--purge_interval)
* [`servers`](#-zookeeper--servers)
* [`pre_alloc_size`](#-zookeeper--pre_alloc_size)
* [`snap_count`](#-zookeeper--snap_count)
* [`snap_retain_count`](#-zookeeper--snap_retain_count)
* [`sync_limit`](#-zookeeper--sync_limit)
* [`tick_time`](#-zookeeper--tick_time)
* [`global_outstanding_limit`](#-zookeeper--global_outstanding_limit)
* [`use_sasl_auth`](#-zookeeper--use_sasl_auth)
* [`zoo_dir`](#-zookeeper--zoo_dir)
* [`zoo_main`](#-zookeeper--zoo_main)
* [`quorum_listen_on_all_ips`](#-zookeeper--quorum_listen_on_all_ips)
* [`audit_enable`](#-zookeeper--audit_enable)

##### <a name="-zookeeper--environment_file"></a>`environment_file`

Data type: `String`



Default value: `$zookeeper::params::environment_file`

##### <a name="-zookeeper--log4j_prop"></a>`log4j_prop`

Data type: `String`



Default value: `$zookeeper::params::log4j_prop`

##### <a name="-zookeeper--maxfilesize"></a>`maxfilesize`

Data type: `String`



Default value: `$zookeeper::params::maxfilesize`

##### <a name="-zookeeper--maxbackupindex"></a>`maxbackupindex`

Data type: `Integer`



Default value: `$zookeeper::params::maxbackupindex`

##### <a name="-zookeeper--max_allowed_connections"></a>`max_allowed_connections`

Data type: `Optional[Integer]`



Default value: `$zookeeper::params::max_allowed_connections`

##### <a name="-zookeeper--peer_type"></a>`peer_type`

Data type: `String`



Default value: `$zookeeper::params::peer_type`

##### <a name="-zookeeper--rollingfile_threshold"></a>`rollingfile_threshold`

Data type: `String`



Default value: `$zookeeper::params::rollingfile_threshold`

##### <a name="-zookeeper--tracefile_threshold"></a>`tracefile_threshold`

Data type: `String`



Default value: `$zookeeper::params::tracefile_threshold`

##### <a name="-zookeeper--console_threshold"></a>`console_threshold`

Data type: `String`



Default value: `$zookeeper::params::console_threshold`

##### <a name="-zookeeper--extra_appenders"></a>`extra_appenders`

Data type: `Hash[String,Hash[String,String]]`



Default value: `$zookeeper::params::extra_appenders`

##### <a name="-zookeeper--audit_threshold"></a>`audit_threshold`

Data type: `String`



Default value: `$zookeeper::params::audit_threshold`

##### <a name="-zookeeper--audit_maxfilesize"></a>`audit_maxfilesize`

Data type: `String`



Default value: `$zookeeper::params::audit_maxfilesize`

##### <a name="-zookeeper--audit_maxbackupindex"></a>`audit_maxbackupindex`

Data type: `Variant[Integer,String]`



Default value: `$zookeeper::params::audit_maxbackupindex`

##### <a name="-zookeeper--logrotate_timebased"></a>`logrotate_timebased`

Data type: `Boolean`

logback TimeBasedRollingPolicy

Default value: `$zookeeper::params::logrotate_timebased`

##### <a name="-zookeeper--logrotate_days"></a>`logrotate_days`

Data type: `Integer`

max number of days kept, `logrotate_timebase` needs to be `true`

Default value: `$zookeeper::params::logrotate_days`

##### <a name="-zookeeper--sasl_users"></a>`sasl_users`

Data type: `Hash[String, String]`



Default value: `$zookeeper::params::sasl_users`

##### <a name="-zookeeper--keytab_path"></a>`keytab_path`

Data type: `String`



Default value: `$zookeeper::params::keytab_path`

##### <a name="-zookeeper--principal"></a>`principal`

Data type: `String`



Default value: `$zookeeper::params::principal`

##### <a name="-zookeeper--realm"></a>`realm`

Data type: `String`



Default value: `$zookeeper::params::realm`

##### <a name="-zookeeper--sasl_krb5"></a>`sasl_krb5`

Data type: `Boolean`



Default value: `$zookeeper::params::sasl_krb5`

##### <a name="-zookeeper--store_key"></a>`store_key`

Data type: `Boolean`



Default value: `$zookeeper::params::store_key`

##### <a name="-zookeeper--use_keytab"></a>`use_keytab`

Data type: `Boolean`



Default value: `$zookeeper::params::use_keytab`

##### <a name="-zookeeper--use_ticket_cache"></a>`use_ticket_cache`

Data type: `Boolean`



Default value: `$zookeeper::params::use_ticket_cache`

##### <a name="-zookeeper--remove_host_principal"></a>`remove_host_principal`

Data type: `Boolean`



Default value: `$zookeeper::params::remove_host_principal`

##### <a name="-zookeeper--remove_realm_principal"></a>`remove_realm_principal`

Data type: `Boolean`



Default value: `$zookeeper::params::remove_realm_principal`

##### <a name="-zookeeper--whitelist_4lw"></a>`whitelist_4lw`

Data type: `Array[String]`

Fine grained control over the set of commands ZooKeeper can execute

                whitelist_4lw = ['stat','ruok']

Default value: `$zookeeper::params::whitelist_4lw`

##### <a name="-zookeeper--metrics_provider_classname"></a>`metrics_provider_classname`

Data type: `Optional[String]`



Default value: `$zookeeper::params::metrics_provider_classname`

##### <a name="-zookeeper--metrics_provider_http_port"></a>`metrics_provider_http_port`

Data type: `Integer`



Default value: `$zookeeper::params::metrics_provider_http_port`

##### <a name="-zookeeper--metrics_provider_export_jvm_info"></a>`metrics_provider_export_jvm_info`

Data type: `Boolean`



Default value: `$zookeeper::params::metrics_provider_export_jvm_info`

##### <a name="-zookeeper--ensure"></a>`ensure`

Data type: `String`



Default value: `$zookeeper::params::ensure`

##### <a name="-zookeeper--ensure_account"></a>`ensure_account`

Data type: `Variant[Boolean,String]`



Default value: `$zookeeper::params::ensure_account`

##### <a name="-zookeeper--ensure_cron"></a>`ensure_cron`

Data type: `Boolean`



Default value: `$zookeeper::params::ensure_cron`

##### <a name="-zookeeper--group"></a>`group`

Data type: `String`



Default value: `$zookeeper::params::group`

##### <a name="-zookeeper--system_group"></a>`system_group`

Data type: `Boolean`



Default value: `$zookeeper::params::system_group`

##### <a name="-zookeeper--packages"></a>`packages`

Data type: `Array[String]`



Default value: `$zookeeper::params::packages`

##### <a name="-zookeeper--shell"></a>`shell`

Data type: `String`



Default value: `$zookeeper::params::shell`

##### <a name="-zookeeper--user"></a>`user`

Data type: `String`



Default value: `$zookeeper::params::user`

##### <a name="-zookeeper--system_user"></a>`system_user`

Data type: `Boolean`



Default value: `$zookeeper::params::system_user`

##### <a name="-zookeeper--archive_checksum"></a>`archive_checksum`

Data type: `Hash`



Default value: `$zookeeper::params::archive_checksum`

##### <a name="-zookeeper--archive_dl_site"></a>`archive_dl_site`

Data type: `Optional[String]`



Default value: `$zookeeper::params::archive_dl_site`

##### <a name="-zookeeper--archive_dl_timeout"></a>`archive_dl_timeout`

Data type: `Integer`



Default value: `$zookeeper::params::archive_dl_timeout`

##### <a name="-zookeeper--archive_dl_url"></a>`archive_dl_url`

Data type: `Optional[String]`



Default value: `$zookeeper::params::archive_dl_url`

##### <a name="-zookeeper--archive_install_dir"></a>`archive_install_dir`

Data type: `String`



Default value: `$zookeeper::params::archive_install_dir`

##### <a name="-zookeeper--archive_symlink"></a>`archive_symlink`

Data type: `Boolean`



Default value: `$zookeeper::params::archive_symlink`

##### <a name="-zookeeper--archive_symlink_name"></a>`archive_symlink_name`

Data type: `String`



Default value: `$zookeeper::params::archive_symlink_name`

##### <a name="-zookeeper--archive_version"></a>`archive_version`

Data type: `String`



Default value: `$zookeeper::params::archive_version`

##### <a name="-zookeeper--repo_user"></a>`repo_user`

Data type: `Optional[String]`



Default value: `$zookeeper::params::repo_user`

##### <a name="-zookeeper--repo_password"></a>`repo_password`

Data type: `Optional[String]`



Default value: `$zookeeper::params::repo_password`

##### <a name="-zookeeper--proxy_server"></a>`proxy_server`

Data type: `Optional[String]`



Default value: `$zookeeper::params::proxy_server`

##### <a name="-zookeeper--proxy_type"></a>`proxy_type`

Data type: `Optional[String]`



Default value: `$zookeeper::params::proxy_type`

##### <a name="-zookeeper--cdhver"></a>`cdhver`

Data type: `Optional[String]`



Default value: `$zookeeper::params::cdhver`

##### <a name="-zookeeper--install_java"></a>`install_java`

Data type: `Boolean`



Default value: `$zookeeper::params::install_java`

##### <a name="-zookeeper--install_method"></a>`install_method`

Data type: `String`



Default value: `$zookeeper::params::install_method`

##### <a name="-zookeeper--java_bin"></a>`java_bin`

Data type: `String`



Default value: `$zookeeper::params::java_bin`

##### <a name="-zookeeper--java_opts"></a>`java_opts`

Data type: `String`



Default value: `$zookeeper::params::java_opts`

##### <a name="-zookeeper--java_package"></a>`java_package`

Data type: `Optional[String]`



Default value: `$zookeeper::params::java_package`

##### <a name="-zookeeper--repo"></a>`repo`

Data type: `Optional[Hash]`



Default value: `$zookeeper::params::repo`

##### <a name="-zookeeper--manage_service"></a>`manage_service`

Data type: `Boolean`



Default value: `$zookeeper::params::manage_service`

##### <a name="-zookeeper--manage_service_file"></a>`manage_service_file`

Data type: `Boolean`



Default value: `$zookeeper::params::manage_service_file`

##### <a name="-zookeeper--pid_dir"></a>`pid_dir`

Data type: `String`



Default value: `$zookeeper::params::pid_dir`

##### <a name="-zookeeper--pid_file"></a>`pid_file`

Data type: `Optional[String]`



Default value: `$zookeeper::params::pid_file`

##### <a name="-zookeeper--restart_on_change"></a>`restart_on_change`

Data type: `Boolean`



Default value: `$zookeeper::params::restart_on_change`

##### <a name="-zookeeper--service_ensure"></a>`service_ensure`

Data type: `String`



Default value: `$zookeeper::params::service_ensure`

##### <a name="-zookeeper--service_name"></a>`service_name`

Data type: `String`



Default value: `$zookeeper::params::service_name`

##### <a name="-zookeeper--service_provider"></a>`service_provider`

Data type: `Optional[String]`



Default value: `$zookeeper::params::service_provider`

##### <a name="-zookeeper--systemd_unit_want"></a>`systemd_unit_want`

Data type: `Optional[String]`



Default value: `$zookeeper::params::systemd_unit_want`

##### <a name="-zookeeper--systemd_unit_after"></a>`systemd_unit_after`

Data type: `String`



Default value: `$zookeeper::params::systemd_unit_after`

##### <a name="-zookeeper--systemd_path"></a>`systemd_path`

Data type: `String`



Default value: `$zookeeper::params::systemd_path`

##### <a name="-zookeeper--zk_dir"></a>`zk_dir`

Data type: `String`



Default value: `$zookeeper::params::zk_dir`

##### <a name="-zookeeper--cfg_dir"></a>`cfg_dir`

Data type: `String`



Default value: `$zookeeper::params::cfg_dir`

##### <a name="-zookeeper--cleanup_sh"></a>`cleanup_sh`

Data type: `String`



Default value: `$zookeeper::params::cleanup_sh`

##### <a name="-zookeeper--client_ip"></a>`client_ip`

Data type: `Optional[String]`



Default value: `$zookeeper::params::client_ip`

##### <a name="-zookeeper--client_port"></a>`client_port`

Data type: `Integer`



Default value: `$zookeeper::params::client_port`

##### <a name="-zookeeper--secure_client_port"></a>`secure_client_port`

Data type: `Optional[Integer]`



Default value: `$zookeeper::params::secure_client_port`

##### <a name="-zookeeper--secure_port_only"></a>`secure_port_only`

Data type: `Optional[Boolean]`



Default value: `$zookeeper::params::secure_port_only`

##### <a name="-zookeeper--ssl"></a>`ssl`

Data type: `Optional[Boolean]`



Default value: `$zookeeper::params::ssl`

##### <a name="-zookeeper--ssl_clientauth"></a>`ssl_clientauth`

Data type: `Optional[String]`



Default value: `$zookeeper::params::ssl_clientauth`

##### <a name="-zookeeper--keystore_location"></a>`keystore_location`

Data type: `Optional[String]`



Default value: `$zookeeper::params::keystore_location`

##### <a name="-zookeeper--keystore_type"></a>`keystore_type`

Data type: `Optional[String]`



Default value: `$zookeeper::params::keystore_type`

##### <a name="-zookeeper--keystore_password"></a>`keystore_password`

Data type: `Optional[String]`



Default value: `$zookeeper::params::keystore_password`

##### <a name="-zookeeper--truststore_location"></a>`truststore_location`

Data type: `Optional[String]`



Default value: `$zookeeper::params::truststore_location`

##### <a name="-zookeeper--truststore_type"></a>`truststore_type`

Data type: `Optional[String]`



Default value: `$zookeeper::params::truststore_type`

##### <a name="-zookeeper--truststore_password"></a>`truststore_password`

Data type: `Optional[String]`



Default value: `$zookeeper::params::truststore_password`

##### <a name="-zookeeper--ssl_hostname_verification"></a>`ssl_hostname_verification`

Data type: `Optional[Boolean]`



Default value: `$zookeeper::params::ssl_hostname_verification`

##### <a name="-zookeeper--ssl_ciphersuites"></a>`ssl_ciphersuites`

Data type: `Optional[String]`



Default value: `$zookeeper::params::ssl_ciphersuites`

##### <a name="-zookeeper--ssl_protocol"></a>`ssl_protocol`

Data type: `Optional[String]`



Default value: `$zookeeper::params::ssl_protocol`

##### <a name="-zookeeper--keystore_quorum_location"></a>`keystore_quorum_location`

Data type: `Optional[String]`



Default value: `$zookeeper::params::keystore_quorum_location`

##### <a name="-zookeeper--keystore_quorum_type"></a>`keystore_quorum_type`

Data type: `Optional[String]`



Default value: `$zookeeper::params::keystore_quorum_type`

##### <a name="-zookeeper--keystore_quorum_password"></a>`keystore_quorum_password`

Data type: `Optional[String]`



Default value: `$zookeeper::params::keystore_quorum_password`

##### <a name="-zookeeper--truststore_quorum_location"></a>`truststore_quorum_location`

Data type: `Optional[String]`



Default value: `$zookeeper::params::truststore_quorum_location`

##### <a name="-zookeeper--truststore_quorum_type"></a>`truststore_quorum_type`

Data type: `Optional[String]`



Default value: `$zookeeper::params::truststore_quorum_type`

##### <a name="-zookeeper--truststore_quorum_password"></a>`truststore_quorum_password`

Data type: `Optional[String]`



Default value: `$zookeeper::params::truststore_quorum_password`

##### <a name="-zookeeper--ssl_quorum_hostname_verification"></a>`ssl_quorum_hostname_verification`

Data type: `Optional[Boolean]`



Default value: `$zookeeper::params::ssl_quorum_hostname_verification`

##### <a name="-zookeeper--ssl_quorum_ciphersuites"></a>`ssl_quorum_ciphersuites`

Data type: `Optional[String]`



Default value: `$zookeeper::params::ssl_quorum_ciphersuites`

##### <a name="-zookeeper--ssl_quorum_protocol"></a>`ssl_quorum_protocol`

Data type: `Optional[String]`



Default value: `$zookeeper::params::ssl_quorum_protocol`

##### <a name="-zookeeper--ssl_quorum"></a>`ssl_quorum`

Data type: `Optional[Boolean]`



Default value: `$zookeeper::params::ssl_quorum`

##### <a name="-zookeeper--port_unification"></a>`port_unification`

Data type: `Optional[Boolean]`



Default value: `$zookeeper::params::port_unification`

##### <a name="-zookeeper--datastore"></a>`datastore`

Data type: `String`



Default value: `$zookeeper::params::datastore`

##### <a name="-zookeeper--datalogstore"></a>`datalogstore`

Data type: `Optional[String]`



Default value: `$zookeeper::params::datalogstore`

##### <a name="-zookeeper--election_port"></a>`election_port`

Data type: `Integer`



Default value: `$zookeeper::params::election_port`

##### <a name="-zookeeper--export_tag"></a>`export_tag`

Data type: `String`



Default value: `$zookeeper::params::export_tag`

##### <a name="-zookeeper--id"></a>`id`

Data type: `String`



Default value: `$zookeeper::params::id`

##### <a name="-zookeeper--init_limit"></a>`init_limit`

Data type: `Integer`



Default value: `$zookeeper::params::init_limit`

##### <a name="-zookeeper--initialize_datastore"></a>`initialize_datastore`

Data type: `Boolean`



Default value: `$zookeeper::params::initialize_datastore`

##### <a name="-zookeeper--initialize_datastore_bin"></a>`initialize_datastore_bin`

Data type: `String`



Default value: `$zookeeper::params::initialize_datastore_bin`

##### <a name="-zookeeper--leader"></a>`leader`

Data type: `Boolean`



Default value: `$zookeeper::params::leader`

##### <a name="-zookeeper--leader_port"></a>`leader_port`

Data type: `Integer`



Default value: `$zookeeper::params::leader_port`

##### <a name="-zookeeper--log_dir"></a>`log_dir`

Data type: `String`



Default value: `$zookeeper::params::log_dir`

##### <a name="-zookeeper--manual_clean"></a>`manual_clean`

Data type: `Boolean`



Default value: `$zookeeper::params::manual_clean`

##### <a name="-zookeeper--max_session_timeout"></a>`max_session_timeout`

Data type: `Optional[Integer]`



Default value: `$zookeeper::params::max_session_timeout`

##### <a name="-zookeeper--min_session_timeout"></a>`min_session_timeout`

Data type: `Optional[Integer]`



Default value: `$zookeeper::params::min_session_timeout`

##### <a name="-zookeeper--observers"></a>`observers`

Data type: `Array[String]`



Default value: `$zookeeper::params::observers`

##### <a name="-zookeeper--purge_interval"></a>`purge_interval`

Data type: `Integer`



Default value: `$zookeeper::params::purge_interval`

##### <a name="-zookeeper--servers"></a>`servers`

Data type: `Variant[Array[String],Hash[String,String]]`



Default value: `$zookeeper::params::servers`

##### <a name="-zookeeper--pre_alloc_size"></a>`pre_alloc_size`

Data type: `Integer`



Default value: `$zookeeper::params::pre_alloc_size`

##### <a name="-zookeeper--snap_count"></a>`snap_count`

Data type: `Integer`



Default value: `$zookeeper::params::snap_count`

##### <a name="-zookeeper--snap_retain_count"></a>`snap_retain_count`

Data type: `Integer`



Default value: `$zookeeper::params::snap_retain_count`

##### <a name="-zookeeper--sync_limit"></a>`sync_limit`

Data type: `Integer`



Default value: `$zookeeper::params::sync_limit`

##### <a name="-zookeeper--tick_time"></a>`tick_time`

Data type: `Integer`



Default value: `$zookeeper::params::tick_time`

##### <a name="-zookeeper--global_outstanding_limit"></a>`global_outstanding_limit`

Data type: `Integer`



Default value: `$zookeeper::params::global_outstanding_limit`

##### <a name="-zookeeper--use_sasl_auth"></a>`use_sasl_auth`

Data type: `Boolean`



Default value: `$zookeeper::params::use_sasl_auth`

##### <a name="-zookeeper--zoo_dir"></a>`zoo_dir`

Data type: `String`



Default value: `$zookeeper::params::zoo_dir`

##### <a name="-zookeeper--zoo_main"></a>`zoo_main`

Data type: `String`



Default value: `$zookeeper::params::zoo_main`

##### <a name="-zookeeper--quorum_listen_on_all_ips"></a>`quorum_listen_on_all_ips`

Data type: `Boolean`



Default value: `$zookeeper::params::quorum_listen_on_all_ips`

##### <a name="-zookeeper--audit_enable"></a>`audit_enable`

Data type: `Boolean`



Default value: `$zookeeper::params::audit_enable`

### <a name="zookeeper--config"></a>`zookeeper::config`

Class: zookeeper::config

This module manages the configuration directories

PRIVATE CLASS - do not use directly (use main `zookeeper` class).

### <a name="zookeeper--install"></a>`zookeeper::install`

Class: zookeeper::install

This module manages installation tasks.

### <a name="zookeeper--install--archive"></a>`zookeeper::install::archive`

Class: zookeeper::install::archive

This module manages archive installation

PRIVATE CLASS - do not use directly (use main `zookeeper` class).

### <a name="zookeeper--install--package"></a>`zookeeper::install::package`

Class: zookeeper::install::package

This module manages package installation

PRIVATE CLASS - do not use directly (use main `zookeeper` class).

### <a name="zookeeper--install--repo"></a>`zookeeper::install::repo`

== Class zookeeper::install::repo

This class manages yum repository for Zookeeper packages

### <a name="zookeeper--params"></a>`zookeeper::params`

OS specific configuration should be defined here

PRIVATE CLASS - do not use directly (use main `zookeeper` class).

### <a name="zookeeper--post_install"></a>`zookeeper::post_install`

Class: zookeeper::post_install

In order to maintain compatibility with older releases, there are
some post-install task to ensure same behaviour on all platforms.

PRIVATE CLASS - do not use directly (use main `zookeeper` class).

### <a name="zookeeper--sasl"></a>`zookeeper::sasl`

Class: zookeeper::sasl

This module manages Zookeeper sasl auth

PRIVATE CLASS - do not use directly (use main `zookeeper` class).

### <a name="zookeeper--service"></a>`zookeeper::service`

Class: zookeeper::service

