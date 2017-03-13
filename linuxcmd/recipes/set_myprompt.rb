#
# Cookbook:: linuxcmd
# Recipe:: set_myprompt
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

# Add here part of "EDITOR=nano" because it must be in .bashrc
# and if we do it in separate stages .bashrc will be like in last change.

bashrc = "#{node['my']['home']}/.bashrc"
bashrc_orig = File.read(bashrc)

{
"myprompt"      => "prompt",
"EDITOR=nano"   => "nano_editor"
}.each do |key, value|
    if bashrc_orig =~ /#{key}/
        Chef::Log.info("set #{key}")
    else
        node.default['my'][value] = false
    end
end

template bashrc do
    #only_if { node['my']['prompt'] && node['my']['nano_editor'] }
    source "bashrc.erb"
    variables({
        :bashrc_orig_content => bashrc_orig,
        :myprompt => true,
        :nano_editor => false,
    })
end

bashrc = "/root/.bashrc"
bashrc_orig = File.read(bashrc)

template bashrc do
    not_if { bashrc_orig =~ /myprompt/ }
    source "bashrc.erb"
    variables({
        :bashrc_orig_content => bashrc_orig,
        :myprompt => true,
        :nano_editor => false,
    })
end
