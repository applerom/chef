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

%w(gcc-c++ libevent-devel openssl-devel).each do |mypackage|
    package mypackage do
        action :install
    end
end

git node['turn']['src_dir'] do
    repository 'https://github.com/coturn/coturn.git'
end


bash 'make coturn' do
    ignore_failure = true
    cwd node['turn']['src_dir']
    code <<-EOF
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
