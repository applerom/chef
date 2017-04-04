#
# Cookbook:: linuxcmd
# Recipe:: vim_nano
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

Chef::Log.info("replace_vim_with_nano = #{node['my']['replace_vim_with_nano']}")

bash 'vim_nano' do
    only_if { node['my']['replace_vim_with_nano'] }
    ignore_failure = true
    code <<-EOF
        if [ -f /bin/vi_orig ] ; then # protect from repeated running
            rm /bin/vi                          > /dev/null 2> /dev/null
            ln -s /usr/bin/nano /bin/vi	        > /dev/null 2> /dev/null
            rm /usr/bin/vim	                    > /dev/null 2> /dev/null
            ln -s /usr/bin/nano /usr/bin/vim	> /dev/null 2> /dev/null
        else
            mv /bin/vi /bin/vi_orig             > /dev/null 2> /dev/null
            ln -s /usr/bin/nano /bin/vi         > /dev/null 2> /dev/null
            mv /usr/bin/vim /usr/bin/vim_orig	> /dev/null 2> /dev/null
            ln -s /usr/bin/nano /usr/bin/vim	> /dev/null 2> /dev/null
        fi
    EOF
end



