default.graylog2.java_home = ENV['JAVA_HOME']
default.graylog2.basedir = "/usr/share/graylog2"
default.graylog2.user = "graylog2"

default.graylog2.server.version = "0.9.6"
default.graylog2.web_interface.version = "0.9.6"

case node[:platform]
when "debian", "ubuntu"
  default.graylog2.www_user = "www-data"
  default.graylog2.www_group = "www-data"
end

default.graylog2.syslog4j_version = "0.9.46"
default.graylog2.syslog4j_download = "http://syslog4j.org/downloads/syslog4j-#{node[:graylog2][:syslog4j_version]}-bin.jar"

default.graylog2.port = 514
default.graylog2.collection_size = 50000000
default.graylog2.send_stream_alarms = true
default.graylog2.send_stream_subscriptions = true
default.graylog2.stream_alarms_cron_minute = "*/15"
default.graylog2.stream_subscriptions_cron_minute = "*/15"
