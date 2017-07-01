#
# Cookbook:: phpapp
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
myhome = node['phpapp']['myhome']

%w(httpd24 mod24_ssl php56 php56-cli php56-mysqlnd php-pear php56-gd php56-xmlrpc php56-mcrypt php56-mbstring php56-intl php56-pecl-memcache memcached php56-pgsql php56-odbc).each do |mypackage|
    package mypackage do
        action :install
    end
end

Chef::Log.info("node['phpapp']['git_repository']  = '#{node['phpapp']['git_repository']}'")
Chef::Log.info("node['phpapp']['www_dir']         = '#{node['phpapp']['www_dir']}'")

directory '/var/www/html' do
    owner "apache"
    group "apache"
end

service 'httpd' do
    supports :start => true, :stop => true, :restart => true, :status => true
    action [ :enable, :restart ]
end