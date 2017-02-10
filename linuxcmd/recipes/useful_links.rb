#
# Cookbook:: linuxcmd
# Recipe:: useful_links
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

Chef::Log.info("my-log = #{node.default['my']['log']}")

directory '/var/www' do
end

mylinkdirs <<-EOF
/var/www
/etc
/usr/local/src
/usr
/var/log
EOF
        
#mylinkdirs="/var/www /etc /usr/local/src /usr /var/log"
bash 'create-useful-links-for-dirs' do # Chef does not support symlinks for dirs → use bash code for that
    code <<-EOF
        for MYPATH in #{mylinkdirs}
        do
            ln -s $MYPATH #{node.default['my']['home']} > /dev/null 2> /dev/null
        done
    EOF
end


["/var/log/#{node.default['my']['log']}"].each do |mylink| # symlinks for files
    link node.default['my']['home'] do
      to mylink
    end
end