#
# Cookbook:: rtpproxy
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

myhome = '/home/admin'
node['etc']['passwd'].each do |user, data|
    if data['dir'].start_with?("/home/")
        myhome = data['dir']
    end
end
default['rtpproxy']['myhome'] = myhome

# rtpproxy-server variables - enter your values here or use custom JSON
default['rtpproxy']['src_dir']='/usr/local/src/rtpproxy'

default['rtpproxy']['cert']='cert_name_here.crt'
default['rtpproxy']['cert_key']='cert_name_key_here.pem'

default['rtpproxy']['min-port']='16384'
default['rtpproxy']['max-port']='32768'

default['rtpproxy']['user']='static_user'
default['rtpproxy']['password']='static_password'

default['rtpproxy']['realm']='my.domain'

default['rtpproxy']['log']='/var/log/rtpproxy.log'

default['rtpproxy']['symlinks_in_home']=true

=begin
#Custom JSON to insert:
{
    "rtpproxy": {
        "cert": "my.domain.here.and.may.by.bundle.of.intermediate.and.root.in.the.end.crt",
        "cert_key": "my.domain.key.pem",
        "min-port": "16384",
        "max-port": "32768",
        "user": "my_persistent_user_here",
        "password": "my_persistent_password_here",
        "realm": "my.domain",
        "log": "/var/log/rtpproxy.log"
    }
}
=end
