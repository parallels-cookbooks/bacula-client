#
# Cookbook Name:: bacula-client
# Provider:: backup
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

require 'chef/provider'

class Chef
  class Provider
    class Bacula
      class Backup < Chef::Provider::LWRPBase
        use_inline_resources if defined?(use_inline_resources)

        def load_current_resource
          @current_resource ||= Chef::Resource::Backup.new(new_resource.name)
          @current_resource
        end

        def action_create
        end
      end
    end
  end
end
