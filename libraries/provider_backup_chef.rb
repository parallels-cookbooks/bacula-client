#
# Cookbook Name:: bacula-client
# Provider:: backup_chef
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
      class BackupChef < Chef::Provider::Bacula::Backup
        include Chef::DSL::IncludeRecipe

        def action_create
          include_recipe 'build-essential::default'

          # I did it, because chef_gem not support the setting of environment variables.
          execute 'install knife-ec-backup gem' do
            command '/opt/chef/embedded/bin/gem install knife-ec-backup -q --no-rdoc --no-ri'
            environment 'PATH' => "#{ENV["PATH"]}:/opt/opscode/embedded/bin",
                        'C_INCLUDE_PATH' => '/opt/opscode/embedded/postgresql/9.2/include'
            action :run
            not_if '/opt/chef/embedded/bin/gem list | grep "knife-ec-backup"'
          end

          super
          create_prejob_script
          create_postjob_script
        end

        private

        def create_postjob_script
          file new_resource.postjob_script do
            action :create
            owner 'root'
            group 'root'
            mode '0750'
            content "#!/bin/bash\nrm -rf #{new_resource.files[0]}\n"
          end
        end

        def create_prejob_script
          backup_string = "#!/bin/bash\n"
          backup_string += 'knife ec backup '
          backup_string += "#{new_resource.files[0]} "
          backup_string += "-s #{new_resource.url} " if new_resource.url
          backup_string += "> /dev/null\n"

          file new_resource.prejob_script do
            action :create
            owner 'root'
            group 'root'
            mode '0750'
            content backup_string
          end
        end
      end
    end
  end
end
