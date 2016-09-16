#
# Cookbook Name:: bacula-client
# Provider:: backup_systemstate
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

require_relative 'provider_backup'

class Chef
  class Provider
    class Bacula
      class BackupSystemState < Chef::Provider::Bacula::Backup
        include Chef::DSL::IncludeRecipe

        def action_create
          super

          windows_feature 'WindowsServerBackup' do
            action :install
          end

          registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wbengine\SystemStateBackup' do
            values [{
              name: 'AllowSSBToAnyVolume',
              type: :dword,
              data: 1
            }]
            action :create
          end

          create_prejob_script
          create_postjob_script
        end

        private

        def create_postjob_script
          file new_resource.postjob_script do
            rights :full_control, %w(Administrators System)
            content "rmdir /S /Q #{new_resource.files[0]}"
          end
        end

        def create_prejob_script
          disk = new_resource.files[0].split(':')[0]

          backup_string = 'wbadmin start systemstatebackup '
          backup_string += "-backupTarget:#{disk}: "
          backup_string += '-quiet'

          file new_resource.prejob_script do
            rights :full_control, %w(Administrators System)
            content backup_string
          end
        end
      end
    end
  end
end
