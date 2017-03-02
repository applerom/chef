#
# Cookbook:: turnserver
# Recipe:: default
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

myhome="#{node.default['my']['home']}"
myuser="#{node.default['my']['user']}"
mycert_dir="#{node.default['my']['cert_dir']}"

mycert='wild16.secrom.com.and.gd_bundle.crt'
##cert=/root/certs/wild16.secrom.com.crt
mycert_key='wild16.secrom.com.key.pem'
mys3_files='s3://nist/files'

Chef::Log.info("node['platform'] = #{node['platform']}")


%w(gcc-c++ libevent-devel openssl-devel).each do |mypackage|
    package mypackage do
        action :install
    end
end

turnserver_src_dir = '/usr/local/src/turnserver'
git turnserver_src_dir do
  repository 'https://github.com/coturn/coturn.git'
end

link myhome + "/turnserver-src" do
    to turnserver_src_dir
end

bash 'make coturn' do
    ignore_failure = true
    cwd turnserver_src_dir
    code <<-EOF
        ./configure
        make
        make install

        ldconfig
    EOF
end

template '/etc/turnserver.conf' do
    source 'turnserver.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables({
        :mycert_dir => mycert_dir,
        :mycert => mycert,
        :mycert_key => mycert_key,
    })
end

template '/etc/init.d/turnserver' do
    source 'init.d-turnserver.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

bash 'get certs from s3' do
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

service 'turnserver' do
    supports :start => true, :stop => true, :restart => true
    action [ :enable, :restart ]
end

