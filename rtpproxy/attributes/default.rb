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
default['rtpproxy']['myhome'] = myhome
Chef::Log.info("node['platform'] = '#{node['platform']}'")
Chef::Log.info("myhome = '#{myhome}'")

# rtpproxy variables - enter your values here or use custom JSON
default['rtpproxy']['git_repository']               = 'https://github.com/sippy/rtpproxy'
default['rtpproxy']['git_repository_ssh_key_path']  = '' # if you use ssh connect to private repo (chmod 600)
default['rtpproxy']['git_ssh_wrapper_path']         = '/tmp/git_ssh_wrapper.sh'
default['rtpproxy']['src_dir']          = '/usr/local/src/rtpproxy'

default['rtpproxy']['user']             = 'root'
default['rtpproxy']['group']            = 'root'
default['rtpproxy']['min-port']         = '16384'
default['rtpproxy']['max-port']         = '32768'

default['rtpproxy']['control_sock']         = 'udp:`wget -T 10 -O- http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null`:11111'
default['rtpproxy']['rttp_notify_socket']   = 'tcp:10.100.1.85:9999'
default['rtpproxy']['listen_addr']          = '`wget -T 10 -O- http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null`'
default['rtpproxy']['advertised_addr']      = '`wget -T 10 -O- http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null`'

default['rtpproxy']['extra_opts']       = ' -d INFO:LOG_LOCAL5 -F' # -d DBUG:LOG_LOCAL5 -F

default['rtpproxy']['rsyslog']          = '/etc/rsyslog.d/50-rtpproxy.conf'
default['rtpproxy']['log']              = '/var/log/rtpproxy.log'

default['rtpproxy']['symlinks_in_home'] = true



=begin
#Custom JSON to insert:
{
    "turn": {
        "cert": "/path/to/my.domain.and.may.by.bundle.of.intermediate.and.root.in.the.end.crt",
        "cert_key": "/path/to/my.domain.key.pem",
        "min-port": "16384",
        "max-port": "32768",
        "user": "my_persistent_user_here",
        "password": "my_persistent_password_here",
        "realm": "my.domain",
        "log": "/var/log/turn.log"
    }
}
=end
