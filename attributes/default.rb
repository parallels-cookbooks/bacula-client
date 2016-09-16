default['bacula']['databag_name'] = 'bacula'
default['bacula']['databag_item'] = 'bacula'

default['bacula']['client']['backups'] = []
default['bacula']['client']['cache'] = '/var/cache/backup'
default['bacula']['client']['director_name'] = 'bacula-dir'

case node['platform']
when 'redhat', 'centos', 'scientific', 'fedora', 'amazon', 'oracle'
  default['bacula']['client']['working_directory'] = '/var/spool/bacula'
  default['bacula']['client']['pid_directory'] = '/var/run'
  default['bacula']['client']['scripts'] = '/usr/bin/bacula'
  default['bacula']['client']['plugin_dir'] = if node['kernel']['machine'] == 'x86_64'
                                                '/usr/lib64/bacula'
                                              else
                                                '/usr/lib/bacula'
                                              end
when 'debian', 'ubuntu'
  default['bacula']['client']['working_directory'] = '/var/lib/bacula'
  default['bacula']['client']['pid_directory'] = '/var/run/bacula'
  default['bacula']['client']['scripts'] = '/usr/bin/bacula'
  default['bacula']['client']['plugin_dir'] = '/usr/lib/bacula'
when 'windows'
  default['bacula']['client']['working_directory'] = 'C:\\\\Program Files\\\\Bacula\\\\working'
  default['bacula']['client']['pid_directory'] = 'C:\\\\Program Files\\\\Bacula\\\\working'
  default['bacula']['client']['scripts'] = 'C:\\\\Program Files\\\\Bacula\\\\bin32'
  default['bacula']['client']['version'] = '5.0.3'
end
