#
# Cookbook Name:: nagios
# Recipe:: plugins
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

cache_path = Chef::Config['file_cache_path']
version = node['nagios']['plugins']['version']
nag_admin = node['nagios']['admin_user']

remote_file "#{cache_path}/nagios-plugins-#{version}.tar.gz" do
  source "http://nagios-plugins.org/download/nagios-plugins-#{version}.tar.gz"
  checksum node['nagios']['plugins']['checksum']
  notifies :run, 'bash[extract]', :immediately
end

bash 'extract' do
  action :nothing
  cwd cache_path
  code <<-EOSH
    mkdir nagios-plugins-#{version}
    tar -xzf nagios-plugins-#{version}.tar.gz -C nagios-plugins-#{version} \
    --strip-components 1
  EOSH
  notifies :run, 'bash[install]', :immediately
  creates "#{cache_path}/nagios-plugins-#{version}/configure"
end

bash 'install' do
  action :nothing
  cwd "#{cache_path}/nagios-plugins-#{version}"
  user 'root'
  code <<-EOSH
    ./configure --with-nagios-user=#{nag_admin['username']} \
    --with-nagios-group=#{nag_admin['primary_group']} --with-openssl &&
    make && make install
  EOSH
end
