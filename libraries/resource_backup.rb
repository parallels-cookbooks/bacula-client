#
# Cookbook Name:: bacula-client
# Resource:: backup
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

require 'chef/resource'

class Chef
  class Resource
    class Backup < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :backup
        @provider = Chef::Provider::Bacula::Backup
        @action = :create
        @allowed_actions = [:create]
        @files = []
        @options = { signature: 'MD5', compression: 'GZIP' }
        @bpipe = false
      end

      def run(arg = nil)
        set_or_return(:run, arg, kind_of: Array, required: true)
      end

      def files(arg = nil)
        set_or_return(:files, arg, kind_of: Array, required: true)
      end

      def prejob_script(arg = nil)
        set_or_return(:prejob_script, arg, kind_of: String)
      end

      def postjob_script(arg = nil)
        set_or_return(:postjob_script, arg, kind_of: String)
      end

      def options(arg = nil)
        set_or_return(:options, arg, kind_of: Hash)
      end

      def exclude(arg = nil)
        set_or_return(:exclude, arg, kind_of: Array)
      end

      def bpipe(arg = nil)
        set_or_return(:bpipe, arg, kind_of: [TrueClass, FalseClass])
      end
    end
  end
end
