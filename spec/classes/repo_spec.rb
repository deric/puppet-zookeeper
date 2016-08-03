require 'spec_helper'

describe 'zookeeper::repo', :type => :class do
  shared_examples 'redhat-install' do |os, codename, puppet|
    let(:hardwaremodel){ 'x86_64' }

    let(:facts) do
      {
      :operatingsystem => os,
      :osfamily => 'RedHat',
      :lsbdistcodename => codename,
      :operatingsystemrelease => codename,
      :operatingsystemmajrelease => codename,
      :hardwaremodel => hardwaremodel,
      :puppetversion => puppet,
    }
    end
  end

  context 'on RedHat-like system' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    let(:params) do
      {
      :source => 'cloudera',
      :cdhver => '5'
    }
    end
    # ENV variable might contain characters which are not supported
    # by versioncmp function (like '~>')

    it_behaves_like 'redhat-install', 'RedHat', '7', Puppet.version
  end

  context 'fail when architecture not supported' do
    let(:facts) do
      {
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :hardwaremodel => 'arc',
    }
    end

    let(:params) do
      {
      :source => 'cloudera',
      :cdhver => '5',
    }
    end

    it do
      expect do
        is_expected.to compile
    end.to raise_error(/is not supported for architecture/) end
  end

  context 'fail when release not supported' do
    let(:facts) do
      {
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '8',
      :hardwaremodel => 'x86_64',
      :osrel => '8',
    }
    end

    let(:params) do
      {
      :source => 'cloudera',
      :cdhver => '5',
    }
    end

    it do
      expect do
        is_expected.to compile
    end.to raise_error(/is not supported for redhat version/) end
  end

  context 'fail when CDH version not supported' do
    let(:facts) do
      {
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :hardwaremodel => 'x86_64',
      :osrel => '7',
    }
    end

    let(:params) do
      {
      :source => 'cloudera',
      :cdhver => '6',
    }
    end

    it do
      expect do
        should compile
    end.to raise_error(/is not a supported cloudera repo./) end
  end

  context 'fail when repository source not supported' do
    let(:facts) do
      {
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :hardwaremodel => 'x86_64',
      :osrel => '7',
    }
    end

    let(:params) do
      {
      :source => 'another-repo',
    }
    end

    it do
      expect do
        should compile
    end.to raise_error(/provides no repository information for yum repository/) end
  end
end
