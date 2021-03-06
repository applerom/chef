name 'opensips'
maintainer 'apple_rom'
maintainer_email 'apple@rom.by'
license 'Apache 2.0'
description 'Installs opensips'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1'

%w(debian ubuntu arch redhat centos fedora scientific oracle amazon suse opensuse opensuseleap).each do |os|
  supports os
end

source_url "https://github.com/applerom/chef/#{name}" if respond_to?(:source_url)
issues_url "https://github.com/applerom/chef/#{name}/issues" if respond_to?(:issues_url)
chef_version '>= 11.0' if respond_to?(:chef_version)
