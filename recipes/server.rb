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
include_recipe "logrotate"
include_recipe "mongodb"

server_storage              = node['graylog2']['server_storage']
server_user                 = node['graylog2']['server_user']
server_group                = node['graylog2']['server_group']
server_path                 = node['graylog2']['server_path']
server_etc                  = node['graylog2']['server_etc']
server_logs                 = node['graylog2']['server_logs']
server_pid                  = node['graylog2']['server_pid']
server_lock                 = node['graylog2']['server_lock']
server_download             = node['graylog2']['server_download']
server_version              = node['graylog2']['server_version']
server_file                 = node['graylog2']['server_file']
server_checksum             = node['graylog2']['server_checksum']

servicewrapper_path         = node['graylog2']['servicewrapper_path'] 
servicewrapper_download     = node['graylog2']['servicewrapper_download']
servicewrapper_version      = node['graylog2']['servicewrapper_version']
servicewrapper_file         = node['graylog2']['servicewrapper_file']
servicewrapper_checksum     = node['graylog2']['servicewrapper_checksum']

group server_group do
    system true
end

user server_user do
    home server_path
    comment "services user for graylog2-server"
    gid server_group
    system true
end

[server_path, server_etc].each do |folder|
  directory folder do
    owner "root"
    group "root"
    mode "0755"
  end
end

[server_pid, server_lock, server_logs].each do |folder|
  directory folder do
    owner server_user
    group server_group
    mode "0755"
  end
end

unless FileTest.exists?(server_path)
    remote_file "#{Chef::Config[:file_cache_path]}/#{server_file}" do
        source server_download
        checksum server_checksum
        action :create_if_missing
    end

    bash "install graylog2 sources #{server_file}" do
        cwd Chef::Config[:file_cache_path]
        code <<-EOH
          tar -zxf #{server_file} -C  #{server_path}
        EOH
    end
end

unless FileTest.exists?("#{server_path}/service")
  remote_file "#{Chef::Config[:file_cache_path]}/#{servicewrapper_file}" do
    source servicewrapper_download
    checksum servicewrapper_checksum
    action :create_if_missing
  end

  bash "extract java service wrapper" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -zxf #{servicewrapper_file} 
      mv wrapper-delta-pack-#{servicewrapper_version} #{server_path}/service
    EOH
  end
end
               
template "/etc/init.d/graylog2-server" do
  source "graylog2-server-init.erb"
  owner "root"
  group "root"
  mode 0755
end

template "#{server_etc}/graylog2-service.conf" do
  source "graylog2-service.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{server_etc}/graylog2.conf" do
    source "graylog2.conf.erb"
    mode 0644
end

template "/etc/init.d/graylog2-server" do
    source "graylog2.init.erb"
    owner "root"
    group "root"
    mode 0755
end

logrotate_app "graylog2-server" do
  cookbook "logrotate"
  path "/var/log/graylog2-server/graylog2.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
end

#service "graylog2-server" do
#  supports :restart => true
#  action [:enable, :start]
#end
