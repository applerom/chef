#
# Cookbook:: linuxcmd
# Recipe:: custom_script
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

file_path = node.default['my']['sh']
file node.default['my']['sh'] do
    content "df -k | awk '\$NF==\"/\"{printf \"Disk Usage: %s\n\", \$5}'"
end
