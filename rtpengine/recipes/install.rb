#
# Cookbook:: rtpengine
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

myhome = node['rtpengine']['myhome']

%w(gcc glib2-devel glib2-fam glibc-static glibc-utils xmlrpc-c xmlrpc-c-devel libevent-devel zlib-devel openssl-devel pcre-devel libpcap libpcap-devel).each do |mypackage|
    package mypackage do
        action :install
    end
end

Chef::Log.info("node['platform'] = #{node['platform']}")
Chef::Log.info("node['rtpengine']['package_path'] = #{node['rtpengine']['package_path']}")

if node['rtpengine']['package_path'].empty?

    Chef::Log.info("create rtpengine user")
    user 'rtpengine' do
    end
    
    Chef::Log.info("node['rtpengine']['git_repository']  = '#{node['rtpengine']['git_repository']}'")
    Chef::Log.info("node['rtpengine']['src_dir']         = '#{node['rtpengine']['src_dir']}'")

    unless node['rtpengine']['git_repository_ssh_key_path'].empty?
        Chef::Log.info("node['rtpengine']['git_repository_ssh_key_path'] = '#{node['rtpengine']['git_repository_ssh_key_path']}'")
        Chef::Log.info("node['rtpengine']['git_ssh_wrapper'] = '#{node['rtpengine']['git_ssh_wrapper']}'")
        file node['rtpengine']['git_ssh_wrapper_path'] do
            content "#!/bin/sh\nexec /usr/bin/ssh -i #{node['rtpengine']['git_repository_ssh_key_path']} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \"$@\""
            user "root"
            group "root"
            mode "0700"
        end   
    end

    git node['rtpengine']['src_dir'] do
        repository  node['rtpengine']['git_repository']
        ssh_wrapper node['rtpengine']['git_ssh_wrapper_path']
        revision node['rtpengine']['branch_name']
    end

    bash 'make rtpengine' do
        ignore_failure = true
        cwd node['rtpengine']['src_dir']
        code <<-EOF
            make
            make install
            ldconfig
        EOF
    end

else
    Chef::Log.info("install from rpm '#{node['rtpengine']['package_path']}'")
    
    rpm_package "install from RPM-file" do
    source node['rtpengine']['package_path']
    action :install
    end
    
end
Chef::Log.info("node['rtpengine']['user']                = '#{node['rtpengine']['user']}'")
Chef::Log.info("node['rtpengine']['group']               = '#{node['rtpengine']['group']}'")
Chef::Log.info("node['rtpengine']['min-port']            = '#{node['rtpengine']['min-port']}'")
Chef::Log.info("node['rtpengine']['max-port']            = '#{node['rtpengine']['max-port']}'")
Chef::Log.info("node['rtpengine']['control_sock']        = '#{node['rtpengine']['control_sock']}'")
Chef::Log.info("node['rtpengine']['rttp_notify_socket']  = '#{node['rtpengine']['rttp_notify_socket']}'")
Chef::Log.info("node['rtpengine']['listen_addr']         = '#{node['rtpengine']['listen_addr']}'")
Chef::Log.info("node['rtpengine']['advertised_addr']     = '#{node['rtpengine']['advertised_addr']}'")
Chef::Log.info("node['rtpengine']['extra_opts']          = '#{node['rtpengine']['extra_opts']}'")

case node['platform_family']
    when 'debian'
        rtpengine_initd = 'init.d-deb.erb'
        rtpengine_conf = '/etc/default/rtpengine'
    when 'suse' ## ToDo
        rtpengine_initd = 'init.d-rpm.erb'
        rtpengine_conf = '/etc/sysconfig/rtpengine'
    when 'rhel'
        rtpengine_initd = 'init.d-rpm.erb'
        rtpengine_conf = '/etc/sysconfig/rtpengine'
    else
        rtpengine_initd = 'init.d-rpm.erb'
        rtpengine_conf = '/etc/sysconfig/rtpengine'
end
Chef::Log.info("rtpengine_initd = '#{rtpengine_initd}'")
Chef::Log.info("rtpengine_conf = '#{rtpengine_conf}'")

template rtpengine_conf do
    source 'default.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

template '/etc/init.d/rtpengine' do
    only_if { node['rtpengine']['package_path'].empty? }
    source rtpengine_initd
    owner 'root'
    group 'root'
    mode '0755'
end

{
'/root/rtpengine.cfg'    => '/usr/local/etc/rtpengine/rtpengine.cfg',
'/root/rtpenginectlrc'   => '/usr/local/etc/rtpengine/rtpenginectlrc'
}.each do |file_path, to_path|
#    if File.exist?(file_path)
    if true
        Chef::Log.info("*** read file = '#{file_path}'")
        #file_content = File.read(file_path)
        file to_path do
            content lazy { ::File.open(file_path).read }
            owner "rtpengine"
            group "rtpengine"
        end
    else
        Chef::Log.info("*** no file = '#{file_path}'")
    end
end

file node['rtpengine']['rsyslog'] do
    content "local5.* #{node['rtpengine']['log']}"
    owner 'root'
    group 'root'
end
    
if node['rtpengine']['symlinks_in_home'] && node['rtpengine']['package_path'].empty?
    link myhome + "/rtpengine-src" do
        to node['rtpengine']['src_dir']
    end
    link myhome + "/rtpengine-conf" do
        to rtpengine_conf
    end
end

service 'rsyslog' do
    action [ :restart ]
end

service 'rtpengine' do
    supports :start => true, :stop => true, :restart => true, :status => true
    action [ :enable, :restart ]
end