#
# Cookbook Name:: nagios
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'nagios::lamp' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    describe 'included recipes' do
      subject { chef_run }
      it { is_expected.to include_recipe 'chef-vault' }
      it { is_expected.to include_recipe 'selinux::disabled' }
      it { is_expected.to include_recipe 'php' }
      it { is_expected.to include_recipe 'php-fpm' }
    end

    describe 'httpd' do
      it 'installs the package' do
        expect(chef_run).to install_yum_package 'httpd'
      end
      it 'creates the service' do
        expect(chef_run).to start_service 'httpd'
      end
    end

    describe 'mysql_service[nagios]' do
      it 'creates the service' do
        expect(chef_run).to create_mysql_service('nagios').with(
          port: '3306',
          initial_root_password: 'mysqlsecret'
        )
      end
    end

    describe 'firewall rules' do
      it 'enables http traffic' do
        expect(chef_run).to add_firewalld_service('http').with(zone: 'public')
      end

      it 'enables https traffic' do
        expect(chef_run).to add_firewalld_service('https').with(zone: 'public')
      end
    end
  end
end
