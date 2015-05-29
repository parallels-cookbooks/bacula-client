name             'bacula-client'
maintainer       'Pavel Yudin'
maintainer_email 'pyudin@parallels.com'
license          'Apache 2.0'
description      'Installs/Configures bacula-client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'apt'
depends 'build-essential'
depends 'windows'

supports 'amazon'
supports 'redhat'
supports 'centos'
supports 'scientific'
supports 'fedora'
supports 'debian'
supports 'ubuntu'
supports 'windows'
