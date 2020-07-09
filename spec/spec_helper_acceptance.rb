require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'] =~ %r{pe}i
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
  hosts.each do |host|
    if fact_on(host, 'osfamily') == 'Debian'
      on host, puppet('resource', 'package', 'net-tools', 'ensure=installed')
      on host, puppet('resource', 'package', 'netcat', 'ensure=installed')
    end
    if fact_on(host, 'osfamily') == 'RedHat'
      case fact('os.release.major')
      when '6'
        on host, puppet('resource', 'package', 'nc', 'ensure=installed')
      when '7'
        on host, puppet('resource', 'package', 'net-tools', 'ensure=installed')
        on host, puppet('resource', 'package', 'nmap-ncat', 'ensure=installed')
      end
    end
    if fact_on(host, 'osfamily') == 'Suse'
      on host, puppet('resource', 'package', 'net-tools', 'ensure=installed')
      on host, puppet('resource', 'package', 'netcat-openbsd', 'ensure=installed')
    end
    if host[:platform] =~ %r{el-7-x86_64} && host[:hypervisor] =~ %r{docker}
      on(host, "sed -i '/nodocs/d' /etc/yum.conf")
    end
  end
end
