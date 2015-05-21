include_recipe 'bacula-client'

backup 'test' do
  run ['Full mon at 3:00',
       'Incremental tue-sat at 3:00']
end

backup_files 'test_files' do
  run ['Full mon at 3:00',
       'Incremental tue-sat at 3:00']
  files ['/tmp']
  exclude ['/tmp/kitchen']
end

backup_mysql 'mysql' do
  run ['Full mon at 3:00']
  host '127.0.0.1'
  port 3306
  user 'root'
  password 'secret'
  backup_options ['-q']
end

backup_pg 'postgresql' do
  run ['Full mon at 3:00']
  host '127.0.0.1'
  port 5432
  user 'root'
  password 'secret'
end

include_recipe 'chef-server'

backup_chef 'chefserver' do
  run ['Full mon at 3:00']
  user 'backup'
  url 'https://chef.loc'
  key <<-EOF
key
  EOF
end

node.set['stash']['backup']['backup_path'] = '/tmp/stash-backup-result'
node.set['stash']['backup_diy']['install_path'] = '/opt/atlassian/stash-diy-backup'

directory node['stash']['backup_diy']['install_path'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

backup_stash 'stash' do
  run ['Full mon at 3:00']
end
