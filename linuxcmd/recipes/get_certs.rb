#
# Cookbook:: linuxcmd
# Recipe:: get_certs
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

mycert="#{node['my']['cert']}"
mycert_key="#{node['my']['cert_key']}"
mycert_dir="#{node['my']['cert_dir']}"
mys3_files="#{node['my']['s3_cert_dir']}"

Chef::Log.info("mycert = '#{mycert}'")
Chef::Log.info("mycert_key = '#{mycert_key}'")
Chef::Log.info("mycert_dir = '#{mycert_dir}'")
Chef::Log.info("mys3_files = '#{mys3_files}'")

bash 'get certs from s3' do
    not_if { mys3_files.empty? }
    ignore_failure = true
    code <<-EOF
        S3_FILES=#{mys3_files}      ## S3 files directory
        CERT_DIR=#{mycert_dir}      ## local certs directory

        CERT_KEY=#{mycert_key}      ## private key
        CERT_BUNDLE=#{mycert}       ## bundle for nginx

        aws s3 cp $S3_FILES/certs/$CERT_KEY 	$CERT_DIR/$CERT_KEY		## download private key
        aws s3 cp $S3_FILES/certs/$CERT_BUNDLE	$CERT_DIR/$CERT_BUNDLE	## download bundle for nginx
    EOF
end