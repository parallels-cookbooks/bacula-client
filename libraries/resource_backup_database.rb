#
# Cookbook Name:: bacula-client
# Resource:: backup_database
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
    class BackupDb < Chef::Resource::Backup
      def initialize(name, run_context = nil)
        super
        @resource_name = :backup_db
        @provider = Chef::Provider::Bacula::BackupDatabase
        @database = name
        @files = [::File.join(node['bacula']['client']['cache'], "#{@database}.sql")]
        @prejob_script = ::File.join(node['bacula']['client']['scripts'], "create_#{database}")
        @postjob_script = ::File.join(node['bacula']['client']['scripts'], "delete_#{database}")
      end

      def host(arg = nil)
        set_or_return(:host, arg, kind_of: String)
      end

      def port(arg = nil)
        set_or_return(:port, arg, kind_of: Integer)
      end

      def user(arg = nil)
        set_or_return(:user, arg, kind_of: String)
      end

      def password(arg = nil)
        set_or_return(:password, arg, kind_of: String)
      end

      def database(arg = nil)
        set_or_return(:database, arg, kind_of: String)
      end

      def backup_options(arg = nil)
        set_or_return(:backup_options, arg, kind_of: Array)
      end
    end
  end
end
