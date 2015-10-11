#
# Cookbook Name:: nagios
# Recipe:: configuration
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#
nag_admin = node['nagios']['admin_user']

template '/usr/local/nagios/etc/nagios.cfg' do
  source 'nagios.cfg.erb'
  mode 0644
  owner nag_admin['username']
  group nag_admin['primary_group']
end

directory '/usr/local/nagios/etc/servers' do
  recursive true
end

directory '/usr/local/nagios/etc/objects' do
  recursive true
end

template '/usr/local/nagios/etc/objects/contacts.cfg' do
  source 'contacts.cfg.erb'
  mode 0644
  owner nag_admin['username']
  group nag_admin['primary_group']
  variables email: nag_admin['email_address']
end

template '/usr/local/nagios/etc/objects/commangs.cfg' do
  source 'commands.cfg.erb'
  mode 0644
  owner nag_admin['username']
  group nag_admin['primary_group']
end

service 'nagios' do
  action [:start, :enable]
end

service 'httpd' do
  action :restart
end
