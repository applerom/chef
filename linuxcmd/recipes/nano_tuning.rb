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



bash 'nano_tune' do
    ignore_failure = true
    code <<-EOF
        sed -i 's|color green|color brightgreen|' /usr/share/nano/xml.nanorc
        sed -i 's~(cat|cd|chmod|chown|cp|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~(apt-get|awk|cat|cd|chmod|chown|cp|cut|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~' /usr/share/nano/sh.nanorc

        if ! grep -q "/bin/nano" #{node.default['my']['home']}/.selected_editor > /dev/null 2> /dev/null ; then # protect from repeated running
            echo "SELECTED_EDITOR=/bin/nano" >> #{node.default['my']['home']}/.selected_editor
        fi
        if ! grep -q "/bin/nano" /root/.selected_editor > /dev/null 2> /dev/null ; then # protect from repeated running
            echo "SELECTED_EDITOR=/bin/nano" >> /root/.selected_editor
        fi
    EOF
end

bashrc = "#{node.default['my']['home']}/.bashrc"

bashrc_orig = File.read(bashrc)
Chef::Log.info("bashrc_orig.scan(/EDITOR=nano/) = #{bashrc_orig.scan(/EDITOR=nano/)}, bashrc_orig.scan(/EDITOR=nano/).length = #{bashrc_orig.scan(/EDITOR=nano/).length}")

if bashrc_orig.scan(/EDITOR=nano/).length == 0
    Chef::Log.info("bashrc_orig = #{bashrc_orig}")
    
    template bashrc do
        source "nano_editor.erb"
        variables({
            :bashrc_orig_content => bashrc_orig
        })
    end
end



