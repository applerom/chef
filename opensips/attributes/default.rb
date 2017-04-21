#
# Cookbook:: opensips
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
default['opensips']['myhome'] = myhome
Chef::Log.info("node['platform'] = '#{node['platform']}'")
Chef::Log.info("myhome = '#{myhome}'")

# opensips variables - enter your values here or use custom JSON
default['opensips']['package_path']                 = '' # if install from package - local path here
default['opensips']['git_repository']               = 'https://github.com/sippy/opensips'
default['opensips']['branch_name']                  = 'rtpp_2_1' # or to ex. master
default['opensips']['git_repository_ssh_key_path']  = '' # if you use ssh connect to private repo (chmod 600)
default['opensips']['git_ssh_wrapper_path']         = '/tmp/git_ssh_wrapper.sh'

default['opensips']['src_dir']          = '/usr/local/src/opensips'

default['opensips']['user']             = 'opensips'
default['opensips']['group']            = 'opensips'
default['opensips']['min-port']         = '16384'
default['opensips']['max-port']         = '32768'

default['opensips']['control_sock']         = 'udp:`wget -T 10 -O- http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null`:11111'
default['opensips']['rttp_notify_socket']   = 'tcp:10.100.1.85:9999'
default['opensips']['listen_addr']          = '`wget -T 10 -O- http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null`'
default['opensips']['advertised_addr']      = '`wget -T 10 -O- http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null`'

#default['opensips']['extra_opts']       = ' -d INFO:LOG_LOCAL5 -F' # -d DBUG:LOG_LOCAL5 -F
default['opensips']['extra_opts']       = ' -d INFO:LOG_LOCAL5'

default['opensips']['rsyslog']          = '/etc/rsyslog.d/50-opensips.conf'
default['opensips']['log']              = '/var/log/opensips.log'

default['opensips']['symlinks_in_home'] = true



=begin
#Custom JSON to insert:
{
    "opensips": {
        "cert": "/path/to/my.domain.and.may.by.bundle.of.intermediate.and.root.in.the.end.crt",
        "cert_key": "/path/to/my.domain.key.pem",
        "min-port": "16384",
        "max-port": "32768",
        "user": "my_persistent_user_here",
        "password": "my_persistent_password_here",
        "realm": "my.domain",
        "log": "/var/log/opensips.log"
    }
}
=end
