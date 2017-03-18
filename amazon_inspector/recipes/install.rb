#
# Cookbook Name:: amazon_inspector
# Recipe:: install
#
# The MIT License (MIT)
#
# Copyright (c) 2017 apple_rom
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

tmp = Chef::Config['file_cache_path']

package 'gnupg2' # Used for cryptographic verification later on

# Download and GPG verification key for Amazon Inspector binary
remote_file "#{tmp}/inspector.gpg" do
    source              node['amazon_inspector']['gpgkey_url']
    notifies            :run, 'execute[import_key]', :immediately
end

#import key
execute 'import_key' do
  command "gpg2 --import #{tmp}/inspector.gpg"
  action :nothing
end

# Download the PGP cryptographic signature for the AWS inspector binary
remote_file "#{tmp}/install.sig" do
    source              node['inspector']['gpg_signature_url']
    action              :create_if_missing
end

# Download AWS Inspector installer script
remote_file "#{tmp}/inspector" do
    source              node['inspector']['installer_url']
end

# Install the AWS inspector binary *if* the installer script can be cryptographically verified to be from AWS
execute 'install-inspector' do
    command "bash #{tmp}/inspector -u false"
    only_if "/usr/bin/gpg2 --verify #{tmp}/install.sig #{tmp}/inspector"
    not_if do ::File.exist?('/opt/aws/awsagent/bin/awsagent') end
    notifies :start, "service[awsagent]", :immediately
end

# AWS inspector service
service 'awsagent' do
    supports :start => true, :stop => true, :status => true
    status_command '/opt/aws/awsagent/bin/awsagent status'
    action :nothing
end
