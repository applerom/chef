#
# Cookbook:: linuxcmd
# Recipe:: turn_server
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

turnserver_git = '/usr/local/src/turnserver'
git turnserver_git do
  repository 'https://github.com/coturn/coturn.git'
end

link myhome + "/turnserver" do
    to turnserver_git
end