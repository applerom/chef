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
myuser="admin"
myhome="/home/admin"

node['etc']['passwd'].each do |user, data|
    if data['dir'].start_with?("/home/")
        myuser=user
        myhome=data['dir']
    end
end
Chef::Log.info("myuser = #{myuser}, myhome = #{myhome}")
Chef::Log.info("my-user = #{default['my']['user']}, my-home = #{default['my']['home']}")

[myhome + "/.bashrc", "/root/.bashrc"].each do |bashrc|
    Chef::Log.info("bashrc = #{bashrc}")
    
    bashrc_orig = File.read(bashrc)
    Chef::Log.info("bashrc_orig.scan(/myprompt/) = #{bashrc_orig.scan(/myprompt/)}, bashrc_orig.scan(/myprompt/).length = #{bashrc_orig.scan(/myprompt/).length}")
    
    if bashrc_orig.scan(/myprompt/).length == 0
        Chef::Log.info("bashrc_orig = #{bashrc_orig}")
        
        template bashrc do
            source "myprompt.erb"
            variables({
                :bashrc_orig_content => bashrc_orig
            })
        end
    end
end
