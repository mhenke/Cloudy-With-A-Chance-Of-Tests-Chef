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

# Download cloudy

remote_file "#{Chef::Config['file_cache_path']}/Cloudy-With-A-Chance-Of-Tests-develop.zip" do
  source "#{node['cloudy']['download']['url']}"
  action :create_if_missing
  mode "0744"
  owner "root"
  group "root"
  not_if { File.directory?("#{node['cloudy']['install_path']}/cloudy") }
end

# Extract archive

script "install_cloudy" do
  interpreter "bash"
  user "root"
  cwd "#{Chef::Config['file_cache_path']}"
  code <<-EOH
unzip Cloudy-With-A-Chance-Of-Tests-develop.zip
mv Cloudy-With-A-Chance-Of-Tests-develop #{node['cloudy']['install_path']}
chown -R nobody:bin #{node['cloudy']['install_path']}
EOH
  not_if { File.directory?("#{node['cloudy']['install_path']}") }
end

# Set up ColdFusion mapping

execute "start_cf_for_cloudy_default_cf_config" do
  command "/bin/true"
  notifies :start, "service[coldfusion]", :immediately
end