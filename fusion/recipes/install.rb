#
# Cookbook:: fusion
# Recipe:: install
#
# Copyright:: 2017, apple_rom
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
myhome = node['fusion']['myhome']

%w(httpd24 php56 php56-cli php56-mysqlnd php-curl php-pear php56-gd php56-xmlrpc php56-mcrypt php56-pecl-memcache php56-pgsql php56-odbc).each do |mypackage|
    package mypackage do
        action :install
    end
end

Chef::Log.info("node['fusion']['git_repository']  = '#{node['fusion']['git_repository']}'")
Chef::Log.info("node['fusion']['www_dir']         = '#{node['fusion']['www_dir']}'")

unless node['fusion']['git_repository_ssh_key_path'].empty?
    Chef::Log.info("node['fusion']['git_repository_ssh_key_path'] = '#{node['fusion']['git_repository_ssh_key_path']}'")
    Chef::Log.info("node['fusion']['git_ssh_wrapper'] = '#{node['fusion']['git_ssh_wrapper']}'")
    file node['fusion']['git_ssh_wrapper_path'] do
        content "#!/bin/sh\nexec /usr/bin/ssh -i #{node['fusion']['git_repository_ssh_key_path']} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \"$@\""
        user "root"
        group "root"
        mode "0700"
    end   
end

git node['fusion']['www_dir'] do
    repository  node['fusion']['git_repository']
    ssh_wrapper node['fusion']['git_ssh_wrapper_path']
    revision node['fusion']['branch_name']
end

file node['fusion']['www_conf_path'] do
    content node['fusion']['www_conf']
end
    
if node['fusion']['symlinks_in_home']
    link myhome + "/fusion-conf" do
        to node['fusion']['www_conf_path']
    end
end

service 'httpd' do
    supports :start => true, :stop => true, :restart => true, :status => true
    action [ :enable, :restart ]
end