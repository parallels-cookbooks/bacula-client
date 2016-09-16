#
# Cookbook Name:: bacula-client
# Provider:: backup_mysql
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

require_relative 'provider_backup_database'

class Chef
  class Provider
    class Bacula
      class BackupDatabase
        class Mysql < Chef::Provider::Bacula::BackupDatabase
          def action_create
            create_prejob_script

            super
          end

          private

          def create_prejob_script
            mysqldump_string = "#!/bin/bash\n"
            mysqldump_string += 'mysqldump --single-transaction '
            mysqldump_string += "-u #{new_resource.user} " if new_resource.user
            mysqldump_string += "-p#{new_resource.password} " if new_resource.password
            mysqldump_string += "-h #{new_resource.host} " if new_resource.host
            mysqldump_string += "-P #{new_resource.port} " if new_resource.port
            mysqldump_string += "#{new_resource.backup_options.join(' ')} " if new_resource.backup_options
            mysqldump_string += new_resource.database.to_s
            mysqldump_string += " > #{new_resource.files[0]}" unless new_resource.bpipe
            mysqldump_string += "\n"

            file new_resource.prejob_script do
              action :create
              owner 'root'
              group 'root'
              mode '0750'
              content mysqldump_string
            end
          end
        end
      end
    end
  end
end
