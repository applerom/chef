name 'amazon-inspector'
maintainer 'apple_rom'
maintainer_email 'applerom@gmail.com'
license 'mit'
description 'Installs/Configures Amazon Inspector'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Issues` link
issues_url 'https://github.com/applerom/chef/amazon-inspector/issues' if respond_to?(:issues_url)

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Source` link
source_url 'https://github.com/applerom/chef/amazon-inspector' if respond_to?(:source_url)

##
#
supports 'debian'
supports 'ubuntu', '~> 12.04'
supports 'redhat'
supports 'centos', '~> 6.5'
supports 'amazon', '~> 2015.09' 
