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

mycert="#{node['my']['s3_file']['cert']}"
mycert_key="#{node['my']['s3_file']['cert_key']}"
mygit_ssh_key="#{node['my']['s3_file']['git_ssh_key']}"
my_rpm_deb="#{node['my']['s3_file']['rpm_deb']}"
mycert_dir="#{node['my']['cert_dir']}"
mys3_dir="#{node['my']['s3_dir']}"
mys3_file="#{node['my']['s3_file']}"

Chef::Log.info("mycert = '#{mycert}'")
Chef::Log.info("mycert_key = '#{mycert_key}'")
Chef::Log.info("mygit_ssh_key = '#{mygit_ssh_key}'")
Chef::Log.info("my_rpm_deb = '#{my_rpm_deb}'")
Chef::Log.info("mycert_dir = '#{mycert_dir}'")
Chef::Log.info("mys3_dir = '#{mys3_dir}'")

bash 'get certs from s3' do
    not_if { mys3_file.to_s.empty? }
    ignore_failure = true
    code <<-EOF
        S3_DIR=#{mys3_dir}      ## S3 files directory
        CERT_DIR=#{mycert_dir}      ## local certs directory

        CERT_KEY=#{mycert_key}      ## private key for cert
        GIT_KEY=#{mygit_ssh_key}    ## private key for git ssh
        CERT_BUNDLE=#{mycert}       ## bundle for nginx

        aws s3 cp $S3_DIR/certs/$CERT_KEY 	$CERT_DIR/$CERT_KEY		## download cert private key
        aws s3 cp $S3_DIR/certs/$CERT_BUNDLE	$CERT_DIR/$CERT_BUNDLE	## download bundle for nginx
        aws s3 cp $S3_DIR/certs/$GIT_KEY	    $CERT_DIR/$GIT_KEY	    ## download git private
        aws s3 cp $S3_DIR/#{my_rpm_deb}	    $CERT_DIR/#{my_rpm_deb}
        chmod 600 $CERT_DIR/$GIT_KEY	                                ## set permissions to git key
    EOF
end