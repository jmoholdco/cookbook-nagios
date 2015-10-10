#
# Cookbook Name:: nagios
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'nagios::build' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:build_deps) do
      ['gcc', 'glibc', 'glibc-common', 'gd-devel', 'make', 'net-snmp',
       'openssl-devel', 'xinetd', 'unzip']
    end

    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs the build dependencies' do
      build_deps.each do |dep|
        expect(chef_run).to install_yum_package dep
      end
    end

    describe 'the build process' do
      let(:tarball) { chef_run.remote_file('/var/cache/nagios-4.1.1.tar.gz') }
      let(:extract) { chef_run.bash('extract_source') }
      let(:config) { chef_run.bash('config_and_make') }
      let(:install) { chef_run.bash('install_all') }

      it 'downloads the source tarball' do
        expect(chef_run).to create_remote_file('/var/cache/nagios-4.1.1.tar.gz')
      end

      it 'remote file notifies bash to extract' do
        expect(tarball).to notify('bash[extract_source]').to(:run).immediately
      end

      it 'extract bash notifies config and make, but does nothing by default' do
        expect(chef_run).to_not run_bash('extract_source')
        expect(extract).to notify('bash[config_and_make]')
      end

      it 'config & make does nothing by default, but notifies install_all' do
        expect(chef_run).to_not run_bash('config_and_make')
        expect(config).to notify('bash[install_all]')
      end

      it 'install_all does nothing by default' do
        expect(chef_run).to_not run_bash('install_all')
      end
    end
  end
end
