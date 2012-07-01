# Description #

A cookbook for Opscodes Chef open-source systems integration framework to install and configure the Graylog2 Server and Web-Interface.

Graylog2 is an open source log management solution that stores your logs in ElasticSearch. It consists of a server written in Java that accepts your syslog messages via TCP, UDP or AMQP and stores it in the database. The second part is a web interface that allows you to manage the log messages from your web browser.

http://www.graylog2.org

# Requirements #

## Platform ##
The Cookbooks is build for the following platforms:
* Debian, Ubuntu
* CentOS, Red Hat

The Cookbooks is tested on the following platforms:
* Debian 6.05
* Ubuntu 10.04-4, 12.04
* CentOS 5.8, 6.2

## Cookbooks ##
To install the coockbook use the following commands, depending to your platform:

    gem install librarian
    cd chef-repo
    librarian-chef init

    cat >> Cheffile <<END_OF_CHEFFILE
    cookbook 'apt', :git => 'https://github.com/opscode-cookbooks/apt.git'
    cookbook 'yum', :git => 'https://github.com/opscode-cookbooks/yum.git'
    cookbook 'java', :git => 'https://github.com/opscode-cookbooks/java.git'
    cookbook 'elasticsearch', :git => 'https://github.com/sebwendel/chef-elasticsearch.git'
    cookbook 'mongodb', :git => 'https://github.com/sebwendel/chef-mongodb.git'
    cookbook 'rvm', :git => 'https://github.com/fnichol/chef-rvm.git'
    cookbook 'apache2', :git => 'https://github.com/opscode-cookbooks/apache2.git'
    cookbook 'graylog2', :git => 'https://github.com/sebwendel/chef-graylog2.git'
    END_OF_CHEFFILE

    librarian-chef install

    knife cookbook upload java graylog2 elasticsearch mongodb rvm apache2

# Recipes #
Just include the graylog2 cookbock in your runlist or server role with the following hash table:

    {
      "run_list": [
        "recipe[graylog2]"
      ]
    }

This will install the java dependencie, the graylog2 server and the declared plugins.

# Attributes #
* `node['graylog2']['interface']` - "127.0.0.1" limit to local access, default is "0.0.0.0".
* `node['graylog2']['port']` - database listener port, default is "27017".

# Usage #
1. download and install all dependencies
1. override the attributes if necessary
1. check all interface, port and authentication config
1. add the recipe to your nodes runlist 

    {
      "run_list": [
        "recipe[graylog2]"
      ]
    }

If you use all dependencies from the described sources the cookbook should work out of the box without any changes of attributes.

# Limitations #
* For now there is no authentication on the backend side.

# ToDos and Issues #
If you have any questions or recommendations just create a issue at the github repository.
If you want to help have a lock at the github issues section, patches are more than welcome.

# License and Author #

Author: Sebastian Wendel, (<packages@sourceindex.de>)

Copyright: 2012, SourceIndex IT-Serives

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
