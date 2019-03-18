name             'bacula-client'
maintainer       'Pavel Yudin'
maintainer_email 'pyudin@parallels.com'
license          'Apache 2.0'
description      'Installs/Configures bacula-client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://jira.prls.net/projects/DI/issues/' if respond_to?(:issues_url)
source_url 'https://git.prls.net/projects/COOK/repos/bacula-client' if respond_to?(:source_url)
version '1.1.8'

depends 'apt'
depends 'build-essential'
depends 'windows', '< 5.0'
depends 'seven_zip', '< 3.0'

supports 'amazon'
supports 'redhat'
supports 'centos'
supports 'scientific'
supports 'fedora'
supports 'debian'
supports 'ubuntu'
supports 'windows'

chef_version '< 13.0.0'
