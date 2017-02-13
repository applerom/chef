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

mc_xdg="#{node.default['my']['mc_xdg']}"
Chef::Log.info("mc_xdg = #{mc_xdg}")
Chef::Log.info("node['platform'] = #{node['platform']}")
Chef::Log.info("node['platform'] = #{node['platform']}")

myhome="#{node.default['my']['home']}"
mc_version = "bbb"
ruby_block "mc_version" do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
        command = 'mc -V'
        command_out = shell_out(command)
        Chef::Log.info("command_out = #{command_out.stdout}")
        node.default.run_state['my']['mc_version'] = "#{command_out.stdout}"
    end
    action :create
end

mc_version=node.default['my']['mc_version']
Chef::Log.info("mc_version = #{mc_version}")

ohai "reload_ohai" do
  action :reload
end
mc_version=node.default['package_version']['mc']
Chef::Log.info("mc_version package_version = #{mc_version}")

