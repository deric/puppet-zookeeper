require 'ipaddr'
require 'digest'
#
# ZooKeeper unique ID generator - generates ID for given IP address
#

module Puppet::Parser::Functions
  newfunction(:zookeeper_genid, :type => :rvalue, :doc => <<-EOS
This function generates ZooKeeper ID (1-255) for given IP address

        EOS
  ) do |args|

    # Arguments: [ipaddress], [strategy]

    if !args[0].nil? && args[0].class != String
      raise(Puppet::ParseError, "zookeeper_genid() expects an ipaddress, you've given: '" + args[0].class.to_s + "'")
    end

    # use default ipaddress fact, if no ip given
    if args[0].nil? || args[0].empty?
      ipaddress = lookupvar('ipaddress')
    else
      ipaddress = IPAddr.new(args[0])
    end
    strategy = args[1] if args.size > 1
    strategy ||= 'mod'

    id = 1
    case strategy
    when 'last_digit'
      ip = ipaddress.to_s
      idx = ip.rindex('.')
      return ip[idx+1..-1].to_i
    when 'mod'
      # make sure we stay in range 1-255, e.g.: '192.168.1.149' -> 0 + 1
      return (ipaddress.to_i % 255) + 1
    when 'md5'
      return Digest::MD5.hexdigest('192.168.1.1').to_s.hex % 255 + 1
    else
      raise(Puppet::ParseError, "zookeeper_genid() unknown strategy " + strategy)
    end
  end
end