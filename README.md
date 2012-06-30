# Description #

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
To install the coockbook use the following commands:

    gem install librarian
    cd chef-repo
    librarian-chef init

    cat >> Cheffile <<END_OF_CHEFFILE
    cookbook 'java', :git => 'https://github.com/opscode-cookbooks/java.git'
    cookbook 'graylog2', :git => 'https://github.com/sebwendel/chef-graylog2.git'
    cookbook 'elasticsearch', :git => 'https://github.com/sebwendel/chef-elasticsearch.git'
    cookbook 'mongodb', :git => 'https://github.com/sebwendel/chef-mongodb.git'
    cookbook 'rvm', :git => 'https://github.com/fnichol/chef-rvm.git'
    cookbook 'apache2', :git => 'https://github.com/opscode-cookbooks/apache2.git'
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

# Limitations #
At the moment the cookbook just contains a single node procedure.

# ToDos and Issues #
Have a lock at the github issues section. There's still some work to do, patches are more than welcome.

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
