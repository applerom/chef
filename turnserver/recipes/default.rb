#
# Cookbook:: turnserver
# Recipe:: default
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

myhome="#{node.default['my']['home']}"
myuser="#{node.default['my']['user']}"
mycert_dir="#{node.default['my']['cert_dir']}"

Chef::Log.info("node['platform'] = #{node['platform']}")


%w(gcc-c++ libevent-devel openssl-devel).each do |mypackage|
    package mypackage do
        action :install
    end
end

turnserver_src_dir = '/usr/local/src/turnserver'
git turnserver_src_dir do
  repository 'https://github.com/coturn/coturn.git'
end

link myhome + "/turnserver-src" do
    to turnserver_src_dir
end

bash 'make coturn' do
    ignore_failure = true
    code <<-EOF
        ./configure
        make
        make install

        ldconfig
    EOF
end

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


