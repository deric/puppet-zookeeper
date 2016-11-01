require 'spec_helper'

describe 'zookeeper::install::repo' do
  shared_examples 'redhat-install' do |os, codename, puppet, cdhver, precond|
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

    # load class, handle custom params
    let :pre_condition do
      precond
    end

    it { is_expected.to contain_yumrepo('cloudera-cdh5').with({
        baseurl: "http://archive.cloudera.com/cdh#{cdhver}/redhat/#{codename}/#{hardwaremodel}/cdh/#{cdhver}/"
      }) }
  end

  context 'on RedHat-like system' do
    let(:user) { 'zookeeper' }
    let(:group) { 'zookeeper' }

    precond = 'class {"zookeeper":
      repo   => "cloudera",
      cdhver => "5",
    }'
    # ENV variable might contain characters which are not supported
    # by versioncmp function (like '~>')

    it_behaves_like 'redhat-install', 'RedHat', '7', Puppet.version, '5', precond
  end

  context 'fail when architecture not supported' do
    let(:facts) do
      {
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :hardwaremodel => 'arc',
    }
    end

    let :pre_condition do
      'class {"zookeeper":
        repo   => "cloudera",
        cdhver => "5",
       }'
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

    let :pre_condition do
      'class {"zookeeper":
        repo   => "cloudera",
        cdhver => "5",
       }'
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

    let :pre_condition do
      'class {"zookeeper":
        repo   => "cloudera",
        cdhver => "6",
       }'
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

    let :pre_condition do
      'class {"zookeeper":
        repo => "another-repo",
       }'
    end

    it do
      expect do
        should compile
    end.to raise_error(/provides no repository information for yum repository/) end
  end
end
