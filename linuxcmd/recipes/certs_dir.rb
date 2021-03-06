#
# Cookbook:: linuxcmd
# Recipe:: certs_dir
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

mycert_dir="#{node['my']['cert_dir']}"
myhome="#{node['my']['home']}"

directory mycert_dir do
end


unless mycert_dir.start_with?(myhome)
    mylinkname=mycert_dir.scan(/\/([^\/]*)/).last.first
    Chef::Log.info("mylinkname = #{mylinkname}")

    mylinkpath = myhome + "/" + mylinkname
    link mylinkpath do
        to mycert_dir
    end
end