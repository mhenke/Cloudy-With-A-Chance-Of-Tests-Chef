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

# Download MXUnit

remote_file "#{Chef::Config['file_cache_path']}/mxunit-2.1.1.zip" do
  source "#{node['mxunit']['download']['url']}"
  action :create_if_missing
  mode "0744"
  owner "root"
  group "root"
  not_if { File.directory?("#{node['mxunit']['install_path']}/mxunit") }
end

# Extract archive

script "install_mxunit" do
  interpreter "bash"
  user "root"
  cwd "#{Chef::Config['file_cache_path']}"
  code <<-EOH
unzip mxunit-2.1.1.zip 
mv mxunit #{node['mxunit']['install_path']}
chown -R nobody:bin #{node['mxunit']['install_path']}/mxunit
EOH
  not_if { File.directory?("#{node['mxunit']['install_path']}/mxunit") }
end

# Set up ColdFusion mapping

execute "start_cf_for_mxunit_default_cf_config" do
  command "/bin/true"
  notifies :start, "service[coldfusion]", :immediately
end

coldfusion902_config "extensions" do
  action :set
  property "mapping"
  args ({ "mapName" => "/mxunit",
          "mapPath" => "#{node['mxunit']['install_path']}/mxunit"})
end


