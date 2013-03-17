Description
===========

Installs the Cloudly With A Chance of Tests for ColdFusion.

Attributes
==========

* `node['cloudy']['install_path']` (Default is /vagrant/wwwroot)
* `node[''cloudy']['download']['url']` (Default is https://github.com/mhenke/Cloudy-With-A-Chance-Of-Tests/archive/develop.zip)

Usage
=====

On ColdFusion server nodes:

    include_recipe "cloudy"