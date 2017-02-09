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

["/var/www", "/etc", "/usr/local/src", "/usr", "/var/log", "/var/log/#{node.default['my']['log']}"].each do |mylink|
    link mylink do
      to node.default['my']['home']
    end
end