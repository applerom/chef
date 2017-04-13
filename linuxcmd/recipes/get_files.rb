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
    s3_bucket_files.each do |file_path, s3_path|
        Chef::Log.info("file_path = #{file_path}")
        Chef::Log.info("s3_path = #{s3_path}")
        Chef::Log.info("s3_bucket = #{s3_bucket}")
        s3_file file_path do
            remote_path s3_path
            bucket s3_bucket
        end
    end
end
