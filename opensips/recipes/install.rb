#
# Cookbook:: opensips
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

myhome = node['opensips']['myhome']

Chef::Log.info("node['platform'] = #{node['platform']}")
Chef::Log.info("node['opensips']['package_path'] = #{node['opensips']['package_path']}")

if node['opensips']['package_path'].empty?

    Chef::Log.info("create opensips user")
    user 'opensips' do
    end
    
    Chef::Log.info("node['opensips']['git_repository']  = '#{node['opensips']['git_repository']}'")
    Chef::Log.info("node['opensips']['src_dir']         = '#{node['opensips']['src_dir']}'")

    unless node['opensips']['git_repository_ssh_key_path'].empty?
        Chef::Log.info("node['opensips']['git_repository_ssh_key_path'] = '#{node['opensips']['git_repository_ssh_key_path']}'")
        Chef::Log.info("node['opensips']['git_ssh_wrapper'] = '#{node['opensips']['git_ssh_wrapper']}'")
        file node['opensips']['git_ssh_wrapper_path'] do
            content "#!/bin/sh\nexec /usr/bin/ssh -i #{node['opensips']['git_repository_ssh_key_path']} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \"$@\""
            user "root"
            group "root"
            mode "0700"
        end   
    end

    git node['opensips']['src_dir'] do
        repository  node['opensips']['git_repository']
        ssh_wrapper node['opensips']['git_ssh_wrapper_path']
        revision node['opensips']['branch_name']
    end

    bash 'make opensips' do
        ignore_failure = true
        cwd node['opensips']['src_dir']
        code <<-EOF
            make all
            make install
            ldconfig
        EOF
    end
    
    if node['opensips']['symlinks_in_home']
        link myhome + "/opensips-src" do
            to node['opensips']['src_dir']
        end
        link myhome + "/opensips-conf" do
            to opensips_conf
        end
    end

else
    Chef::Log.info("install from rpm '#{node['opensips']['package_path']}'")
    
    rpm_package "install from RPM-file" do
    source node['opensips']['package_path']
    action :install
    end
    
end
Chef::Log.info("node['opensips']['user']                = '#{node['opensips']['user']}'")
Chef::Log.info("node['opensips']['group']               = '#{node['opensips']['group']}'")
Chef::Log.info("node['opensips']['min-port']            = '#{node['opensips']['min-port']}'")
Chef::Log.info("node['opensips']['max-port']            = '#{node['opensips']['max-port']}'")
Chef::Log.info("node['opensips']['control_sock']        = '#{node['opensips']['control_sock']}'")
Chef::Log.info("node['opensips']['rttp_notify_socket']  = '#{node['opensips']['rttp_notify_socket']}'")
Chef::Log.info("node['opensips']['listen_addr']         = '#{node['opensips']['listen_addr']}'")
Chef::Log.info("node['opensips']['advertised_addr']     = '#{node['opensips']['advertised_addr']}'")
Chef::Log.info("node['opensips']['extra_opts']          = '#{node['opensips']['extra_opts']}'")

case node['platform_family']
    when 'debian'
        opensips_initd = 'init.d-deb.erb'
        opensips_conf = '/etc/default/opensips'
    when 'suse' ## ToDo
        opensips_initd = 'init.d-rpm.erb'
        opensips_conf = '/etc/sysconfig/opensips'
    when 'rhel'
        opensips_initd = 'init.d-rpm.erb'
        opensips_conf = '/etc/sysconfig/opensips'
    else
        opensips_initd = 'init.d-rpm.erb'
        opensips_conf = '/etc/sysconfig/opensips'
end
Chef::Log.info("opensips_initd = '#{opensips_initd}'")
Chef::Log.info("opensips_conf = '#{opensips_conf}'")

template opensips_conf do
    source 'default.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

template '/etc/init.d/opensips' do
    only_if { node['opensips']['package_path'].empty? }
    source opensips_initd
    owner 'root'
    group 'root'
    mode '0755'
end

file node['opensips']['rsyslog'] do
    content "local5.* #{node['opensips']['log']}"
    owner 'root'
    group 'root'
end

service 'rsyslog' do
    action [ :restart ]
end

service 'opensips' do
    supports :start => true, :stop => true, :restart => true, :status => true
    action [ :enable, :restart ]
end

