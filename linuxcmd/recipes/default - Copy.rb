#
# Cookbook:: linuxcmd
# Recipe:: default
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

myhome="#{node.default['my']['home']}"
mycert_dir="#{node.default['my']['cert_dir']}"
mc_xdg="#{node.default['my']['mc_xdg']}"
myuser="#{node.default['my']['user']}"

Chef::Log.info("node['platform'] = #{node['platform']}")


%w(mc ftp bzip2 zip nano lynx wget curl telnet git).each do |mypackage|
    package mypackage do
        action :install
    end
end

bashrc = "#{myhome}/.bashrc"
bashrc_orig = File.read(bashrc)

{
"myprompt"      => "prompt",
"EDITOR=nano"   => "nano_editor"
}.each do |key, value|
    if bashrc_orig.scan(/#{key}/).length == 0
        Chef::Log.info("set #{key}")
    else
        node.default['my'][value] = false
    end
end

template bashrc do
    source "bashrc.erb"
    variables({
        :bashrc_orig_content => bashrc_orig,
        :myprompt => node.default['my']['prompt'],
        :nano_editor => node.default['my']['nano_editor'],
    })
end

bashrc = "/root/.bashrc"
bashrc_orig = File.read(bashrc)

if bashrc_orig.scan(/myprompt/).length == 0
    template bashrc do
        source "bashrc.erb"
        variables({
            :bashrc_orig_content => bashrc_orig,
            :myprompt => true,
            :nano_editor => false,
        })
    end
end




directory '/var/www' do
end

[
    "/var/www",
    "/etc",
    "/usr/local/src",
    "/usr",
    "/var/log",
    "/var/log/#{node.default['my']['log']}"
].each do |mylink|
    mylinkname = mylink.scan(/\/([^\/]*)/).last.first
    Chef::Log.info("mylinkname = #{mylinkname}")

    mylinkpath = myhome + "/" + mylinkname
    link mylinkpath do
        to mylink
    end
end


directory mycert_dir do
end

unless mycert_dir.start_with?(myhome)
    mylinkname = mycert_dir.scan(/\/([^\/]*)/).last.first
    Chef::Log.info("mylinkname = #{mylinkname}")

    mylinkpath = myhome + "/" + mylinkname
    link mylinkpath do
        to mycert_dir
    end
end

Chef::Log.info("nano_tune = #{node.default['my']['nano_tune']}")
Chef::Log.info("replace_vim_with_nano = #{node.default['my']['replace_vim_with_nano']}")
Chef::Log.info("use_internal_editor_for_mc = #{node.default['my']['use_internal_editor_for_mc']}")

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

bash 'vim_nano' do
    only_if { node.default['my']['replace_vim_with_nano'] }
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

Chef::Log.info("mc_xdg = #{mc_xdg}")

bash 'mc_47' do
    not_if { node.default['my']['use_internal_editor_for_mc'] }
    ignore_failure = true
    code <<-EOF
        if mc -V | grep "Midnight Commander 4.7" ; then # directory for old mc version (to ex. in AMILinux)
            MC_XDG=""
        else
            MC_XDG="config/" # 4.8+ use XDG-support path for config files
        fi

        if [ -f #{node.default['my']['home']}/.${MC_XDG}mc/ini ] ; then
            sed -i "s|^use_internal_edit=.*|use_internal_edit=0|" #{node.default['my']['home']}/.${MC_XDG}mc/ini
        else
            mkdir -p #{node.default['my']['home']}/.${MC_XDG}mc > /dev/null 2> /dev/null
            echo "[Midnight-Commander]" > #{node.default['my']['home']}/.${MC_XDG}mc/ini
            echo "use_internal_edit=0" >> #{node.default['my']['home']}/.${MC_XDG}mc/ini
        fi
        if [ -f /root/.${MC_XDG}mc/ini ] ; then
            sed -i "s|^use_internal_edit=.*|use_internal_edit=0|" /root/.${MC_XDG}mc/ini
        else
            mkdir -p /root/.${MC_XDG}mc > /dev/null 2> /dev/null
            echo "[Midnight-Commander]" > /root/.${MC_XDG}mc/ini
            echo "use_internal_edit=0" >> /root/.${MC_XDG}mc/ini
        fi
    EOF
end

file_path = '/etc/shells'
add_string = '/bin/false'

file_content = File.read(file_path)
Chef::Log.info("file_content.scan(/#{add_string}/) = #{file_content.scan(/#{add_string}/)}, file_content.scan(/#{add_string}/).length = #{file_content.scan(/#{add_string}/).length}")
if file_content.scan(/#{add_string}/).length == 0
    file file_path do
        content file_content + add_string
    end
end

file node.default['my']['sh'] do
    content 'df -k | awk \'$NF=="/"{printf "Disk Usage: %s\n", $5}\''
end

bash 'finish_actions' do
    ignore_failure = true
    code "chown -R #{myuser}:#{myuser} #{myhome}"
end