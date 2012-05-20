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
include_recipe "mongodb"

SERVER_USER                 = node['GRAYLOG2']['SERVER_USER']
SERVER_GROUP                = node['GRAYLOG2']['SERVER_GROUP']
SERVER_PATH                 = node['GRAYLOG2']['SERVER_PATH']
SERVER_ETC                  = node['GRAYLOG2']['SERVER_ETC']
SERVER_LOGS                 = node['GRAYLOG2']['SERVER_LOGS']
SERVER_PID                  = node['GRAYLOG2']['SERVER_PID']
SERVER_LOCK                 = node['GRAYLOG2']['SERVER_LOCK']
SERVER_DOWNLOAD             = node['GRAYLOG2']['SERVER_DOWNLOAD']
SERVER_VERSION              = node['GRAYLOG2']['SERVER_VERSION']
SERVER_FILE                 = node['GRAYLOG2']['SERVER_FILE']
SERVER_CHECKSUM             = node['GRAYLOG2']['SERVER_CHECKSUM']

SERVICEWRAPPER_PATH         = node['GRAYLOG2']['SERVICEWRAPPER_PATH'] 
SERVICEWRAPPER_DOWNLOAD     = node['GRAYLOG2']['SERVICEWRAPPER_DOWNLOAD']
SERVICEWRAPPER_VERSION      = node['GRAYLOG2']['SERVICEWRAPPER_VERSION']
SERVICEWRAPPER_FILE         = node['GRAYLOG2']['SERVICEWRAPPER_FILE']
SERVICEWRAPPER_CHECKSUM     = node['GRAYLOG2']['SERVICEWRAPPER_CHECKSUM']

group SERVER_GROUP do
    system true
end

user SERVER_USER do
    home SERVER_PATH
    comment "services user for graylog2-server"
    gid SERVER_GROUP
    system true
end

[SERVER_PATH, SERVER_ETC].each do |folder|
  directory folder do
    owner "root"
    group "root"
    mode "0755"
  end
end

[SERVER_PID, SERVER_LOCK, SERVER_LOGS].each do |folder|
  directory folder do
    owner SERVER_USER
    group SERVER_GROUP
    mode "0755"
  end
end

unless FileTest.exists?(SERVER_PATH)
  remote_FILE "#{Chef::Config[:file_cache_PATH]}/#{SERVER_FILE}" do
    source SERVER_DOWNLOAD
    checksum SERVER_CHECKSUM
    action :create_if_missing
  end

  bash "install graylog2 sources #{SERVER_FILE}" do
    cwd Chef::Config[:file_cache_PATH]
    code <<-EOH
      tar -zxf #{SERVER_FILE}
      rm -rf graylog2-server-#{SERVER_VERSION}/build_date graylog2-server-#{SERVER_VERSION}/COPYING graylog2-server-#{SERVER_VERSION}/graylog2.conf.example graylog2-server-#{SERVER_VERSION}/README graylog2-server-#{SERVER_VERSION}/doc
      mv -f graylog2-server-#{SERVER_VERSION}/* #{SERVER_PATH}
      chown -Rf root:root #{SERVER_PATH}
    EOH
  end
end

unless FileTest.exists?("#{SERVER_PATH}/lib")
  remote_FILE "#{Chef::Config[:file_cache_PATH]}/#{SERVICEWRAPPER_FILE}" do
    source SERVICEWRAPPER_DOWNLOAD
    checksum SERVICEWRAPPER_CHECKSUM
    action :create_if_missing
  end

  bash "extract java service wrapper" do
    cwd Chef::Config[:file_cache_PATH]
    code <<-EOH
      tar -zxf #{SERVICEWRAPPER_FILE} 
      rm -rf wrapper-delta-pack-#{SERVICEWRAPPER_VERSION}/conf wrapper-delta-pack-#{SERVICEWRAPPER_VERSION}/src wrapper-delta-pack-#{SERVICEWRAPPER_VERSION}/jdoc wrapper-delta-pack-#{SERVICEWRAPPER_VERSION}/doc wrapper-delta-pack-#{SERVICEWRAPPER_VERSION}/logs wrapper-delta-pack-#{SERVICEWRAPPER_VERSION}/jdoc.tar.gz wrapper-delta-pack-#{SERVICEWRAPPER_VERSION}/README*.*
      mv wrapper-delta-pack-#{SERVICEWRAPPER_VERSION}/* #{SERVER_PATH}
      chown -Rf root:root #{SERVER_PATH}
    EOH
  end
end

link "#{SERVER_PATH}/config" do
  to SERVER_ETC
end

link "#{SERVER_PATH}/logs" do
  to SERVER_LOGS
end

template "/etc/init.d/graylog2-server" do
  source "graylog2-server-init.erb"
  owner "root"
  group "root"
  mode 0755
end

template "#{SERVER_ETC}/graylog2-service.conf" do
  source "graylog2-service.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{SERVER_ETC}/graylog2.conf" do
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
