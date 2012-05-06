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

server_storage      = node['graylog2']['server_storage']
server_user         = node['graylog2']['server_user']
server_group        = node['graylog2']['server_group']
server_path         = node['graylog2']['server_path']
server_download     = node['graylog2']['server_download']
server_version      = node['graylog2']['server_version']
server_file         = node['graylog2']['server_file']
server_checksum     = node['graylog2']['server_checksum']

syslog4j_version    = node['graylog2']['syslog4j_version']
syslog4j_file       = node['graylog2']['syslog4j_file']
syslog4j_download   = node['graylog2']['syslog4j_download']
syslog4j_checksum   = node['graylog2']['syslog4j_checksum']
syslog4j_path       = node['graylog2']['syslog4j_path']

if (server_storage == "elasticsearch")
    include_recipe "elasticsearch"
end

template "/etc/graylog2.conf" do
    source "graylog2.conf.erb"
    mode 0644
end

group server_group do
    system true
end

user server_user do
    home server_path
    comment "services user for graylog2-server"
    gid server_group
    #shell "/bin/false"
    system true
end

log "Created service user #{server_user} and group #{server_group} to run graylog2." do
    action :nothing
end

unless FileTest.exists?("#{server_path}/graylog2-server-#{server_version}")
    directory server_path do
        owner server_user
        group server_group
        mode 0755
    end

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

    link "#{server_path}/current" do
        to "#{server_path}/graylog2-server-#{server_version}"
    end

    directory server_path do
        recursive true
        owner server_user
        group server_group
        mode 0755
    end

    log "Downloaded, installed and configured the Graylog2 binary files in #{server_path}/#{server_version}." do
        action :nothing
    end
end

unless FileTest.exists?("#{syslog4j_path}/#{syslog4j_version}")
    directory syslog4j_path do
        mode 0755
    end

    remote_file "#{syslog4j_path}/#{syslog4j_file}" do
        source syslog4j_download
        checksum syslog4j_checksum
        action :create_if_missing
    end

    link "#{syslog4j_path}/syslog4j-current-bin.jar" do
        to "#{syslog4j_path}/#{syslog4j_file}"
    end

    log "Downloaded, installed and configured the syslog4j binary files for graylog2 logging in #{syslog4j_path}/#{syslog4j_version}." do
        action :nothing
    end
end

directory "/var/log/graylog2-server" do
    owner server_user
    group server_group
    mode 0755
end

directory "/var/run/graylog2-server" do
    owner server_user
    group server_group
    mode 0755
end

logrotate_app "graylog2-server" do
  cookbook "logrotate"
  path "/var/log/graylog2-server/graylog2.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
end

template "/etc/init.d/graylog2" do
    source "graylog2.init.erb"
    owner "root"
    group "root"
    mode 0755
end

service "graylog" do
  supports :restart => true, :status => true
  action [:enable, :start]
end

log "Installed the Graylog2 init file /etc/init.d/graylog2, change the runlevel and startet the service." do
    action :nothing
end
