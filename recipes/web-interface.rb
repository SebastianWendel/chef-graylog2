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

# LOCAL VARIABLES
RUBY_VERSION      = node['GRAYLOG2']['RUBY_VERSION']
PASSENGER_VERSION = node['GRAYLOG2']['PASSENGER_VERSION']
WEB_PATH          = node['GRAYLOG2']['WEB_PATH']
WEB_USER          = node['GRAYLOG2']['WEB_USER']
WEB_GROUP         = node['GRAYLOG2']['WEB_GROUP']
WEB_DOWNLOAD      = node['GRAYLOG2']['WEB_DOWNLOAD']
WEB_VERSION       = node['GRAYLOG2']['WEB_VERSION']
WEB_FILE          = node['GRAYLOG2']['WEB_FILE']
WEB_CHECKSUM      = node['GRAYLOG2']['WEB_CHECKSUM']

# COOKBOOK DEPENDENCIES
case node['platform']
when "debian", "ubuntu"
  include_recipe 'apt'
when "centos","redhat"
  include_recipe 'yum'
else
    Chef::Log.warn("The #{node['platform']} is not yet not supported by this cookbook")
end
include_recipe "apache2"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_rewrite"

# PACKAGE DEPENDENCIES
package "postfix"
package "apache2-dev"
package "libcurl4-openssl-dev"

# ADD GRAYLOG2 APACHE CONFIG
template "Added Graylog2 Web-Interface Apache config." do
  path "/etc/apache2/sites-available/graylog2"
  source "apache2.erb"
  mode 0644
end

# DISABLE DEFAULT APACHE SITE
apache_site "000-default" do
  enable false
end

# ENABLE GRAYLOG2 APACHE SITE
apache_site "graylog2"

# CREATE GROUP
group WEB_GROUP do
  system true
end

# CREATE USER
user WEB_USER do
  home WEB_PATH
  gid WEB_GROUP
  comment "services user for thr graylog2-web-interface"
  supports :manage_home => true
  shell "/bin/bash"
end

# INSTALL SOURCE FILE IF NOT EXISTS
unless FileTest.exists?("#{WEB_PATH}/graylog2-web-interface-#{WEB_VERSION}")
  remote_file "#{Chef::Config[:file_cache_path]}/#{WEB_FILE}" do
    source WEB_DOWNLOAD
    checksum WEB_CHECKSUM
    action :create_if_missing
  end

  bash "install graylog2 sources #{WEB_FILE}" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -zxf #{WEB_FILE} -C #{WEB_PATH}
    EOH
  end

  link "#{WEB_PATH}/current" do
    to "#{WEB_PATH}/graylog2-web-interface-#{WEB_VERSION}"
  end

  log "Downloaded, installed and configured the Graylog2 Web binary files in #{WEB_PATH}/#{WEB_VERSION}." do
    action :nothing
  end
end

# CREATE GENERAL CONFIG-FILE
template "Create graylog2-web general config." do
  path "#{WEB_PATH}/current/config/general.yml"
  source "general.yml.erb"
  owner WEB_USER
  group WEB_GROUP
  mode 0644
end

# CREATE MONGODB CONFIG-FILE
template "Create graylog2-web mongodb config." do
  path "#{WEB_PATH}/current/config/mongoid.yml"
  source "mongoid.yml.erb"
  owner WEB_USER
  group WEB_GROUP
  mode 0644
end

# CREATE ELASTICSEARCH CONFIG-FILE
template "Create graylog2-web indexer config." do
  path "#{WEB_PATH}/current/config/indexer.yml"
  source "indexer.yml.erb"
  owner WEB_USER
  group WEB_GROUP
  mode 0644
end

# CREATE EMAIL-SERVER CONFIG-FILE
template "Create graylog2-web email config." do
  path "#{WEB_PATH}/current/config/email.yml"
  source "email.yml.erb"
  owner WEB_USER
  group WEB_GROUP
  mode 0644
end

# INSTALL USER ISOLATED RVM
node['rvm']['user_installs'] = [
  { 'user' => WEB_USER }
]

include_recipe "rvm::user_install"

# INSTALL USER ISOLATED RUBY
rvm_ruby RUBY_VERSION do
  user WEB_USER
end

# INSTALL BUNDLER GEM
rvm_gem "bundler" do
  user WEB_USER
end

# INSTALL PASSENGER GEM
rvm_gem "passenger" do
  user WEB_USER
  version PASSENGER_VERSION
end

# TAKE OWNERSHIP OF EVERTHING
execute "graylog2-web-interface owner-change" do
    command "chown -Rf #{WEB_USER}:#{WEB_GROUP} #{WEB_PATH}"
end

# INSTALL APACHE PASSENGER MODUL IF NOT EXISTS
rvm_shell "passenger module install" do
  user WEB_USER
  group WEB_GROUP
  creates "#{WEB_PATH}/.rvm/gems/#{RUBY_VERSION}/gems/passenger-#{PASSENGER_VERSION}/ext/apache2/mod_passenger.so"
  cwd WEB_PATH
  code %{passenger-install-apache2-module --auto}
end

# INSTALL ALL GEM DEPENDENCIES
rvm_shell "run bundler install" do
  user WEB_USER
  group WEB_GROUP
  cwd "#{WEB_PATH}/current"
  code %{bundle install}
end

# ADD STREAM ALARM CRON FOR THE USER
cron "Graylog2 send stream alarms" do
  user WEB_USER
  minute node['GRAYLOG2']['STREAM_ALARMS_CRON_MINUTE']
  action node['GRAYLOG2']['SEND_STREAM_ALARMS'] ? :create : :delete
  command "source ~/.bashrc && cd #{WEB_PATH}/current && RAILS_ENV=production rake streamalarms:send"
end

# ADD STREAM SUBSCRIPTION CRON FOR THE USER
cron "Graylog2 send stream subscriptions" do
  user WEB_USER
  minute node['GRAYLOG2']['STREAM_SUBSCRIPTIONS_CRON_MINUTE']
  action node['GRAYLOG2']['SEND_STREAM_SUBSCRIPTIONS'] ? :create : :delete
  command "source ~/.bashrc && cd #{WEB_PATH}/current && RAILS_ENV=production rake subscriptions:send"
end

# RELOAD APACHE FOR CONFIG CHANGES
service "apache2" do 
  action :reload
end

# NOTIFICATION FOR THE FINISHED INSTALLATION
log "Graylog2 Web-Interface s successfully installed and configured." do
  action :nothing
end
