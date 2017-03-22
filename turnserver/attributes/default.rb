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

default['turn']['src_dir']='/usr/local/src/turnserver'

default['turn']['cert']='cert_name_here.crt'
default['turn']['cert_key']='cert_name_key_here.pem'

default['turn']['min-port']='16384'
default['turn']['max-port']='32768'

default['turn']['user']='static_user'
default['turn']['password']='static_password'

default['turn']['realm']='my.domain'

default['turn']['log']='/var/log/turn.log'

default['turn']['symlinks_in_home']=true

=begin
#Custom JSON to insert:
{
    "turn": {
        "cert": "wild16.secrom.com.and.gd_bundle.crt",
        "cert_key": "wild16.secrom.com.key.pem",
        "min-port": "16384",
        "max-port": "32768",
        "user": "turn18",
        "password": "turn18",
        "realm": "sp.secrom.com",
        "log": "/var/log/turn.log"
    }
}
=end
