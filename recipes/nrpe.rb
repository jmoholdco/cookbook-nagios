#
# Cookbook Name:: nagios
# Recipe:: nrpe
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

cache_path = Chef::Config['file_cache_path']
version = node['nagios']['nrpe']['version']
nag_admin = node['nagios']['admin_user']

# rubocop:disable Metrics/LineLength
bash 'download_nrpe' do
  cwd cache_path
  code <<-EOSH
  curl -L -O http://sourceforge.net/projects/nagios/files/nrpe-2.x/nrpe-#{version}/nrpe-#{version}.tar.gz
  EOSH
  notifies :run, 'bash[extract_nrpe]', :immediately
  creates "#{cache_path}/nrpe-#{version}.tar.gz"
end

bash 'extract_nrpe' do
  cwd cache_path
  action :nothing
  code <<-EOSH
  mkdir nrpe-#{version}
  tar -xzf nrpe-#{version}.tar.gz -C nrpe-#{version} --strip-components 1
  EOSH
  notifies :run, 'bash[install_nrpe]', :immediately
  creates "#{cache_path}/nrpe-#{version}/configure"
end

bash 'install_nrpe' do
  action :nothing
  cwd "#{cache_path}/nrpe-#{version}"
  user 'root'
  code <<-EOSH
    ./configure --enable-command-args --with-nagios-user=#{nag_admin['username']} \
    --with-nagios-group=#{nag_admin['primary_group']} --with-ssl=/usr/bin/openssl \
    --with-ssl-lib=/usr/lib/x86_64-linux-gnu && make all && make install &&
    make install-xinetd && make install-daemon-config
  EOSH
  notifies :create, 'template[nrpe]', :immediately
end

template 'nrpe' do
  source 'nrpe.erb'
  variables ip: node['ipaddress']
  owner 'root'
  mode 0644
  notifies :restart, 'service[xinetd]', :immediately
end

service 'xinetd' do
  action :nothing
end
