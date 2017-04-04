#
# Cookbook:: linuxcmd
# Attributes:: default
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

#default['chef_client']['locale'] = 'en_US.UTF-8'
#Encoding.default_external = Encoding::UTF_8
#ENV['LC_ALL'] = 'en_US.UTF-8'

Chef::Log.info("node['platform_family'] = '#{node['platform_family']}'")
Chef::Log.info("node['platform'] = '#{node['platform']}'")
Chef::Log.info("node['platform_version'] = '#{node['platform_version']}'")

myuser =
    case node['platform']
        when 'ubuntu'
          'ubuntu'
        when 'debian'
          'admin'
        when 'centos'
          'centos'
        when 'amazon'
          'ec2-user'
        else
          'admin'
    end
myhome = "/home/#{myuser}"

=begin
myuser="admin"
myhome="/home/admin"

node['etc']['passwd'].each do |user, data|
    if data['dir'].start_with?("/home/")
        myuser=user
        myhome=data['dir']
    end
end
=end

default['my']['user'] = myuser
default['my']['home'] = myhome

Chef::Log.info("default['my']['user'] = '#{myuser}'")
Chef::Log.info("default['my']['home'] = '#{myhome}'")

default['my']['cert_dir']       = "/root/certs"
default['my']['s3_cert_dir']    = '' # s3://cert/dir
default['my']['cert']           = '' # my_cert.crt
default['my']['cert_key']       = '' # my_cert_key.pem
default['my']['git_ssh_key']    = '' # my_git_ssh_rsa_key

=begin
#Custom JSON to insert:
{
    "my": {
        "domain": "linux.cmd",
        "autoname": "linux.cmd",
        "prompt": true,
        "s3_cert_dir": "s3://some/dir",
        "cert": "some.domain.com.and.mb.bundle.of.intermediate.in.the.end.crt",
        "cert_key": "some.domain.com.key.pem",
        "git_ssh_key": "some_git_key_rsa",
        "cert_dir": "/root/certs"
    }
}
=end

default['my']['domain'] = 'linux.cmd'   # yourdomainname.here
default['my']['name'] = ''              # your-name-here for ['my']['domain']
default['my']['autoname'] = 'myname'    # auto name for ['my']['domain'] if no ['my']['name']

default['my']['log'] =
    case node['platform_family']
        when 'debian'
            'syslog'
        when 'suse'
            'syslog'
        when 'rhel'
            'messages'
        else
            'syslog'
    end

default['my']['mc_xdg'] =
    case node['platform']
        when 'amazon'
            ''
        else
            'config/'
    end
default['my']['mc_version'] = "mc some version"
default['my']['sh'] = "/etc/profile.d/my.sh" # file for execute custom script for interactive SSH-users
default['my']['replace_vim_with_nano'] = false
default['my']['use_internal_editor_for_mc'] = false
default['my']['prompt'] = true
default['my']['nano_editor'] = true
default['my']['nano_tune'] = true





=begin
default['my']['log'] =
  case node['platform_family']
  when 'debian'
    case node['platform']
    when 'ubuntu'
      if node['platform_version'].to_f >= 14.04
        'syslog'
      elsif node['platform_version'].to_f >= 12.04
        'syslog'
      else
        'syslog'
      end
    when 'debian'
      node['platform_version'].to_f >= 7.0 ? 'worker' : 'prefork'
    when 'linuxmint'
      node['platform_version'].to_i >= 17 ? 'event' : 'prefork'
    else
      'prefork'
    end
  when 'suse'
    'prefork'
  when 'rhel'
    'prefork'
  else
    'prefork'
  end
=end


