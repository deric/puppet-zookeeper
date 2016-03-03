#! /usr/bin/env ruby -S rspec
require 'spec_helper'
require 'rspec'
require 'rspec-puppet'

describe 'zookeeper_genid' do

  let(:port) { 2181 }

  describe 'convert ipaddress to unique ID in range 1-255' do
    it 'works with default strategy' do
      ip = '192.168.1.1'
      subject.should run.with_params(ip).and_return(249)
      ip = '192.168.1.2'
      subject.should run.with_params(ip).and_return(250)
    end

    it 'return valid ID' do
      ip = '10.0.0.'
      (1..10).to_a.each do |i|
        subject.should run.with_params("#{ip}#{i}").and_return(152+i)
      end
    end

    it 'should raise an error if run with extra arguments' do
      subject.should run.with_params(1, 2, 3, 4).and_raise_error(Puppet::ParseError)
      subject.should run.with_params('10.0.0.1', 2, 'mod', 4).and_raise_error(Puppet::ParseError)
    end

    it 'should raise an error if gets invalid ip address' do
      # version < 2.0.0
      if RUBY_VERSION.split('.')[0] == '1'
        subject.should run.with_params('10.0.0.256').and_raise_error(ArgumentError)
      else
        subject.should run.with_params('10.0.0.256').and_raise_error(IPAddr::InvalidAddressError)
      end
    end
  end

  describe 'last digit strategy' do
    strategy = 'last_digit'
    it 'return valid id' do
      ip = '192.168.1.1'
      subject.should run.with_params(ip, port, strategy).and_return(1)
    end

    it 'works with multiple digits' do
      ip = '192.168.1.126'
      subject.should run.with_params(ip, port, strategy).and_return(126)
    end
  end

  describe 'md5 strategy' do
    strategy = 'md5'
    it 'return valid id' do
      ip = '192.168.1.1'
      subject.should run.with_params(ip, port, strategy).and_return(37)
    end
  end

end
