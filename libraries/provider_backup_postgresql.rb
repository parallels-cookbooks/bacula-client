#
# Cookbook Name:: bacula-client
# Provider:: backup_postgresql
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
        class Postgresql < Chef::Provider::Bacula::BackupDatabase
          def action_create
            create_prejob_script

            super
          end

          private

          def create_prejob_script
            pgdump_string = "#!/bin/bash\n"
            pgdump_string += "export PGPASSWORD='#{new_resource.password}'\n" if new_resource.password
            pgdump_string += 'pg_dump '
            pgdump_string += "-h #{new_resource.host} " if new_resource.host
            pgdump_string += "-U #{new_resource.user} " if new_resource.user
            pgdump_string += "-p #{new_resource.port} " if new_resource.port
            pgdump_string += "#{new_resource.backup_options.join(' ')} " if new_resource.backup_options
            pgdump_string += "-f #{new_resource.files[0]} "
            pgdump_string += "#{new_resource.database}\n"

            file new_resource.prejob_script do
              action :create
              owner 'root'
              group 'root'
              mode '0750'
              content pgdump_string
            end
          end
        end
      end
    end
  end
end
