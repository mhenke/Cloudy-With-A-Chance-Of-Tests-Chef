#
# Cookbook Name:: mxunit
# Recipe:: default
#
# Copyright 2012, Nathan Mische
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

# Install the unzip package

package "unzip" do
  action :install
end

file_name = node['mxunit']['download']['url'].split('/').last

node.set['mxunit']['owner'] = node['cf10']['installer']['runtimeuser'] if node['mxunit']['owner'] == nil

# Download MXUnit

remote_file "#{Chef::Config['file_cache_path']}/#{file_name}" do
  source "#{node['mxunit']['download']['url']}"
  action :create_if_missing
  mode "0744"
  owner "root"
  group "root"
  not_if { File.directory?("#{node['mxunit']['install_path']}/mxunit") }
end

# Create the target install directory if it doesn't exist

directory "#{node['mxunit']['install_path']}" do
  owner node['mxunit']['owner']
  group node['mxunit']['group']
  mode "0755"
  recursive true
  action :create
  not_if { File.directory?("#{node['mxunit']['install_path']}") }
end

# Extract archive

script "install_mxunit" do
  interpreter "bash"
  user "root"
  cwd "#{Chef::Config['file_cache_path']}"
  code <<-EOH
unzip #{file_name} 
mv mxunit #{node['mxunit']['install_path']}
chown -R #{node['mxunit']['owner']}:#{node['mxunit']['group']} #{node['mxunit']['install_path']}/mxunit
EOH
  not_if { File.directory?("#{node['mxunit']['install_path']}/mxunit") }
end

# Set up ColdFusion mapping

execute "start_cf_for_mxunit_default_cf_config" do
  command "/bin/true"
  notifies :start, "service[coldfusion]", :immediately
end

coldfusion10_config "extensions" do
  action :set
  property "mapping"
  args ({ "mapName" => "/mxunit",
          "mapPath" => "#{node['mxunit']['install_path']}/mxunit"})
end

# Create a global apache alias if desired
template "#{node['apache']['dir']}/conf.d/global-mxunit-alias" do
  source "global-mxunit-alias.erb"
  owner node['apache']['user']
  group node['apache']['group']
  mode "0755"
  variables(
    :url_path => '/mxunit',
    :file_path => "#{node['mxunit']['install_path']}/mxunit"
  )
  only_if { node['mxunit']['create_apache_alias'] }
  notifies :restart, "service[apache2]"
end


