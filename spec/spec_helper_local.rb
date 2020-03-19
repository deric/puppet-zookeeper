def get_os_info(facts)
  info = {
    :service_name => nil,
    :environment_file => nil,
    :should_install_zookeeperd => nil,
    :init_provider => nil,
    :init_dir => nil,
    :service_file => nil,
    :should_install_cron => false,
    :zookeeper_shell => nil,
  }

  case facts[:osfamily]
  when 'Debian'
    info[:service_name] = 'zookeeper'
    info[:environment_file] = '/etc/zookeeper/conf/environment'
    info[:should_install_zookeeperd] = true
    info[:zookeeper_shell] = '/bin/false'

    case facts[:os]['name']
    when 'Debian'
      if Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '8') < 0
        info[:init_provider] = 'init'
        info[:should_install_cron] = true
      else
        info[:init_provider] = 'systemd'
      end
    when 'Ubuntu'
      if Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '15.04') < 0
        info[:init_provider] = 'upstart'
      else
        info[:init_provider] = 'systemd'
      end

      if Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '12.04') < 0
        info[:should_install_cron] = true
      end
    end
  when 'RedHat'
    info[:service_name] = 'zookeeper-server'
    info[:environment_file] = '/etc/zookeeper/conf/java.env'
    info[:should_install_zookeeperd] = false
    info[:zookeeper_shell] = '/sbin/nologin'

    case facts[:os]['name']
    when 'RedHat'
      if Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '7') < 0
        info[:init_provider] = 'redhat'
      else
        info[:init_provider] = 'systemd'
      end
    when 'CentOS'
      if Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '7') < 0
        info[:init_provider] = 'redhat'
      else
        info[:init_provider] = 'systemd'
      end
    end
  end

  case info[:init_provider]
  when 'init'
    info[:init_dir] = '/etc/init.d'
  when 'systemd'
    info[:init_dir] = '/etc/systemd/system'
  when 'upstart'
    info[:init_dir] = '/etc/init'
  when 'redhat'
    info[:init_dir] = '/etc/init.d'
  end

  if info[:init_provider] == 'systemd'
    info[:service_file] = "#{info[:init_dir]}/#{info[:service_name]}.service"
  else
    info[:service_file] = "#{info[:init_dir]}/#{info[:service_name]}"
  end

  return info
end
