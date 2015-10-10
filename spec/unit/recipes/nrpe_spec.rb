#
# Cookbook Name:: nagios
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'nagios::nrpe' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
    let(:src) { chef_run.bash('download') }
    let(:extract) { chef_run.bash('extract') }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the remote file' do
      expect(chef_run).to run_bash('download')
    end

    it 'remote file notifies extract script' do
      expect(src).to notify('bash[extract]').to(:run).immediately
    end

    it 'extraction script does nothing until notified' do
      expect(chef_run).to_not run_bash('extract')
    end

    it 'extraction script notifies install script' do
      expect(extract).to notify('bash[install]').to(:run).immediately
    end
  end
end
