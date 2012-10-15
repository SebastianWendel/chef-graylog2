name "graylog2"
maintainer        "Sebastian Wendel, SourceIndex IT-Services"
maintainer_email  "packages@sourceindex.de"
license           "Apache 2.0"
description       "Installs and configures Graylog2"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.23"
recipe            "graylog2", "Installs and configures Graylog2"

%w{apt yum java rvm apache2 mongodb elasticsearch logrotate}.each do |pkg|
  depends pkg
end

%w{redhat centos ubuntu debian}.each do |os|
  supports os
end
