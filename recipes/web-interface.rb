#
# Cookbook Name:: graylog2
# Recipe:: web-interface
#
# Copyright 2012, SourceIndex IT-Services
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

package "build-essential"
package "postfix"

gem_package "rack" do
  action :install
end

gem_package "rake" do
  action :install
end

gem_package "rails" do
  action :install
end

gem_package "json" do
  action :install
end

gem_package "chronic" do
  action :install
end

gem_package "declarative_authorization" do
  action :install
end

gem_package "graylog2-declarative_authorization" do
  action :install
end

gem_package "pony" do
  action :install
end

gem_package "hoptoad_notifier" do
  action :install
end

gem_package "rpm_contrib" do
  action :install
end

gem_package "mongoid" do
  version "2.4.5"
  action :install
end

gem_package "tire" do
  action :install
end

gem_package "bson" do
  action :install
end

gem_package "bson_ext" do
  action :install
end

gem_package "home_run" do
  action :install
end

gem_package "SystemTimer" do
  action :install
end

gem_package "rails_autolink" do
  action :install
end

gem_package "kaminari" do
  action :install
end


directory "#{node.graylog2.basedir}/rel" do
  mode 0755
  recursive true
end

remote_file "download_web_interface" do
  path "#{node.graylog2.basedir}/rel/graylog2-web-interface-#{node.graylog2.web_interface.version}.tar.gz"
  source "https://github.com/downloads/Graylog2/graylog2-web-interface/graylog2-web-interface-#{node.graylog2.web_interface.version}.tar.gz"
  action :create_if_missing
end

execute "tar zxf graylog2-web-interface-#{node.graylog2.web_interface.version}.tar.gz" do
  cwd "#{node.graylog2.basedir}/rel"
  creates "#{node.graylog2.basedir}/rel/graylog2-web-interface-#{node.graylog2.web_interface.version}/build_date"
  action :nothing
  subscribes :run, resources(:remote_file => "download_web_interface"), :immediately
end

link "#{node.graylog2.basedir}/web" do
  to "#{node.graylog2.basedir}/rel/graylog2-web-interface-#{node.graylog2.web_interface.version}"
end

execute "bundle install" do
  cwd "#{node.graylog2.basedir}/web"
  action :nothing
  subscribes :run, resources(:link => "#{node.graylog2.basedir}/web"), :immediately
end

template "#{node.graylog2.basedir}/web/config/general.yml" do
  owner "nobody"
  group "nogroup"
  mode 0644
end

execute "sudo chown -R nobody:nogroup graylog2-web-interface-#{node.graylog2.web_interface.version}" do
  cwd "#{node.graylog2.basedir}/rel"
  not_if do
    File.stat("#{node.graylog2.basedir}/rel/graylog2-web-interface-#{node.graylog2.web_interface.version}").uid == 65534
  end
  action :nothing
  subscribes :run, resources(:execute => "bundle install"), :immediately
end

cron "Graylog2 send stream alarms" do
  minute node[:graylog2][:stream_alarms_cron_minute]
  action node[:graylog2][:send_stream_alarms] ? :create : :delete
  command "cd #{node[:graylog2][:basedir]}/web && RAILS_ENV=production bundle exec rake streamalarms:send"
end

cron "Graylog2 send stream subscriptions" do
  minute node[:graylog2][:stream_subscriptions_cron_minute]
  action node[:graylog2][:send_stream_subscriptions] ? :create : :delete
  command "cd #{node[:graylog2][:basedir]}/web && RAILS_ENV=production bundle exec rake subscriptions:send"
end
