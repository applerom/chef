#
# Cookbook:: fusion
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

myhome = node['fusion']['myhome']

if node['fusion']['www_conf'].empty?
    template node['fusion']['www_conf_path'] do
        source 'default.conf.erb'
    end
else
    file node['fusion']['www_conf_path'] do
        content lazy { ::File.open(node['fusion']['www_conf']).read }
        user "apache"
        group "apache"
    end
end
    
if node['fusion']['symlinks_in_home']
    link myhome + "/fusion-conf" do
        to node['fusion']['www_conf_path']
    end
end


search("aws_opsworks_app").each do |app|
    Chef::Log.info("********** The app is '#{app}' **********")
    Chef::Log.info("********** The app app_id is '#{app['app_id']}' **********")
    Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")
    Chef::Log.info("********** The app deploy is '#{app['deploy']}' **********")
    Chef::Log.info("********** The app enable_ssl is '#{app['enable_ssl']}' **********")
    Chef::Log.info("********** The app environment is '#{app['environment']}' **********")
    Chef::Log.info("********** The app name is '#{app['name']}' **********")
    Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
    Chef::Log.info("********** The app's type is '#{app['type']}' **********")
end

unless node['fusion']['nfs_path'].empty?
    aws_nfs =
        case node['platform_family']
            when 'debian'
                'nfs-common'
            when 'suse'
                'nfs-utils'
            when 'rhel'
                'nfs-utils'
            else
                'nfs-utils'
        end

    package aws_nfs do
        action :install
    end

    mount node['fusion']['www_dir'] do
        device node['fusion']['nfs_path']
        fstype node['fusion']['nfs_type']
        options node['fusion']['nfs_options']
        pass node['fusion']['nfs_pass_fsck']
        action [:mount, :enable]
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

service 'httpd' do
    action [ :restart ]
end