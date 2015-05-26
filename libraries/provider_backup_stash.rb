#
# Cookbook Name:: bacula-client
# Provider:: backup_stash
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
      class BackupStash < Chef::Provider::Bacula::Backup
        def action_create
          super
          create_postjob_script
        end

        private

        def create_postjob_script
          file new_resource.postjob_script do
            action :create
            owner 'root'
            group 'root'
            mode '0750'
            content "#!/bin/bash\nrm -rf #{::File.join(new_resource.files[0], '*')}\n"
          end
        end
      end
    end
  end
end
