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

directory "#{node.graylog2.basedir}/rel" do
  mode 0755
  recursive true
end

remote_file "download_server" do
  path "#{node.graylog2.basedir}/rel/graylog2-server-#{node.graylog2.server.version}.tar.gz"
  source "https://github.com/downloads/Graylog2/graylog2-server/graylog2-server-#{node.graylog2.server.version}.tar.gz"
  action :create_if_missing
end

execute "tar zxf graylog2-server-#{node.graylog2.server.version}.tar.gz" do
  cwd "#{node.graylog2.basedir}/rel"
  creates "#{node.graylog2.basedir}/rel/graylog2-server-#{node.graylog2.server.version}/build_date"
  action :nothing
  subscribes :run, resources(:remote_file => "download_server"), :immediately
end

link "#{node.graylog2.basedir}/server" do
  to "#{node.graylog2.basedir}/rel/graylog2-server-#{node.graylog2.server.version}"
end

template "/etc/graylog2.conf" do
  mode 0644
end

template "/etc/init.d/graylog2" do
  source "graylog2.init.erb"
  mode 0755
end

execute "update-rc.d graylog2 defaults" do
  creates "/etc/rc0.d/K20graylog2"
  action :nothing
  subscribes :run, resources(:template => "/etc/init.d/graylog2"), :immediately
end

service "graylog2" do
  supports :restart => true
  action [:enable, :start]
end
