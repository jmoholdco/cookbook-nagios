#
# Cookbook Name:: nagios
# Recipe:: build
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

cache_path = Chef::Config['file_cache_path']
version = node['nagios']['version']

node['nagios']['build_dependencies'].each do |dep|
  yum_package dep do
    action :install
  end
end

# rubocop:disable Metrics/LineLength
remote_file "#{cache_path}/nagios-#{version}.tar.gz" do
  source "https://assets.nagios.com/downloads/nagioscore/releases/nagios-#{version}.tar.gz"
  checksum node['nagios']['checksum']
  notifies :run, 'bash[extract_core]', :immediately
end

bash 'extract_core' do
  action :nothing
  cwd cache_path
  code <<-EOSH
    mkdir nagios-#{version}
    tar -xzf nagios-#{version}.tar.gz -C nagios-#{version} --strip-components 1
  EOSH
  creates "#{cache_path}/nagios-#{version}/configure"
  notifies :run, 'bash[config_core]', :immediately
end

bash 'config_core' do
  action :nothing
  user 'root'
  cwd "#{cache_path}/nagios-#{version}"
  code <<-EOSH
    ./configure --with-command-group=nagcmd && make all
  EOSH
  notifies :run, 'bash[install_core]', :immediately
end

bash 'install_core' do
  action :nothing
  user 'root'
  cwd "#{cache_path}/nagios-#{version}"
  code <<-EOSH
    (make install && make install-commandmode && make install-init &&
     make install-config && make install-webconf)
  EOSH
end
