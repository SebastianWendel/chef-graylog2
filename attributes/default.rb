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

default['graylog2']['project_url'] = "https://github.com/downloads/Graylog2"
default['graylog2']['server_version'] = "0.9.6p1"
default['graylog2']['server_file'] = "graylog2-server-#{node['graylog2']['server_version']}.tar.gz"
default['graylog2']['server_download'] = "#{node['graylog2']['project_url']}/graylog2-server/#{node['graylog2']['server_file']}"
default['graylog2']['server_checksum'] = "8bdddfc2ba9b8537f705f997461bd40d3a4091cd3f2b824622704a62ef1c0b96"

default['graylog2']['servicewrapper_version'] = "3.5.14"
default['graylog2']['servicewrapper_url'] = "http://wrapper.tanukisoftware.com/download/#{node['graylog2']['servicewrapper_version']}/"
default['graylog2']['servicewrapper_file'] = "wrapper-delta-pack-#{node['graylog2']['servicewrapper_version']}.tar.gz"
default['graylog2']['servicewrapper_download'] = "#{node['graylog2']['servicewrapper_url']}/#{node['graylog2']['servicewrapper_file']}/"
default['graylog2']['servicewrapper_checksum'] = "8098efc957bd94b07f7da977d946c94a167a1977b4e32aac5ca552c99fe0c173"

default['graylog2']['web_version'] = "0.9.6p1"
default['graylog2']['web_file'] = "graylog2-web-interface-#{node['graylog2']['web_version']}.tar.gz"
default['graylog2']['web_download'] = "#{node['graylog2']['project_url']}/graylog2-web-interface/#{node['graylog2']['web_file']}"
default['graylog2']['web_checksum'] = "b2f8951a7effc1c3b617482bea0c79427f801f4034525adb163d041c34707fc1"

default['graylog2']['server_path'] = "/usr/share/graylog2-server"
default['graylog2']['server_etc'] = "/etc/graylog2-server"
default['graylog2']['server_pid'] = "/var/run/graylog2-server"
default['graylog2']['server_lock'] = "/var/lock/graylog2-server"
default['graylog2']['server_logs'] = "/var/log/graylog2-server"
default['graylog2']['server_user'] = "graylog2"
default['graylog2']['server_group'] = "graylog2"
default['graylog2']['server_port'] = 5140

default['graylog2']['ruby_version'] = "ruby-1.9.3-p125"
default['graylog2']['passenger_version'] = "3.0.12"
default['graylog2']['web_path'] = "/home/graylog2-web"
default['graylog2']['web_user'] = "graylog2-web"
default['graylog2']['web_group'] = "graylog2-web"

default['graylog2']['email_type'] = "smtp"
default['graylog2']['email_host'] = "127.0.0.1"
default['graylog2']['email_tls'] = "true"
default['graylog2']['email_port'] = "25"
default['graylog2']['email_auth'] = "plain"
default['graylog2']['email_user'] = nil
default['graylog2']['email_passwd'] = nil
default['graylog2']['email_address'] = "graylog2@#{node['fqdn']}" 
default['graylog2']['email_domain'] = node['fqdn']

default['graylog2']['mongo_host'] = "127.0.0.1"
default['graylog2']['mongo_port'] = 27017
default['graylog2']['mongo_maxconnections'] = 150
default['graylog2']['mongo_database'] = "graylog2"
default['graylog2']['mongo_auth'] = "false" 
default['graylog2']['mongo_user'] = "graylog2"
default['graylog2']['mongo_passwd'] = "graylog2"
default['graylog2']['mongo_replica'] = "localhost:27017,localhost:27018,localhost:27019"
default['graylog2']['mongo_collection'] = "50000000"

default['graylog2']['elastic_host'] = "127.0.0.1"
default['graylog2']['elastic_port'] = 9200
default['graylog2']['elastic_index'] = "graylog2"

default['graylog2']['send_stream_alarms'] = true
default['graylog2']['send_stream_subscriptions'] = true
default['graylog2']['stream_alarms_cron_minute'] = "*/15"
default['graylog2']['stream_subscriptions_cron_minute'] = "*/15"
