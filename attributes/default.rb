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
default['GRAYLOG2']['PROJECT_URL'] = "https://github.com/downloads/Graylog2"

# SERVER BINARY
default['GRAYLOG2']['SERVER_VERSION'] = "0.9.6p1"
default['GRAYLOG2']['SERVER_FILE'] = "graylog2-server-#{node['GRAYLOG2']['SERVER_VERSION']}.tar.gz"
default['GRAYLOG2']['SERVER_DOWNLOAD'] = "#{node['GRAYLOG2']['PROJECT_URL']}/GRAYLOG2-SERVER/#{node['GRAYLOG2']['SERVER_FILE']}"
default['GRAYLOG2']['SERVER_CHECKSUM'] = "8bdddfc2ba9b8537f705f997461bd40d3a4091cd3f2b824622704a62ef1c0b96"

# SERVICE-WRAPPER BINARY
default['GRAYLOG2']['SERVICEWRAPPER_VERSION'] = "3.5.14"
default['GRAYLOG2']['SERVICEWRAPPER_URL'] = "http://wrapper.tanukisoftware.com/download/#{node['GRAYLOG2']['SERVICEWRAPPER_VERSION']}/"
default['GRAYLOG2']['SERVICEWRAPPER_FILE'] = "wrapper-delta-pack-#{node['GRAYLOG2']['SERVICEWRAPPER_VERSION']}.tar.gz"
default['GRAYLOG2']['SERVICEWRAPPER_DOWNLOAD'] = "#{node['GRAYLOG2']['SERVICEWRAPPER_URL']}/#{node['GRAYLOG2']['SERVICEWRAPPER_FILE']}/"
default['GRAYLOG2']['SERVICEWRAPPER_CHECKSUM'] = "8098efc957bd94b07f7da977d946c94a167a1977b4e32aac5ca552c99fe0c173"

# WEB BINARY
default['GRAYLOG2']['WEB_VERSION'] = "0.9.6p1"
default['GRAYLOG2']['WEB_FILE'] = "graylog2-web-interface-#{node['GRAYLOG2']['WEB_VERSION']}.tar.gz"
default['GRAYLOG2']['WEB_DOWNLOAD'] = "#{node['GRAYLOG2']['PROJECT_URL']}/GRAYLOG2-WEB-INTERFACE/#{node['GRAYLOG2']['WEB_FILE']}"
default['GRAYLOG2']['WEB_CHECKSUM'] = "b2f8951a7effc1c3b617482bea0c79427f801f4034525adb163d041c34707fc1"

# SYSLOG4J BINARY
default['GRAYLOG2']['SYSLOG4J_VERSION'] = "0.9.46"
default['GRAYLOG2']['SYSLOG4J_FILE'] = "syslog4j-#{node['GRAYLOG2']['SYSLOG4J_VERSION']}-bin.jar"
default['GRAYLOG2']['SYSLOG4J_DOWNLOAD'] = "http://syslog4j.org/downloads/#{node['GRAYLOG2']['SYSLOG4J_FILE']}"
default['GRAYLOG2']['SYSLOG4J_CHECKSUM'] = "9c9f44fb457fc3157f5dab7e9c94b027e964986545d8ee312380ae3f882a75ed"

# SERVER CONFIG
default['GRAYLOG2']['SERVER_PATH'] = "/usr/share/graylog2-server"
default['GRAYLOG2']['SERVER_ETC'] = "/etc/graylog2-server"
default['GRAYLOG2']['SERVER_PID'] = "/var/run/graylog2-server"
default['GRAYLOG2']['SERVER_LOCK'] = "/var/lock/graylog2-server"
default['GRAYLOG2']['SERVER_LOGS'] = "/var/log/graylog2-server"
default['GRAYLOG2']['SERVER_USER'] = "graylog2"
default['GRAYLOG2']['SERVER_GROUP'] = "graylog2"
default['GRAYLOG2']['SERVER_PORT'] = 5140

# SYSLOG4J CONFIG
default['GRAYLOG2']['SYSLOG4J_PATH'] = "/usr/share/syslog4j"

# WEB FRONTEND CONFIG
default['GRAYLOG2']['RUBY_VERSION'] = "ruby-1.9.3-p125"
default['GRAYLOG2']['PASSENGER_VERSION'] = "3.0.12"
default['GRAYLOG2']['WEB_PATH'] = "/home/graylog2-web" # NOTE THAT RVM DOESN't take any different
default['GRAYLOG2']['WEB_USER'] = "graylog2-web"
default['GRAYLOG2']['WEB_GROUP'] = "graylog2-web"

# EMAIL HOST CONFIG
default['GRAYLOG2']['EMAIL_TYPE'] = "smtp"
default['GRAYLOG2']['EMAIL_HOST'] = "127.0.0.1"
default['GRAYLOG2']['EMAIL_TLS'] = "true"
default['GRAYLOG2']['EMAIL_PORT'] = "25"
default['GRAYLOG2']['EMAIL_AUTH'] = "plain" # plain, login, cram_md5 - Comment out or remove to use no auth                         
default['GRAYLOG2']['EMAIL_USER'] = nil
default['GRAYLOG2']['EMAIL_PASSWD'] = nil
default['GRAYLOG2']['EMAIL_ADDRESS'] = "graylog2@#{node['fqdn']}" 
default['GRAYLOG2']['EMAIL_DOMAIN'] = node['fqdn']

# MONGODB CONFIG
default['GRAYLOG2']['MONGO_HOST'] = "127.0.0.1"
default['GRAYLOG2']['MONGO_PORT'] = 27017
default['GRAYLOG2']['MONGO_MAXCONNECTIONS'] = 150
default['GRAYLOG2']['MONGO_DATABASE'] = "graylog2"
default['GRAYLOG2']['MONGO_AUTH'] = "false" 
default['GRAYLOG2']['MONGO_USER'] = "graylog2"
default['GRAYLOG2']['MONGO_PASSWD'] = "graylog2"
default['GRAYLOG2']['MONGO_REPLICA'] = "localhost:27017,localhost:27018,localhost:27019"
default['GRAYLOG2']['MONGO_COLLECTION'] = "50000000"

# ELASTICSEARCH CONFIG
default['GRAYLOG2']['ELASTIC_HOST'] = "127.0.0.1"
default['GRAYLOG2']['ELASTIC_PORT'] = 9200
default['GRAYLOG2']['ELASTIC_INDEX'] = "graylog2"

# NOTIFY CRONS CONFIG
default['GRAYLOG2']['SEND_STREAM_ALARMS'] = true
default['GRAYLOG2']['SEND_STREAM_SUBSCRIPTIONS'] = true
default['GRAYLOG2']['STREAM_ALARMS_CRON_MINUTE'] = "*/15"
default['GRAYLOG2']['STREAM_SUBSCRIPTIONS_CRON_MINUTE'] = "*/15"
