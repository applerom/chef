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

%w(gcc-c++ libevent-devel openssl-devel).each do |mypackage|
    package mypackage do
        action :install
    end
end

git node['rtpproxy']['src_dir'] do
    repository 'https://github.com/cortpproxy/cortpproxy.git'
end


bash 'make cortpproxy' do
    ignore_failure = true
    cwd node['rtpproxy']['src_dir']
    code <<-EOF
        ./configure
        make
        make install
        ldconfig
    EOF
end

Chef::Log.info("node['rtpproxy']['user']            = '#{node['rtpproxy']['user']}'")
Chef::Log.info("node['rtpproxy']['password']        = '#{node['rtpproxy']['password']}'")
Chef::Log.info("node['rtpproxy']['realm']           = '#{node['rtpproxy']['realm']}'")
Chef::Log.info("node['rtpproxy']['cert']            = '#{node['rtpproxy']['cert']}'")
Chef::Log.info("node['rtpproxy']['cert_key'] (pkey) = '#{node['rtpproxy']['cert_key']}'")

template '/etc/rtpproxy.conf' do
    source 'rtpproxy.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

template '/etc/init.d/rtpproxy' do
    source 'init.d-rtpproxy.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

if node['rtpproxy']['symlinks_in_home']
    link myhome + "/rtpproxy-src" do
        to node['rtpproxy']['src_dir']
    end
    link myhome + "/rtpproxy-conf" do
        to '/etc/rtpproxy.conf'
    end
end

service 'rtpproxy' do
    supports :start => true, :stop => true, :restart => true
    action [ :enable, :restart ]
end

