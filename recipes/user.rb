#
# Cookbook Name:: nagios
# Recipe:: user
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'chef-vault'

nag_admin = node['nagios']['admin_user']
groups = [nag_admin['primary_group'], nag_admin['secondary_groups']].flatten
passwords = chef_vault_item('nagios', 'passwords')

groups.each do |grp|
  group grp
end

user nag_admin['username'] do
  group nag_admin['primary_group']
  shell '/bin/bash'
  manage_home true
  home "/home/#{nag_admin['username']}"
  password passwords['nag_admin']
  action :create
end

nag_admin['secondary_groups'].each do |grp|
  group grp do
    action :modify
    append true
    members [nag_admin['username'], 'apache']
  end
end
