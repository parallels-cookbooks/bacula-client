require 'spec_helper'

describe 'bacula-client::default' do
  it 'installs bacula-client version 5.0.0' do
    expect(package('bacula-client')).to be_installed.with_version('5.0.0')
  end

  it 'creates bacula-client config' do
    expect(file('/etc/bacula/bacula-fd.conf')).to be_file
  end
end
