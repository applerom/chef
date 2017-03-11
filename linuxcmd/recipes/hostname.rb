#
# Cookbook:: linuxcmd
# Recipe:: hostname
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
my_site = "#{node.default['my']['site']}"
file_path='/etc/sysconfig/network'

bash 'set hostname for current process' do
    ignore_failure = true
    code <<-EOF
        sudo hostname "#{my_site}"
    EOF
end

Chef::Log.info("node[:my][:site] = #{node[:my][:site]}")
Chef::Log.info("node.default['my']['site'] = #{node.default['my']['site']}")

if node.attribute?('ec2')
    Chef::Log.info("It's EC2")
    
    Chef::Log.info("File.exist? = #{ File.exist?(file_path) }")
    
    file_path='/etc/sysconfig/network'
    
    if File.exist?(file_path)
        file_content = File.read(file_path)
        
        file file_path do
            content file_content.gsub!(/^HOSTNAME=.*/, "HOSTNAME=#{my_site}")
        end
    end
    
    file_path = '/etc/hosts'
    add_string = my_site

    file_content = File.read(file_path)

    #if file_content.match?(/#{add_string}/) # only in Ruby 2.4
    unless file_content =~ /#{add_string}/
        Chef::Log.info("Add /#{add_string}/) to #{file_path}.")
        file file_path do
            content file_content.gsub!(/^127.0.0.1(.*)/, "127.0.0.1 #{add_string} \\1")
        end
    else
        Chef::Log.info("There is /#{add_string}/) in #{file_path} yet.")
    end
    
    template '/etc/profile.d/hostname.sh' do
        source "hostname.erb"
    end
else
    template '/etc/profile.d/hostname.sh' do
        source "hostname.erb"
    end
end
    
=begin
    case node['platform']
        when 'amazon'
            Chef::Log.info("It's AMI Linux")
        else
            Chef::Log.info("It's other Linux")
    end
=end


