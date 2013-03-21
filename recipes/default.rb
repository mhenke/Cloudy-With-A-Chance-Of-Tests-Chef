#
# Cookbook Name:: cloudy
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

file_name = node['cloudy']['download']['url'].split('/').last

node.set['cloudy']['owner'] = node['cf10']['installer']['runtimeuser'] if node['cloudy']['owner'] == nil

# Download cloudy

remote_file "#{Chef::Config['file_cache_path']}/#{file_name}" do
  source "#{node['cloudy']['download']['url']}"
  action :create_if_missing
  mode "0744"
  owner "root"
  group "root"
  not_if { File.directory?("#{node['cloudy']['install_path']}/cloudy") }
end

# Create the target install directory if it doesn't exist

directory "#{node['cloudy']['install_path']}" do
  owner node['cloudy']['owner']
  group node['cloudy']['group']
  mode "0755"
  recursive true
  action :create
  not_if { File.directory?("#{node['cloudy']['install_path']}") }
end

# Extract archive

script "install_cloudy" do
  interpreter "bash"
  user "root"
  cwd "#{Chef::Config['file_cache_path']}"
  code <<-EOH
unzip #{file_name} 
mv cloudy #{node['cloudy']['install_path']}
chown -R #{node['cloudy']['owner']}:#{node['cloudy']['group']} #{node['cloudy']['install_path']}/cloudy
EOH
  not_if { File.directory?("#{node['cloudy']['install_path']}/cloudy") }
end

# Set up ColdFusion mapping

execute "start_cf_for_cloudy_default_cf_config" do
  command "/bin/true"
  notifies :start, "service[coldfusion]", :immediately
end

coldfusion10_config "extensions" do
  action :set
  property "mapping"
  args ({ "mapName" => "/cloudy",
          "mapPath" => "#{node['cloudy']['install_path']}/cloudy"})
end

# Create a global apache alias if desired
template "#{node['apache']['dir']}/conf.d/global-cloudy-alias" do
  source "global-cloudy-alias.erb"
  owner node['apache']['user']
  group node['apache']['group']
  mode "0755"
  variables(
    :url_path => '/cloudy',
    :file_path => "#{node['cloudy']['install_path']}/cloudy"
  )
  only_if { node['cloudy']['create_apache_alias'] }
  notifies :restart, "service[apache2]"
end


