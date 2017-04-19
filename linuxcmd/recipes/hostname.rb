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
        "domain": "linuxcmd.ru",
        "autoname": "turn",
        "prompt": true
    }
}
=end

my_domain = "#{node['my']['domain']}"
my_name = "#{node['my']['name']}"
autoname = "#{node['my']['autoname']}"
Chef::Log.info("node['my']['domain'] = '#{my_domain}'")
Chef::Log.info("node['my']['name'] = '#{my_name}'")
Chef::Log.info("node['my']['autoname'] = '#{autoname}'")


if node['my']['name'].empty?
    instance = search("aws_opsworks_instance", "self:true").first
    cur_hostname = instance['hostname']
    Chef::Log.info("*** cur_hostname is '#{cur_hostname}'")
    private_ip = instance['private_ip']
    Chef::Log.info("*** private_ip is '#{private_ip}'")
    my_site = "#{autoname}#{private_ip.split('.')[2]}-#{private_ip.split('.')[3]}.#{my_domain}"
else
    my_site = my_domain.empty? ? "#{my_name}" : "#{my_name}.#{my_domain}"
end
Chef::Log.info("*** my_site = '#{my_site}'")

node.run_state['current_hostname'] = my_site # save hostname for other recepies
Chef::Log.info("********** node.run_state['current_hostname'] (hostname) = '#{node.run_state['current_hostname']}' **********")

bash 'set hostname for current process' do
    ignore_failure = true
    code <<-EOF
        hostname '#{my_site}'
    EOF
end
# save hostname for other recepies
file '/root/current_hostname' do
    content my_site
end

# 'string of file path':  'string of ruby code'
{
    '/etc/sysconfig/network':   'file_content.gsub!(/^HOSTNAME=.*/, "HOSTNAME=#{my_site}")',
    '/etc/hostname':            'my_site',
    "#{node['my']['sh']}":      'file_content.gsub!(/^sudo hostname.*/, "sudo hostname #{my_site}")'
}.each do |file_path_cur,code_string|
    file_path = file_path_cur.to_s # without to_s ---> TypeError: no implicit conversion of Symbol into String
    Chef::Log.info("#{file_path} File.exist? = #{ File.exist?(file_path) }")

    if File.exist?(file_path)
        file_content = File.read(file_path)
        
        file file_path do
            content eval code_string # eval code_string = run code in code_string
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


