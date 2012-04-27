#
# Cookbook Name:: graylog2
# Recipe:: ruby
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

# VARIABLES LOCAL
ruby_version     = node['graylog2']['ruby_version']
web_path         = node['graylog2']['web_path']
web_user         = node['graylog2']['web_user']
web_group        = node['graylog2']['web_group']

# DEPENDENCIES COOKBOOKS
include_recipe "ruby_build"
include_recipe "rbenv::system"

# CREATE GROUPS
group web_group do
    system true
end

# CREATE USER
user web_user do
    home web_path
    comment "services user for graylog2-web-Interface"
    gid web_group
    shell "/bin/bash"
end

# INSTALL RUBY VIA RBENV
rbenv_ruby ruby_version do
  action :install
  user web_user
end

## SET RUBY VERSION TO THE USER
#rbenv_global ruby_version do
#  user web_user
#end

# INSTALL THE BUNDLER GEM
#rbenv_gem "bundler" do
#  rbenv_version ruby_version
#  action :install
#end

# SET RUBY VERSION TO THE USER
#rbenv_global ruby_version do
#    user web_user
#end

## INSTALL RUBY VIA RBENV
#rbenv_script "Install Ruby via RBEnv." do
#    user web_user
#    group web_group
#    name "bundler"
#    force true
#end

#  bash "Install Ruby version #{ruby_version}." do
#      code <<-EOH
#          su - #{web_user} -c "source #{web_path}/.rvm/scripts/rvm && rvm install #{ruby_version}"
#          su - #{web_user} -c "rvm use --default #{ruby_version}"
#          exit 0
#      EOH
#  end
#end

## INSTALL PASSENGER
#unless FileTest.exists?("#{web_path}/.rvm/rubies/default/bin/ruby")
#  bash "Set default Ruby version #{ruby_version}." do
#      code <<-EOH
#          su - #{web_user} -c "rvm use --default #{ruby_version}"
#          exit 0
#      EOH
#  end
#end

## INSTALL THE BUNDLER GEM
#bash "Install Passenger Bundle" do
#    code <<-EOH
#        su - #{web_user} -c "gem install passenger --no-rdoc --no-ri"
#        exit 0
#    EOH
#end


## INSTALL APACHE MODULE
##unless FileTest.exists?("#{web_path}/.rvm/rubies/default/bin/ruby")
#  bash "Install Apache Passenger Module." do
#      code <<-EOH
#          GEM_HOME=$(su - #{web_user} -c "echo \${GEM_HOME}") && export $GEM_HOME
#          MY_RUBY_HOME=$(su - #{web_user} -c "echo \${MY_RUBY_HOME}") && export $MY_RUBY_HOME
#          PATH=$(su - #{web_user} -c "echo \${PATH}") && export $PATH
#          rvm_env_string=$(su - #{web_user} -c "echo \${rvm_env_string}") && export $rvm_env_string
#          rvm_ruby_string=$(su - #{web_user} -c "echo \${rvm_ruby_string}") && export $rvm_string
#          GEM_PATH=$(su - #{web_user} -c "echo \${GEM_PATH}") && export $GEM_PATH
#          RUBY_VERSION=$(su - #{web_user} -c "echo \${RUBY_VERSION}") && export $RUBY_VERSION
#          rvmsudo passenger-install-apache2-module
#      EOH
#  end
##end

## INSTALL THE BUNDLER GEM
#bash "gem install bundler" do
#    code <<-EOH
#        su - #{web_user} -c "gem install bundler --no-rdoc --no-ri"
#        exit 0
#    EOH
#end

# INSTALL THE BUNDLER GEM
#bash "gem install bundler" do
#    code <<-EOH
#        gem install bundler --no-rdoc --no-ri
#    EOH
#end
