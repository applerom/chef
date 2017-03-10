#
# Cookbook:: linuxcmd
# Recipe:: internal_mcedit
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

Chef::Log.info("use_internal_editor_for_mc = #{node.default['my']['use_internal_editor_for_mc']}")

mc_xdg="#{node.default['my']['mc_xdg']}"
Chef::Log.info("mc_xdg = #{mc_xdg}")

myhome="#{node.default['my']['home']}"

bash 'test for mc 4.7' do
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



