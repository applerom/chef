#
# Cookbook:: phpapp
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
default['phpapp']['myhome'] = myhome
Chef::Log.info("node['platform'] = '#{node['platform']}'")
Chef::Log.info("myhome = '#{myhome}'")

# phpapp variables - enter your values here or use custom JSON

default['phpapp']['git_repository']                  = 'https://github.com/phpapp/someapp'
default['phpapp']['branch_name']                     = 'master' # or to ex. '4.0'
default['phpapp']['git_repository_ssh_key_path']     = '' # if you use ssh connect to private repo (chmod 600)
default['phpapp']['git_ssh_wrapper_path']            = '/tmp/git_ssh_wrapper.sh'

default['phpapp']['www_dir']                         = '/var/www/html'
default['phpapp']['www_conf']                        = ''
default['phpapp']['www_conf_path']                   = '/etc/httpd/conf.d/phpapp.conf'

default['phpapp']['ServerAdmin']    = 'webmaster@localhost'
default['phpapp']['ServerName']     = 'linux.cmd'
default['phpapp']['ServerAlias']    = 'www.linux.cmd'
default['phpapp']['DocumentRoot']   = '/var/www/html'

default['phpapp']['SSLCertificateKeyFile']  = '/root/certs/mycert.key.pem'
default['phpapp']['SSLCertificateFile']     = '/root/certs/mycert.crt'
default['phpapp']['SSLCACertificateFile']   = '/root/certs/myCA.crt'


default['phpapp']['symlinks_in_home'] = true


=begin
#Custom JSON to insert:
{
    "phpapp": {
        "cert": "/path/to/my.domain.and.may.by.bundle.of.intermediate.and.root.in.the.end.crt",
        "cert_key": "/path/to/my.domain.key.pem",
        "min-port": "16384",
        "max-port": "32768",
        "log": "/var/log/phpapp.log"
    }
}
=end
