#
# Cookbook:: turnserver
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

default['my']['cert']='cert_name.crt'
default['my']['cert_key']='cert_name.key.pem'
default['my']['s3_files']='s3://cert_files_dir'

default['turn']['min-port']='16384'
default['turn']['max-port']='32768'

default['turn']['user']='static_user'
default['turn']['password']='static_password'

default['turn']['realm']='my.domain'

default['turn']['log']='/var/log/turn.log'

=begin
#Custom JSON to insert:
{
    "my": {
        "cert": "wild16.secrom.com.and.gd_bundle.crt",
        "cert_key": "wild16.secrom.com.key.pem",
        "s3_files": "s3://nist/files",
        "cert_dir": "/root/certs"
    },
    "turn": {
        "min-port": "16384",
        "max-port": "32768",
        "user": "secturn17",
        "password": "secturn17",
        "realm": "sp.secrom.com",
        "log": "/var/log/turn.log"
    }
}
=end
