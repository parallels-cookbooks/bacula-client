#!/usr/bin/env rake

require 'foodcritic'
require 'chef-dk/cli'
require 'cookstyle'
require 'kitchen/rake_tasks'
require 'rubocop/rake_task'

# Executes "chef `command>`" localy for all files in `glob_path`
# `glob_path` is expanded, so it could contain wildcards to run run a bunch job.
#
# @example Run "chef install" for all files in glob "policies/*.rb"
#   execute_chefdk('policies/*.rb', 'install')
#
# @param glob_path [String] Path to policyfiles
# @param command [String] arguments to pass to the "chef" command.
#   Should not contain executable name and policyfile path.
def execute_chefdk(glob_path, command)
  Dir.glob(glob_path).each do |file|
    args = command.split(' ') << file
    cli = ChefDK::CLI.new(args)
    subcommand_name, *subcommand_params = cli.argv
    subcommand = cli.instantiate_subcommand(subcommand_name)
    subcommand.run_with_default_options(subcommand_params)
  end
end

# Style tests. Cookstyle (rubocop) and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any'],
      progress: true,
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each(&:destroy)
    Kitchen::Config.new.instances.each(&:converge)
    Kitchen::Config.new.instances.each(&:verify)
    Kitchen::Config.new.instances.each(&:destroy)
  end
end

namespace :policyfile do
  desc 'Run "chef install" for all files `policies/*.rb`'
  task :install do
    execute_chefdk('policies/*.rb', 'install')
  end

  desc 'Run "chef update" for all files `policies/*.rb`'
  task :update do
    execute_chefdk('policies/*.rb', 'update')
  end

  desc 'Run "chef update -a" for all files `policies/*.rb`'
  task :update_a do
    execute_chefdk('policies/*.rb', 'update -a')
  end

  desc 'Run "chef push production" for all files `policies/*.rb`'
  task :push_production do
    execute_chefdk('policies/*.rb', 'push production')
  end
end

# Default
task default: ['style', 'policyfile:install', 'integration:vagrant']
