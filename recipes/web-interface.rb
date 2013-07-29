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

case node['platform']
when "debian", "ubuntu"
  include_recipe 'apt'
  #packages = %w{apache2-dev libcurl4-openssl-dev}
  packages = %w{apache2-threaded-dev libcurl4-openssl-dev}
    packages.each do |pkg|
    package pkg do
      action :install
    end
  end
when "centos","redhat"
  include_recipe 'yum'
  include_recipe "yum::epel"
  packages = %w{httpd httpd-devel curl-devel crontabs}
    packages.each do |pkg|
    package pkg do
      action :install
    end
  end
end
package "postfix"

case node['platform']
when "centos","redhat"
  bash "Workaround for http://tickets.opscode.com/browse/COOK-1210" do 
    code <<-EOH
      echo 0 > /selinux/enforce
    EOH
  end
end

include_recipe "apache2"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_rewrite"

execute "create graylog2 ssl request" do
  command "openssl genrsa > #{node['apache']['dir']}/ssl/graylog2.key"
  not_if { ::File.exists?("#{node['apache']['dir']}/ssl/graylog2.key") }
end

execute "create graylog2 ssl certficate" do
  command %Q{openssl req -new -x509 -key #{node['apache']['dir']}/ssl/graylog2.key -out #{node['apache']['dir']}/ssl/graylog2.pem -days 3650 <<EOF
US
Washington
Seattle
Opscode, Inc

example.com
webmaster@example.com
EOF}
  not_if { ::File.exists?("#{node['apache']['dir']}/ssl/graylog2.pem") }
end

template "#{node[:apache][:dir]}/sites-available/graylog2.conf" do
  source "graylog2-apache2.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

group node['graylog2']['web_group'] do
  system true
end

user node['graylog2']['web_user'] do
  home node['graylog2']['web_path']
  gid node['graylog2']['web_group']
  comment "services user for thr graylog2-web-interface"
  supports :manage_home => true
  shell "/bin/bash"
end

unless FileTest.exists?("#{node['graylog2']['web_path']}/graylog2-web-interface/Gemfile")
  bash "install graylog2 sources from #{node['graylog2']['project_url']}" do
    cwd node['graylog2']['web_path']
    code <<-EOH
      wget $(wget -qO- #{node['graylog2']['project_url']} | grep graylog2-web-interface | grep download | grep href | cut -d'"' -f2) 
      tar -zxf graylog2-web-interface-*.tar.gz
      rm -f graylog2-web-interface-*.tar.gz
      mv graylog2-web-interface-* graylog2-web-interface
      chown -R root:root graylog2-web-interface
      chmod -R 755 graylog2-web-interface
      EOH
    end
end

template "Create graylog2-web general config." do
  path "#{node['graylog2']['web_path']}/graylog2-web-interface/config/general.yml"
  source "general.yml.erb"
  owner node['graylog2']['web_user']
  group node['graylog2']['web_group']
  mode 0644
end

template "Create graylog2-web mongodb config." do
  path "#{node['graylog2']['web_path']}/graylog2-web-interface/config/mongoid.yml"
  source "mongoid.yml.erb"
  owner node['graylog2']['web_user']
  group node['graylog2']['web_group']
  mode 0644
end

template "Create graylog2-web indexer config." do
  path "#{node['graylog2']['web_path']}/graylog2-web-interface/config/indexer.yml"
  source "indexer.yml.erb"
  owner node['graylog2']['web_user']
  group node['graylog2']['web_group']
  mode 0644
end

template "Create graylog2-web email config." do
  path "#{node['graylog2']['web_path']}/graylog2-web-interface/config/email.yml"
  source "email.yml.erb"
  owner node['graylog2']['web_user']
  group node['graylog2']['web_group']
  mode 0644
end

#node.default['rvm']['user_installs'] = [
#  { 'user' => node['graylog2']['web_user'] }
#]

#include_recipe "rvm::user_install"

#rvm_ruby node['graylog2']['ruby_version'] do
#  user node['graylog2']['web_user']
#end

#rvm_gem "bundler" do
#  user node['graylog2']['web_user']
#end

#rvm_gem "passenger" do
#  user node['graylog2']['web_user']
#  version node['graylog2']['passenger_version']
#end


  bash "bunle install" do
    cwd "#{node['graylog2']['web_path']}/graylog2-web-interface"
    code <<-EOH
        gem install bundler
        bundle install
    EOH
  end

execute "graylog2-web-interface owner-change" do
    command "chown -Rf #{node['graylog2']['web_user']}:#{node['graylog2']['web_group']} #{node['graylog2']['web_path']}"
end

#rvm_shell "passenger module install" do
#  user node['graylog2']['web_user']
#  group node['graylog2']['web_group']
#  creates "#{node['graylog2']['web_path']}/.rvm/gems/#{node['graylog2']['ruby_version']}/gems/passenger-#{node['graylog2']['passenger_version']}/ext/apache2/mod_passenger.so"
#  cwd node['graylog2']['web_path']
#  code %{passenger-install-apache2-module --auto}
#end

#rvm_shell "run bundler install" do
#  user node['graylog2']['web_user']
#  group node['graylog2']['web_group']
#  cwd "#{node['graylog2']['web_path']}/current"
#  code %{bundle install}
#end

cron "Graylog2 send stream alarms" do
  user node['graylog2']['web_user']
  minute node['graylog2']['stream_alarms_cron_minute']
  action node['graylog2']['send_stream_alarms'] ? :create : :delete
  command "source ~/.bashrc && cd #{node['graylog2']['web_path']}/current && RAILS_ENV=production rake streamalarms:send"
end

cron "Graylog2 send stream subscriptions" do
  user node['graylog2']['web_user']
  minute node['graylog2']['stream_subscriptions_cron_minute']
  action node['graylog2']['send_stream_subscriptions'] ? :create : :delete
  command "source ~/.bashrc && cd #{node['graylog2']['web_path']}/current && RAILS_ENV=production rake subscriptions:send"
end

#apache_site "graylog2.conf" do
#  enable true
#end

#apache_site "000-default" do
#  enable false
#end
 
#service "apache2" do 
#  action :reload
#end

execute "disable iptables firewall" do
  command "iptables -F"
end
