#
# Cookbook:: fusion
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
default['fusion']['myhome'] = myhome
Chef::Log.info("node['platform'] = '#{node['platform']}'")
Chef::Log.info("myhome = '#{myhome}'")

# fusion variables - enter your values here or use custom JSON

default['fusion']['git_repository']                  = 'https://github.com/fusionpbx/fusionpbx'
default['fusion']['branch_name']                     = 'master' # or to ex. '4.0'
default['fusion']['git_repository_ssh_key_path']     = '' # if you use ssh connect to private repo (chmod 600)
default['fusion']['git_ssh_wrapper_path']            = '/tmp/git_ssh_wrapper.sh'

default['fusion']['nfs_path']                        = ''
default['fusion']['nfs_type']                        = 'nfs4'
default['fusion']['nfs_options']                     = ['nfsvers=4.1','rsize=1048576','wsize=1048576','hard','timeo=600','retrans=2']
default['fusion']['nfs_pass_fsck']                   = 0 # default in Chef is 2

default['fusion']['www_dir']                         = '/var/www/html'
default['fusion']['www_conf']                        = ''
default['fusion']['www_conf_path']                   = '/etc/httpd/conf.d/fusionpbx.conf'

default['fusion']['ServerAdmin']    = 'webmaster@localhost'
default['fusion']['ServerName']     = 'linuxcmd.ru'
default['fusion']['ServerAlias']    = 'www.linuxcmd.ru'
default['fusion']['DocumentRoot']   = '/var/www/html'

default['fusion']['SSLCertificateKeyFile']  = '/root/certs/mycert.key.pem'
default['fusion']['SSLCertificateFile']     = '/root/certs/mycert.crt'
default['fusion']['SSLCACertificateFile']   = '/root/certs/myCA.crt'


default['fusion']['log_level']       = '3'

default['fusion']['log_facility']    = 'local5'
default['fusion']['rsyslog']         = '/etc/rsyslog.d/50-fusion.conf'
default['fusion']['log']             = '/var/log/fusion.log'

default['fusion']['symlinks_in_home'] = true


=begin
#Custom JSON to insert:
{
    "fusion": {
        "cert": "/path/to/my.domain.and.may.by.bundle.of.intermediate.and.root.in.the.end.crt",
        "cert_key": "/path/to/my.domain.key.pem",
        "min-port": "16384",
        "max-port": "32768",
        "log": "/var/log/fusion.log"
    }
}
=end
