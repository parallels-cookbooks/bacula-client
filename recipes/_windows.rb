#
# Cookbook Name:: bacula-client
# Recipe:: _windows
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

databag = data_bag_item(node['bacula']['databag_name'], node['bacula']['databag_item'])

remote_file ::File.join(Chef::Config[:file_cache_path], 'bacula-client.exe') do
  action :create_if_missing
  source "http://downloads.sourceforge.net/project/bacula/Win32_64/#{node['bacula']['client']['version']}/bacula-win64-#{node['bacula']['client']['version']}.exe"
end

execute 'bacula client installation' do
  command "#{::File.join(Chef::Config[:file_cache_path], 'bacula-client.exe')} /S"
  action :run
  not_if { ::File.directory?('C:\\Program Files\\Bacula') }
end

template 'C:\Program Files\Bacula\bacula-fd.conf' do
  source 'bacula-fd.conf.erb'
  mode '0644'
  variables fd_password: databag['fd_password']
  notifies :restart, 'service[Bacula-fd]'
end

service 'Bacula-fd' do
  supports status: true, start: true, stop: true, restart: true
  action [:start, :enable]
end
