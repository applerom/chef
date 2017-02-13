#
# Cookbook:: linuxcmd
# Library: linuxcmd_helper
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
#####mmm
module Linuxcmd
    module Helper

        include Chef::Mixin::ShellOut

        def mc_47?
            cmd = shell_out!('mc -V', {:returns => [0,2]})
            Chef::Log.info("mc_47 command_out = #{command_out.stdout}")
            command_out.stderr.empty? && (command_out.stdout =~ /Midnight Commander 4.7/)
        end
    end
end


