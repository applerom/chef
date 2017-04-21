#
# Cookbook:: linuxcmd
# Recipe:: get_files
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
Chef::Log.info("node['my']['s3_file'] = #{node['my']['s3_file']}")

node['my']['s3_file'].each do |s3_bucket, s3_bucket_files|
    s3_bucket_files.each do |s3_path, file_path|
        Chef::Log.info("file_path = #{file_path}")
        Chef::Log.info("s3_path = #{s3_path}")
        Chef::Log.info("s3_bucket = #{s3_bucket}")
        cur_mode = "0644"
        cur_owner = "root"
        cur_group = "root"
        if file_path.kind_of?(Array)
            %w(cur_file cur_mode cur_owner cur_group).each_with_index do |x,i|
                Chef::Log.info("#{x} = file_path[#{i}] = #{file_path[i]}")
                unless file_path[i].to_s.empty?
                    x = file_path[i]
                end
            end
        else
            cur_file = file_path
        end
        Chef::Log.info("cur_file = #{cur_file}, cur_mode = #{cur_mode}, cur_owner = #{cur_owner}, cur_group = #{cur_group}")
        s3_file cur_file do
            remote_path s3_path
            bucket s3_bucket
            mode cur_mode
            owner cur_owner
            group cur_group
        end
    end
end
