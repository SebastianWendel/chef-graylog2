name "graylog2"
maintainer        "Sebastian Wendel, SourceIndex IT-Services"
maintainer_email  "packages@sourceindex.de"
license           "Apache 2.0"
description       "Installs and configures Graylog2"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.24"
recipe            "graylog2", "Installs and configures Graylog2"

%w{apt yum java logrotate}.each do |pkg|
  depends pkg
end

depends 'mongodb','= 0.0.0'
depends 'rvm', '~> 0.9.1'
depends 'apache2', '~> 1.2.0'
depends 'elasticsearch', '= 0.1.0'

%w{redhat centos ubuntu debian}.each do |os|
  supports os
end
