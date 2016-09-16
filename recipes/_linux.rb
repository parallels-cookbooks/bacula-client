#
# Cookbook Name:: bacula-client
# Recipe:: _linux
#
# Copyright 2015 Pavel Yudin
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

include_recipe 'apt' if platform_family?('debian')

package 'bacula-client' do
  action :install
  version node['bacula']['client']['version'] if node['bacula']['client']['version']
end

databag = data_bag_item(node['bacula']['databag_name'], node['bacula']['databag_item'])

directory node['bacula']['client']['scripts'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

directory node['bacula']['client']['cache'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory node['bacula']['client']['plugin_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/bacula/bacula-fd.conf' do
  source 'bacula-fd.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  variables(fd_password: databag['fd_password'])
  notifies :restart, 'service[bacula-fd]'
end

service 'bacula-fd' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
