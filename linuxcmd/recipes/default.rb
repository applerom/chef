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

Chef::Log.info("node['platform'] = #{node['platform']}")
Chef::Log.info("node.default['my']['replace_vim_with_nano'] = #{node.default['my']['replace_vim_with_nano']}")

include_recipe 'linuxcmd::useful_packets'
include_recipe 'linuxcmd::set_myprompt'
include_recipe 'linuxcmd::useful_links'
include_recipe 'linuxcmd::certs_dir'
include_recipe 'linuxcmd::nano_tuning'
if node.default['my']['replace_vim_with_nano']
    include_recipe 'linuxcmd::vim_nano'
end
include_recipe 'linuxcmd::internal_mcedit'
include_recipe 'linuxcmd::false_shells'
include_recipe 'linuxcmd::custom_script'
include_recipe 'linuxcmd::finish_actions'

