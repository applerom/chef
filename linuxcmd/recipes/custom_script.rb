#
# Cookbook:: linuxcmd
# Recipe:: custom_script
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

if node.attribute?('ec2')
    Chef::Log.info("It's ec2") # for EC2 use recipe hostname in the Configure stage because of it changes after any stop/start (not reboot)
else
    my_hostname = "sudo hostname #{node.default['my']['site']}" # only for non-EC2 servers - set in the interactive session
end

file node.default['my']['sh'] do
    content 'df -k | awk \'$NF=="/"{printf "Disk Usage: %s\n", $5}\'' + "\n#{my_hostname}"
end