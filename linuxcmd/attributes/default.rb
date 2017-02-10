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

myuser="admin"
myhome="/home/admin"

node['etc']['passwd'].each do |user, data|
    if data['dir'].start_with?("/home/")
        myuser=user
        myhome=data['dir']
    end
end
default['my']['user'] = myuser
default['my']['home'] = myhome
default['my']['cert_dir'] = "/root/certs"

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


