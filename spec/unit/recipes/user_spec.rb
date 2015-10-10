#
# Cookbook Name:: nagios
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'nagios::user' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    describe 'creating groups' do
      it 'creates both default groups' do
        expect(chef_run).to create_group('nagios')
        expect(chef_run).to create_group('nagcmd')
      end
    end

    describe 'creating the nagios user' do
      it 'creates the user `nagios`' do
        expect(chef_run).to create_user('nagios').with(
          group: 'nagios',
          shell: '/bin/bash',
          manage_home: true,
          home: '/home/nagios',
          password: 'nagiossecret'
        )
      end
    end

    describe 'modifying the nagcmd group' do
      it 'adds the user `nagios` to the `nagcmd` group' do
        expect(chef_run).to modify_group('nagcmd').with(
          append: true,
          members: %w(nagios apache)
        )
      end
    end
  end
end
