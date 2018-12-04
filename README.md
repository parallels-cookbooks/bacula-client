# bacula-client cookbook

## Description
The cookbook for installation bacula-client. You should use cookbook bacula-server to install a server.

This cookbook uses [windows](https://supermarket.chef.io/cookbooks/windows) cookbook as dependency. This can break your recipes if you use native `windows_package` resource.

## Requirements
### Cookbooks
- [apt](https://supermarket.chef.io/cookbooks/apt)
- [build-essential](https://supermarket.chef.io/cookbooks/build-essential)
- [windows](https://supermarket.chef.io/cookbooks/windows)

### Platforms
The following platforms are supported and tested uder test kitchen:

- Centos 6
- Ubuntu 14.04
- Windows server 2012 r2

This cookbook tested with bacula version 5.0 and 5.2.

## Attributes
|Attribute | Description | Type | Default|
|----------|-------------|------|--------|
|node['bacula']['databag_name']|Name of data bag where keeps bacula sensitive information. See below for format of data bag.|String |'bacula'|
|node['bacula']['databag_item']|Name of item of data bag.|String|'bacula'|
|node['bacula']['client']['cache']|Path of directory in which bacula will keep temporary backup files before send this files to a server.|String|'/var/cache/backup'|
|node['bacula']['client']['director_name']|Name of bacula director. It must be same as attribute on the bacula server.|String|'bacula-dir'|
|node['bacula']['client']['working_directory']|Path of the working directory.|String|platform-specific|
|node['bacula']['client']['pid_directory']|Path of the pid directory.|String|platform-specific|
|node['bacula']['client']['scripts']|Path of the directory in which bacula-client lwrp will be create scripts.|String|platform-specific|
|node['bacula']['client']['version']|Version of bacula package. **It is important to know that Bacula does not work if packets from different branches. For example: bacula-dir version 5.0 does not work with bacula-fd version 5.2.**|String|platform-specific|

## Recipes
- default.rb - install bacula-fd daemon.

## Resources/Providers
The purpose o resources in this cookbook to make the settings backups of different things in the same way. Actually you can make a backup of anything throught the resource `p_bacula_backup`.

### backup
This is the main resource. It is inherited by all other resources.

#### Actions

- :create: create backup job.

#### Attribute Parameters

|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|run|The attributes indicates when to run the backup job. It is array what containing strings. Format strings is the same format as the Run directive in the configuration schedule and can be found [here](http://www.bacula.org/5.2.x-manuals/en/main/main/Configuring_Director.html#SECTION001450000000000000000)|Array||
|files|List of files that need backup|Array|[]|
|prejob_script|Name of script what will be ran before job|String||
|postjob_script|Name of script what will be ran after job|String||
|options|Job options. Detailed description is [here](http://www.bacula.org/5.2.x-manuals/en/main/main/Configuring_Director.html#SECTION001470000000000000000)|hash|{ signature: 'MD5', compression: 'GZIP' }|
|exclude|List of files that will be excluded from backup|Array||
|bpipe|Flag enabling backup through bpipe.|Bolean|false|

**All of these attributess are present in all other resources.**

### backup_database
Generic resource for backup databases. With it you can make a backup of any database. For this you need to create prejob_script, which put your backup to `node['bacula']['client']['cache']/#{resource.name}.sql`. In fact this resource doesn't create prejob_script, unlike resources p_bacula_backup_mysql and p_bacula_backup_pg, so you must create this script your own. Because the script is not created, attributes that relate to database is not used.

#### Actions
- :create: create backup job.

#### Attribute Parameters
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|host|Database host|String||
|port|Database port|Integer||
|user|Database user who is allowed to do the backup|String||
|password|Password for backup user|String||
|database|Name of database which will be backuped|String||
|backup_options|Options which will be passed to the backup utility|Array||

**All of these attributess are present in all other resources related databases.**

### backup_mysql
Resource for backup mysql database. This resource is a wrapper around `backup_database` and has all the same attributes. It takes attributes and passes it to mysqlbackup in prejob_script.

### backup_pg
Resource for backup postgresql database. This resource is a wrapper around `backup_database` and has all the same attributes. It takes attributes and passes it to pg_dump in prejob_script.

### backup_chef
Resource uses `knife-ec-backup` ruby gem for backup chef server. It may to work only on the server where chef installed.

#### Actions
- :create: create backup job.


### backup_stash
Resource uses stash DIY backup.

#### Actions
- :create: create backup job.


### backup_systemstate
The resource for backup a system state of a windows server. This resource works only on a windows server. It is wrapper under `wbadmin` command.

#### Actions
- :create: create backup job.

#### Attribute Parameters

|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|files|This parameter is required. It specifies where `wbadmin` will backup a system state. In reality only pass the name of disk. `wbadmin` always saves backup in a directory X:\WindowsImageBackup, where X is a parameter passed into `-targetBackup` argument. Summarized: you must always pass a path like X:\WindowsImageBackup, where you may change only name of disk.|Array||

### Examples

- Backup the directory without subdir.

```
backup_files 'directory' do
  run ['Full mon at 3:00',
       'Incremental tue-sat at 3:00']
  files ['/directory']
  exclude ['/directory/tmp']
end
```

- Backup mysql database.

```
backup_mysql 'mysql_database' do
  run ['Full mon at 3:00']
  host '127.0.0.1'
  port 3306
  user 'root'
  password 'secret'
  backup_options ['-q']
end
```
- Backup postgresql database.

```
backup_pg 'postgresql' do
  run ['Full mon at 3:00']
  host '127.0.0.1'
  port 5432
  user 'root'
  password 'secret'
end
```

- Backup chef server.

```
backup_chef 'chefserver' do
  run ['Full mon at 3:00']
end
```

- Backup stash server.

```
backup_stash 'stash' do
  run ['Full mon at 3:00']
end
```

- Backup a system state of the windows server.

```
backup_systemstate 'system' do
  run ['Full mon at 3:00']
  files ['C:\WindowsImageBackup']
end
```

## Usage
### How it works
When you include client or default recipe in your wrapper, recipe installs bacula file daemon(client) and configures it.

Resources/Provides doesn't make backups, it just create pre and post job scripts, what runs by bacula. Also recipe sets node attribute with backup configuration.

To configure clients director recipe uses the chef search. It first deletes all files related with nodes are no longer search. Then recipe searches nodes on the role specified in the attribute `node['bacula']['director']['clients_role']`, gets attribute `node['bacula']['client']['backups']` and makes jobs according to them.

With this in mind, you must run chef-client after each addition backup lwrp or put chef-client in crontab for automation service discovery.

## Data bag
Data bag example:

```
{
  "id": "bacula",
  "fd_password": "fd_password",
  "db_password": "bacula",
  "db_user": "bacula",
  "postgres_root_password": "postgres",
  "console_password": "console_password",
  "sd_password": "sd_password"
}
```

Authors
---
- Author:: Pavel Yudin (pyudin@parallels.com)
