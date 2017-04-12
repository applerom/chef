#
# Cookbook:: rtpproxy
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

myhome = node['rtpproxy']['myhome']

Chef::Log.info("node['platform'] = #{node['platform']}")
Chef::Log.info("node['rtpproxy']['package_path'] = #{node['rtpproxy']['package_path']}")

if node['platform'] != 'amazon' or node['rtpproxy']['package_path'].empty?

    Chef::Log.info("create rtpproxy user")
    user 'rtpproxy' do
    end
    
    Chef::Log.info("node['rtpproxy']['git_repository']  = '#{node['rtpproxy']['git_repository']}'")
    Chef::Log.info("node['rtpproxy']['src_dir']         = '#{node['rtpproxy']['src_dir']}'")

    unless node['rtpproxy']['git_repository_ssh_key_path'].empty?
        Chef::Log.info("node['rtpproxy']['git_repository_ssh_key_path'] = '#{node['rtpproxy']['git_repository_ssh_key_path']}'")
        Chef::Log.info("node['rtpproxy']['git_ssh_wrapper'] = '#{node['rtpproxy']['git_ssh_wrapper']}'")
        file node['rtpproxy']['git_ssh_wrapper_path'] do
            content "#!/bin/sh\nexec /usr/bin/ssh -i #{node['rtpproxy']['git_repository_ssh_key_path']} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \"$@\""
            user "root"
            group "root"
            mode "0700"
        end   
    end

    git node['rtpproxy']['src_dir'] do
        repository  node['rtpproxy']['git_repository']
        ssh_wrapper node['rtpproxy']['git_ssh_wrapper_path']
    end


    bash 'make rtpproxy' do
        ignore_failure = true
        cwd node['rtpproxy']['src_dir']
        code <<-EOF
            chmod +x configure # otherwise you can get: "bash: ./configure: Permission denied"
            ./configure
            make
            make install
            ldconfig
        EOF
    end
else
    Chef::Log.info("install from rpm '#{node['rtpproxy']['package_path']}'")
    
    rpm_package "rtpp_2_1" do
    source node['rtpproxy']['package_path']
    action :install
    end
    
end
Chef::Log.info("node['rtpproxy']['user']                = '#{node['rtpproxy']['user']}'")
Chef::Log.info("node['rtpproxy']['group']               = '#{node['rtpproxy']['group']}'")
Chef::Log.info("node['rtpproxy']['min-port']            = '#{node['rtpproxy']['min-port']}'")
Chef::Log.info("node['rtpproxy']['max-port']            = '#{node['rtpproxy']['max-port']}'")
Chef::Log.info("node['rtpproxy']['control_sock']        = '#{node['rtpproxy']['control_sock']}'")
Chef::Log.info("node['rtpproxy']['rttp_notify_socket']  = '#{node['rtpproxy']['rttp_notify_socket']}'")
Chef::Log.info("node['rtpproxy']['listen_addr']         = '#{node['rtpproxy']['listen_addr']}'")
Chef::Log.info("node['rtpproxy']['advertised_addr']     = '#{node['rtpproxy']['advertised_addr']}'")
Chef::Log.info("node['rtpproxy']['extra_opts']          = '#{node['rtpproxy']['extra_opts']}'")

case node['platform_family']
    when 'debian'
        rtpproxy_initd = 'init.d-rtpproxy-deb.erb'
        rtpproxy_conf = '/etc/default/rtpproxy'
    when 'suse' ## ToDo
        rtpproxy_initd = 'init.d-rtpproxy-rpm.erb'
        rtpproxy_conf = '/etc/sysconfig/rtpproxy'
    when 'freebsd' ## ToDo
        rtpproxy_initd = 'init.d-rtpproxy-rpm.erb'
        rtpproxy_conf = '/etc/sysconfig/rtpproxy'
    when 'rhel'
        rtpproxy_initd = 'init.d-rtpproxy-rpm.erb'
        rtpproxy_conf = '/etc/sysconfig/rtpproxy'
    else
        rtpproxy_initd = 'init.d-rtpproxy-rpm.erb'
        rtpproxy_conf = '/etc/sysconfig/rtpproxy'
end
Chef::Log.info("rtpproxy_initd = '#{rtpproxy_initd}'")
Chef::Log.info("rtpproxy_conf = '#{rtpproxy_conf}'")

template rtpproxy_conf do
    source 'rtpproxy.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

template '/etc/init.d/rtpproxy' do
    only_if { node['rtpproxy']['package_path'].empty? }
    source rtpproxy_initd
    owner 'root'
    group 'root'
    mode '0755'
end

file node['rtpproxy']['rsyslog'] do
    content "local5.* #{node['rtpproxy']['log']}"
    owner 'root'
    group 'root'
end

service 'rsyslog' do
    action [ :restart ]
end

if node['rtpproxy']['symlinks_in_home']
    link myhome + "/rtpproxy-src" do
        to node['rtpproxy']['src_dir']
    end
    link myhome + "/rtpproxy-conf" do
        to rtpproxy_conf
    end
end

service 'rtpproxy' do
    supports :start => true, :stop => true, :restart => true, :status => true
    action [ :enable, :restart ]
end

