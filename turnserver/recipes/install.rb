#
# Cookbook:: turnserver
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

myhome = node['turn']['myhome']

myopenssl =
    case node['platform']
        when 'ubuntu'
          'libssl-dev'
        when 'debian'
          'libssl-dev'
        when 'centos'
          'openssl-devel'
        when 'amazon'
          'openssl-devel'
        else
          'openssl-devel'
    end
Chef::Log.info("myopenssl = #{myopenssl}")

mylibevent =
    case node['platform']
        when 'ubuntu'
          'libevent-dev'
        when 'debian'
          'libevent-dev'
        when 'centos'
          'libevent-devel'
        when 'amazon'
          'libevent-devel'
        else
          'libevent-devel'
    end
Chef::Log.info("mylibevent = #{mylibevent}")

%w(gcc-c++ myopenssl mylibevent).each do |mypackage|
    package mypackage do
        action :install
    end
end

Chef::Log.info("node['turn']['git_repository']  = '#{node['turn']['git_repository']}'")
Chef::Log.info("node['turn']['src_dir']         = '#{node['turn']['src_dir']}'")

unless node['turn']['git_repository_ssh_key_path'].empty?
    Chef::Log.info("node['turn']['git_repository_ssh_key_path'] = '#{node['turn']['git_repository_ssh_key_path']}'")
    Chef::Log.info("node['turn']['git_ssh_wrapper'] = '#{node['turn']['git_ssh_wrapper']}'")
    file node['turn']['git_ssh_wrapper_path'] do
        content "#!/bin/sh\nexec /usr/bin/ssh -i #{node['turn']['git_repository_ssh_key_path']} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \"$@\""
        user "root"
        group "root"
        mode "0700"
    end   
end

git node['turn']['src_dir'] do
    repository  node['turn']['git_repository']
    ssh_wrapper node['turn']['git_ssh_wrapper_path']
end


bash 'make coturn' do
    ignore_failure = true
    cwd node['turn']['src_dir']
    code <<-EOF
        chmod +x configure # otherwise you can get: "bash: ./configure: Permission denied"
        ./configure
        make
        make install
        ldconfig
    EOF
end

Chef::Log.info("node['turn']['user']            = '#{node['turn']['user']}'")
Chef::Log.info("node['turn']['password']        = '#{node['turn']['password']}'")
Chef::Log.info("node['turn']['realm']           = '#{node['turn']['realm']}'")
Chef::Log.info("node['turn']['cert']            = '#{node['turn']['cert']}'")
Chef::Log.info("node['turn']['cert_key'] (pkey) = '#{node['turn']['cert_key']}'")

template '/etc/turnserver.conf' do
    source 'turnserver.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

template '/etc/init.d/turnserver' do
    source 'init.d-turnserver.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

if node['turn']['symlinks_in_home']
    link myhome + "/turnserver-src" do
        to node['turn']['src_dir']
    end
    link myhome + "/turnserver-conf" do
        to '/etc/turnserver.conf'
    end
end

service 'turnserver' do
    supports :start => true, :stop => true, :restart => true
    action [ :enable, :restart ]
end

