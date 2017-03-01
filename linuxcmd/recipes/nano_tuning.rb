#
# Cookbook:: linuxcmd
# Recipe:: nano_tuning
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

Chef::Log.info("nano_tune = #{node.default['my']['nano_tune']}")

myhome="#{node.default['my']['home']}"

bash 'nano_tune' do
    only_if { node.default['my']['nano_tune'] }
    ignore_failure = true
    code <<-EOF
        sed -i 's|color green|color brightgreen|' /usr/share/nano/xml.nanorc
        sed -i 's~(cat|cd|chmod|chown|cp|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~(apt-get|awk|cat|cd|chmod|chown|cp|cut|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~' /usr/share/nano/sh.nanorc

        if ! grep -q "/bin/nano" #{myhome}/.selected_editor > /dev/null 2> /dev/null ; then # protect from repeated running
            echo "SELECTED_EDITOR=/bin/nano" >> #{myhome}/.selected_editor
        fi
        if ! grep -q "/bin/nano" /root/.selected_editor > /dev/null 2> /dev/null ; then # protect from repeated running
            echo "SELECTED_EDITOR=/bin/nano" >> /root/.selected_editor
        fi
    EOF
end
