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

=begin
{
    "my": {
        "site": "turn03.secrom.com",
        "prompt": true
    }
}
=end

my_site = "#{node['my']['site']}"
Chef::Log.info("node['my']['site'] = #{my_site}")

bash 'set hostname for current process' do
    ignore_failure = true
    code <<-EOF
        sudo hostname "#{my_site}"
    EOF
end

file_pathes={
'/etc/sysconfig/network':   'file_content.gsub!(/^HOSTNAME=.*/, "HOSTNAME=#{my_site}")',
'/etc/hostname':            'my_site',
node['my']['sh']:           'file_content.gsub!(/^sudo hostname.*/, "sudo hostname #{my_site}")'
}
file_pathes.each do |file_path,code_string|
    Chef::Log.info("#{file_path} File.exist? = #{ File.exist?(file_path) }")

    if File.exist?(file_path)
        file_content = File.read(file_path)
        
        file file_path do
            content eval code_string
        end
    end
end


file_path = '/etc/hosts'
file_content = File.read(file_path)

#if file_content.match?(/#{my_site}/) # only in Ruby 2.4
unless file_content =~ /#{my_site}/
    Chef::Log.info("Add /#{my_site}/) to #{file_path}.")
    file file_path do
        content file_content.gsub!(/^127.0.0.1(.*)/, "127.0.0.1 #{my_site} \\1")
    end
else
    Chef::Log.info("There is /#{my_site}/) in #{file_path} yet.")
end


