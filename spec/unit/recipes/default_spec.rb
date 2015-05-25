#
# Cookbook Name:: bacula-client
# Spec:: default
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

require 'spec_helper'

describe 'bacula-client::default' do
  platforms = {
    'redhat' => ['6.5'],
    'centos' => ['6.5'],
    'ubuntu' => ['14.04']
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "When all attributes are default, on an #{platform} version #{version}" do
        let(:chef_run) do
          runner = ChefSpec::ServerRunner.new(platform: platform, version: version) do |_node, server|
            server.create_data_bag('bacula',
                                   'bacula' => {
                                     fd_password: 'fd_password'
                                   }
            )
          end
          runner.converge(described_recipe)
        end

        it 'converges successfully' do
          chef_run
        end

        it 'installs package with bacula-client' do
          expect(chef_run).to install_package('bacula-client')
        end

        it 'creates script directory' do
          expect(chef_run).to create_directory('/usr/bin/bacula')
        end

        it 'creates bacula-client config' do
          expect(chef_run).to create_template('/etc/bacula/bacula-fd.conf')
        end

        it 'creates temporary directory for backups' do
          expect(chef_run).to create_directory('/var/cache/backup')
        end

        it 'runs and enables service bacula-fd' do
          expect(chef_run).to start_service('bacula-fd')
          expect(chef_run).to enable_service('bacula-fd')
        end

        it 'runs ruby block' do
          expect(chef_run).to run_ruby_block('updating the list of backups')
        end
      end
    end
  end

  context 'When all attributes are default, on an windows version 2012r2' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2') do |_node, server|
        server.create_data_bag('bacula',
                               'bacula' => {
                                 fd_password: 'fd_password'
                               }
        )
      end
      runner.converge(described_recipe)
    end

    it 'installs package with bacula client' do
      expect(chef_run).to run_execute('bacula client installation')
    end

    it 'enables and starts Bacula-fd service' do
      expect(chef_run).to enable_service('Bacula-fd')
      expect(chef_run).to start_service('Bacula-fd')
    end

    it 'creates bacula-client config' do
      expect(chef_run).to create_template('C:\Program Files\Bacula\bacula-fd.conf')
    end

    it 'runs ruby block' do
      expect(chef_run).to run_ruby_block('updating the list of backups')
    end
  end
end
