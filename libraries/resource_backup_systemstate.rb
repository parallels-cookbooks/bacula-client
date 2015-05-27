#
# Cookbook Name:: bacula-client
# Resource:: backup_systemstate
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

require_relative 'resource_backup'

class Chef
  class Resource
    class BackupSystemstate < Chef::Resource::Backup
      def initialize(name, run_context = nil)
        super
        @resource_name = :backup_systemstate
        @provider = Chef::Provider::Bacula::BackupSystemState
        @prejob_script = ::File.join(node['bacula']['client']['scripts'], "create_#{name}.bat")
        @postjob_script = ::File.join(node['bacula']['client']['scripts'], "delete_#{name}.bat")
      end

      def files(arg = nil)
        set_or_return(:target, arg, kind_of: Array, required: true)
      end
    end
  end
end
