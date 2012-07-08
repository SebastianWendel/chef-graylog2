#
# Cookbook Name:: graylog2
# Recipe:: server
#
# Copyright 2012, SourceIndex IT-Serives
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "java"
#include_recipe "logrotate"
#include_recipe "mongodb"
#include_recipe "elasticsearch"

group node['graylog2']['server_group'] do
    system true
end

user node['graylog2']['server_user'] do
    home node['graylog2']['server_path']
    comment "services user for graylog2-server"
    gid node['graylog2']['server_group']
    system true
end

root_dirs = [
  node['graylog2']['server_path'],
  node['graylog2']['server_bin'],
  node['graylog2']['server_wrapper'],
  node['graylog2']['server_path'],
  node['graylog2']['server_etc']
]

root_dirs.each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode "0755"
  end
end

user_dirs = [
  node['graylog2']['server_pid'],
  node['graylog2']['server_lock'],
  node['graylog2']['server_logs']
]

user_dirs.each do |dir|
  directory dir do
    owner node['graylog2']['server_user']
    group node['graylog2']['server_group']
    mode "0755"
  end
end

unless FileTest.exists?("#{node['graylog2']['server_bin']}/graylog2-server.jar")
  remote_FILE "#{Chef::Config[:file_cache_path]}/#{node['graylog2']['server_file']}" do
    source node['graylog2']['server_download']
    checksum node['graylog2']['server_checksum']
    action :create_if_missing
  end

  bash "install graylog2 sources #{node['graylog2']['server_file']}" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -zxf #{node['graylog2']['server_file']}
      rm -rf graylog2-server-#{node['graylog2']['server_version']}/build_date graylog2-server-#{node['graylog2']['server_version']}/bin graylog2-server-#{node['graylog2']['server_version']}/graylog2.conf.example
      mv -f graylog2-server-#{node['graylog2']['server_version']}/* #{node['graylog2']['server_bin']}
    EOH
  end
end

unless FileTest.exists?("#{node['graylog2']['server_wrapper']}/lib/wrapper.jar")
  remote_FILE "#{Chef::Config[:file_cache_path]}/#{node['graylog2']['servicewrapper_file']}" do
    source node['graylog2']['servicewrapper_download']
    checksum node['graylog2']['servicewrapper_checksum']
    action :create_if_missing
  end

  bash "extract java service wrapper" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -zxf #{node['graylog2']['servicewrapper_file']} 
      rm -rf wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/conf wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/src wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/jdoc wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/doc wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/logs wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/jdoc.tar.gz wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/bin/*.exe wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/bin/*.bat wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/lib/*.dll wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/lib/*demo*.* wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/bin/*test*.*
      mv wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}/* #{node['graylog2']['server_wrapper']}
    EOH
  end
end

link "#{node['graylog2']['server_path']}/config" do
  to node['graylog2']['server_etc']
end

link "#{node['graylog2']['server_path']}/logs" do
  to node['graylog2']['server_logs']
end

template "/etc/init.d/graylog2-server" do
  source "graylog2-server-init.erb"
  owner "root"
  group "root"
  mode 0755
end

template "#{node['graylog2']['server_etc']}/graylog2-wrapper.conf" do
  source "graylog2-server-wrapper.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{node['graylog2']['server_etc']}/graylog2-server.conf" do
    source "graylog2-server.conf.erb"
    mode 0644
end

template "/etc/init.d/graylog2-server" do
    source "graylog2-server-init.erb"
    owner "root"
    group "root"
    mode 0755
end

logrotate_app "graylog2-server" do
  cookbook "logrotate"
  path "#{node['graylog2']['server_logs']}/graylog2.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
end

service "graylog2-server" do
  supports :restart => true
  action [:enable, :start]
end
