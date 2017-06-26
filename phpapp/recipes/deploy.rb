#
# Cookbook:: phpapp
# Recipe:: deploy
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

myhome = node['phpapp']['myhome']

if node['phpapp']['www_conf'].empty?
    template node['phpapp']['www_conf_path'] do
        source 'default.conf.erb'
    end
else
    file node['phpapp']['www_conf_path'] do
        content lazy { ::File.open(node['phpapp']['www_conf']).read }
        user "apache"
        group "apache"
    end
end
    
if node['phpapp']['symlinks_in_home']
    link myhome + "/phpapp-conf" do
        to node['phpapp']['www_conf_path']
    end
end

Chef::Log.info("node['phpapp']['git_repository']  = '#{node['phpapp']['git_repository']}'")
Chef::Log.info("node['phpapp']['www_dir']         = '#{node['phpapp']['www_dir']}'")

search("aws_opsworks_app").each do |app|
    Chef::Log.info("********** The app is '#{app}' **********")
    Chef::Log.info("********** The app app_id is '#{app['app_id']}' **********")
    Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")
    s3_path     = app['app_source']['url'].split('.s3.amazonaws.com')[1]
    s3_bucket   = app['app_source']['url'].split('.s3.amazonaws.com')[0].split('://')[1]
    Chef::Log.info("********** The app's URL is '#{s3_path}' **********")
    Chef::Log.info("********** The app's URL is '#{s3_bucket}' **********")
    Chef::Log.info("********** The app deploy is '#{app['deploy']}' **********")
    Chef::Log.info("********** The app enable_ssl is '#{app['enable_ssl']}' **********")
    Chef::Log.info("********** The app environment is '#{app['environment']}' **********")
    Chef::Log.info("********** The app name is '#{app['name']}' **********")
    Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
    Chef::Log.info("********** The app's type is '#{app['type']}' **********")
end

s3_file '/tmp/app_source.tar.gz' do
    remote_path s3_path
    bucket s3_bucket
end


unless node['phpapp']['git_repository_ssh_key_path'].empty?
    Chef::Log.info("node['phpapp']['git_repository_ssh_key_path'] = '#{node['phpapp']['git_repository_ssh_key_path']}'")
    Chef::Log.info("node['phpapp']['git_ssh_wrapper'] = '#{node['phpapp']['git_ssh_wrapper']}'")
    file node['phpapp']['git_ssh_wrapper_path'] do
        content "#!/bin/sh\nexec /usr/bin/ssh -i #{node['phpapp']['git_repository_ssh_key_path']} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \"$@\""
        user "root"
        group "root"
        mode "0700"
    end   
end

git node['phpapp']['www_dir'] do
    repository  node['phpapp']['git_repository']
    ssh_wrapper node['phpapp']['git_ssh_wrapper_path']
    revision node['phpapp']['branch_name']
end

service 'httpd' do
    action [ :restart ]
end