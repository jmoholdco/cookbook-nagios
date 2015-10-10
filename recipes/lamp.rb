#
# Cookbook Name:: nagios
# Recipe:: lamp
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

include_recipe 'chef-vault'
include_recipe 'selinux::disabled'

yum_package 'httpd' do
  action :install
end

service 'httpd' do
  action [:start, :enable]
end

root_passwords = chef_vault_item('nagios', 'passwords')

mysql_service 'nagios' do
  port '3306'
  initial_root_password root_passwords['mysql']
  action [:create, :start]
end

include_recipe 'php'
include_recipe 'php-fpm'

include_recipe 'firewalld'

firewalld_service 'http' do
  zone 'public'
  action :add
end

firewalld_service 'https' do
  zone 'public'
  action :add
end

firewalld_service 'ssh' do
  zone 'public'
  action :add
end
