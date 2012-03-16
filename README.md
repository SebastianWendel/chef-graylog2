Description
===========

Installs and configures a Graylog2 server on Ubuntu systems (10.04 only at present).

This is a Chef re-engineering of the Sean Porter (@portertech) Linode StackScript for graylog2, 
available here:  http://is.gd/cWA0w9

Recipes
=======

default
-------

Downloads, installs, configures and starts the java graylog2-server.  Does *not* install 
the web-interface. Uses resources from the Opscode "apt" cookbook to add a repo from which
it pulls MongoDB.

web-interface
-------------

First calls graylog2::default to install the server.  Then downloads, installs, and configures 
the rails-based graylog2-web-interface.  Also installs a local mysql-server to support it.  

apache2
-------

First calls graylog2::web-interface to ensure that both the server and webui are available.  Then
calls the Opscode "apache2" cookbook to install apache2 before (itself) installing the apache2
mod_passenger module via apt, and finally calling apache_site to configure apache2 to serve the
graylog2 web interface.


Usage
=====

This cookbook can be called via any of its three recipes.  To get a fully working graylog2 server, call
graylog::apache2 - it will set up the full stack, with apache2 installed to serve the Rails app.  If
you use another webserver, you can call graylog2:web-interface, which will install the base server 
and the web-interface rails app, but not configure a webserver to serve it.

Note that this cookbook makes lots of assumptions about defaults, and does things like install a local
mysql server with no root password (doh).  Do be sure to tweak this for your comfort and security
before using it in production.

Also note - this cookbook does *not* switch off any local logging system.  That means that if you are
trying to get Graylog2 to 'catch' syslog messages, you may have to disable your local rsyslog or 
syslog-ng as they may have already snabbled up port 514.  The cookbook *does* sudo-start Graylog2, so 
it should be able to bind udp/514 at startup.  Stop/Start/restart Graylog2 using the installed init.d
script (/etc/init.d/graylog2 stop|start|restart).  TODO: convert to an upstart job.

Also also note - I have pegged the version of Bundler this cookbook installs at 1.0.3 due to requirements
of our infrastructure.  If you already use a different bundler, or want to use the latest, remove the
"version" statement from the gem-package "bundler" resource in web-interface.rb.

License and Author
==================

Author:: J.B. Zimmerman (<jzimmerman@mdsol.com>)

Copyright 2011 Medidata Solutions, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

