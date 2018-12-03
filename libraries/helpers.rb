#
# Cookbook Name:: bacula-client
# Library:: helpers
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

module BaculaClient
  module Helper
    def backups_list
      backups = run_context.resource_collection.select { |r| r.is_a?(Chef::Resource::Backup) }
      backups.map! do |r|
        { name: r.name, run: r.run, files: r.files, prejob_script: r.prejob_script,
          postjob_script: r.postjob_script, exclude: r.exclude, options: r.options,
          bpipe: r.bpipe }
      end
      node.set['bacula']['client']['backups'] = backups
    end
  end
end

Chef::Recipe.send(:include, BaculaClient::Helper)
Chef::Resource.send(:include, BaculaClient::Helper)
