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
include_recipe "mongodb"
include_recipe "elasticsearch"

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
  bash "install graylog2 sources from #{node['graylog2']['project_url']}" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      wget $(wget -qO- #{node['graylog2']['project_url']} | grep graylog2-server | grep download | grep href | cut -d'"' -f2) 
      tar -zxf graylog2-server-*.tar.gz
      rm -rf graylog2-server-*/graylog2.conf.example
      mv -f graylog2-server-*/bin/* graylog2-server-*/*.jar #{node['graylog2']['server_bin']}
      mv -f graylog2-server-*/plugin #{node['graylog2']['server_path']}
      chown -R root:root #{node['graylog2']['server_path']}
      chmod -R 755 #{node['graylog2']['server_bin']}
    EOH
  end
end

unless FileTest.exists?("#{node['graylog2']['server_wrapper']}/lib/wrapper.jar")
  bash "extract java service wrapper" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      rm -rf wrapper-delta-pack-*
      wget #{node['graylog2']['servicewrapper_url']}/$(wget -qO- http://sourceforge.net/projects/wrapper/  | grep 'small title' | cut -d'"' -f2 | cut -d'_' -f2)/wrapper-delta-pack-$(wget -qO- http://sourceforge.net/projects/wrapper/  | grep 'small title' | cut -d'"' -f2 | cut -d'_' -f2).tar.gz
      tar -zxf wrapper-delta-pack-*
      #rm -rf wrapper-delta-pack-*/conf \
      #       wrapper-delta-pack-*/src \
      #       wrapper-delta-pack-*/jdoc \
      #       wrapper-delta-pack-*/doc \
      #       wrapper-delta-pack-*/logs \
      #       wrapper-delta-pack-*/jdoc.tar.gz \
      #       wrapper-delta-pack-*/bin/*.exe \
      #       wrapper-delta-pack-*/bin/*.bat \
      #       wrapper-delta-pack-*/lib/*.dll \
      #       wrapper-delta-pack-*/lib/*demo*.* \
      #       wrapper-delta-pack-*/bin/*test*.* 
      mv wrapper-delta-pack-*/* #{node['graylog2']['server_wrapper']}
      chown -R root:root #{node['graylog2']['server_wrapper']}
      chmod -R 755 #{node['graylog2']['server_wrapper']}
    EOH
  end
end

link "#{node['graylog2']['server_path']}/config" do
  to node['graylog2']['server_etc']
end

link "#{node['graylog2']['server_path']}/logs" do
  to node['graylog2']['server_logs']
end

template "#{node['graylog2']['server_etc']}/graylog2-wrapper.conf" do
  source "graylog2-server-wrapper.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{node['graylog2']['server_etc']}/graylog2-elasticsearch.yml" do
  source "elasticsearch.yml.erb"
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

service "graylog2-server" do
  supports :restart => true
  action [:enable, :start]
end
