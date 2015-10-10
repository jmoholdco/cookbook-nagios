#
# Cookbook Name:: nagios
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'nagios::plugins' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
  let(:src) { chef_run.remote_file('/var/cache/nagios-plugins-2.1.1.tar.gz') }
  let(:extract) { chef_run.bash('extract') }
  let(:make) { chef_run.bash('install') }

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'downloads the source tarball' do
    expect(chef_run).to create_remote_file(
      '/var/cache/nagios-plugins-2.1.1.tar.gz')
  end

  it 'remote file notifies bash to extract' do
    expect(src).to notify('bash[extract]').to(:run).immediately
  end

  it 'extract bash notifies config and make, but does nothing by default' do
    expect(chef_run).to_not run_bash('extract')
    expect(extract).to notify('bash[install]')
  end

  it 'install does nothing by default' do
    expect(chef_run).to_not run_bash('install')
  end
end
