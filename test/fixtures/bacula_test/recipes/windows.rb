include_recipe 'bacula-client'

backup_systemstate 'system' do
  run ['Full mon at 3:00']
  files ['C:\WindowsImageBackup']
end
