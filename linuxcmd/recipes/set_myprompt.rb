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

bashrc = myhome + "/.bashrc"

bashrc_orig = File.read(bashrc)

template bashrc do
    source "bashrc.erb"
    variables({
        bashrc_orig_content: bashrc_orig
    })
end unless File.open(bashrc).grep(/myprompt/)