#
# Author:: Sebastian Wendel
# Cookbook Name:: graylog2
# Attribute:: default
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

# PROJECT SITE
default['graylog2']['project_url'] = "https://github.com/downloads/Graylog2"

# SERVER BINARY
default['graylog2']['server_version'] = "0.9.6p1-RC1"
default['graylog2']['server_file'] = "graylog2-server-#{node['graylog2']['server_version']}.tar.gz"
default['graylog2']['server_download'] = "#{node['graylog2']['project_url']}/graylog2-server/#{node['graylog2']['server_file']}"
default['graylog2']['server_checksum'] = "8bdddfc2ba9b8537f705f997461bd40d3a4091cd3f2b824622704a62ef1c0b96"

# WEB BINARY
default['graylog2']['web_version'] = "0.9.6p1-RC1"
default['graylog2']['web_file'] = "graylog2-web-interface-#{node['graylog2']['web_version']}.tar.gz"
default['graylog2']['web_download'] = "#{node['graylog2']['project_url']}/graylog2-web-interface/#{node['graylog2']['web_file']}"
default['graylog2']['web_checksum'] = "b2f8951a7effc1c3b617482bea0c79427f801f4034525adb163d041c34707fc1"

# SYSLOG4J BINARY
default['graylog2']['syslog4j_version'] = "0.9.46"
default['graylog2']['syslog4j_file'] = "syslog4j-#{node['graylog2']['syslog4j_version']}-bin.jar"
default['graylog2']['syslog4j_download'] = "http://syslog4j.org/downloads/#{node['graylog2']['syslog4j_file']}"
default['graylog2']['syslog4j_checksum'] = "9c9f44fb457fc3157f5dab7e9c94b027e964986545d8ee312380ae3f882a75ed"

# SERVER CONFIG
default['graylog2']['server_path'] = "/usr/share/graylog2-server"
default['graylog2']['server_user'] = "graylog2-server"
default['graylog2']['server_group'] = "graylog2-server"
default['graylog2']['server_storage'] = "elasticsearch"
default['graylog2']['server_port'] = 5140

# SYSLOG4J CONFIG
default['graylog2']['syslog4j_path'] = "/usr/share/syslog4j"

# WEB FRONTEND CONFIG
default['graylog2']['ruby_version'] = "ruby-1.9.3-p125"
default['graylog2']['passenger_version'] = "3.0.12"
default['graylog2']['web_path'] = "/home/graylog2-web" # note that rvm doesn't take any different
default['graylog2']['web_user'] = "graylog2-web"
default['graylog2']['web_group'] = "graylog2-web"

# EMAIL HOST CONFIG
default['graylog2']['email_type'] = "smtp"
default['graylog2']['email_host'] = "127.0.0.1"
default['graylog2']['email_tls'] = "true"
default['graylog2']['email_port'] = "25"
default['graylog2']['email_auth'] = "plain" # plain, login, cram_md5 - Comment out or remove to use no auth                         
default['graylog2']['email_user'] = nil
default['graylog2']['email_passwd'] = nil
default['graylog2']['email_domain'] = "#{node['fqdn']}"

# MONGODB CONFIG
default['graylog2']['mongo_host'] = "127.0.0.1"
default['graylog2']['mongo_port'] = 27017
default['graylog2']['mongo_maxconnections'] = 150
default['graylog2']['mongo_database'] = "graylog2"
default['graylog2']['mongo_auth'] = "false" 
default['graylog2']['mongo_user'] = nil
default['graylog2']['mongo_passwd'] = nil
default['graylog2']['mongo_replica'] = "localhost:27017,localhost:27018,localhost:27019"

# ELASTICSEARCH CONFIG
default['graylog2']['elastic_host'] = "127.0.0.1"
default['graylog2']['elastic_port'] = 9200
default['graylog2']['elastic_index'] = "graylog2"

# NOTIFI CRONS CONFIG
default['graylog2']['send_stream_alarms'] = true
default['graylog2']['send_stream_subscriptions'] = true
default['graylog2']['stream_alarms_cron_minute'] = "*/15"
default['graylog2']['stream_subscriptions_cron_minute'] = "*/15"
