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

if node.attribute?('ec2')
    Chef::Log.info("It's EC2")
    case node['platform']
        when 'amazon'
            Chef::Log.info("It's AMI Linux")
            bash 'set hostname in /etc/sysconfig/network' do
                ignore_failure = true
                code <<-EOF
                    MY_SITE="#{my_site}"
                    sed -i "s|^HOSTNAME=.*|HOSTNAME=${MY_SITE}|" #{file_path}
                    sudo hostname $MY_SITE
                EOF
            end
        else
            Chef::Log.info("It's other Linux")
    end
end

file_path = '/etc/hosts'
add_string = my_site

file_content = File.read(file_path)

#if file_content.match?(/#{add_string}/) # only in Ruby 2.4
if file_content =~ /#{add_string}/
    Chef::Log.info("file_content =~ /#{add_string}/) = true")
    file file_path do
        content file_content.gsub!(/^127.0.0.1(.*)/, "127.0.0.1 #{add_string} \\1")
    end
else
    Chef::Log.info("file_content =~ /#{add_string}/) = false")
end
