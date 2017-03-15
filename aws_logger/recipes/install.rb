directory node["aws_logger"]["home_dir"] do
  recursive true
end

stack = search("aws_opsworks_stack").first
cur_region = stack['region']
stack_name = stack['name']
Chef::Log.info("********** The stack's name is '#{stack_name}', region = '#{cur_region}' **********")

instance = search("aws_opsworks_instance", "self:true").first
cur_hostname = instance['hostname']
Chef::Log.info("********** The instance's hostname is '#{cur_hostname}' **********")

template node["aws_logger"]["config_file"] do
  source "awslogs.conf.erb"
  variables({
    :awslogs_conf_data => node["awslogs_conf"],
    :state_file => node["aws_logger"]["state_file"],
##    :aws_logger => node["opsworks"]["cloud_watch_logs_configurations"],
##    :hostname => node["opsworks"]["instance"]["hostname"]
#    :hostname => cur_hostname,
#    :log_path => log_path,
  })
  owner "root"
  group "root"
  mode 0644
end

if platform?("amazon")
  package "awslogs" do
    retries 3
    retry_delay 5
  end

  template "#{node['aws_logger']['home_dir']}/awscli.conf" do
    source "awscli.conf.erb"
##    variables :region => node["opsworks"]["instance"]["region"]
    variables :region => cur_region
  end
else
  directory "/opt/aws/cloudwatch" do
    recursive true
  end

  remote_file "/opt/aws/cloudwatch/awslogs-agent-setup.py" do
    source "https://aws-cloudwatch.s3.amazonaws.com/downloads/latest/awslogs-agent-setup.py"
    mode 0700
    retries 3
  end

  package "python" do
    retries 3
    retry_delay 5
  end

  execute "Install CloudWatch Logs agent" do
    command "/opt/aws/cloudwatch/awslogs-agent-setup.py -n -r '#{cur_region}' -c '#{node['aws_logger']['config_file']}'"
##    not_if { File.exists?(node["aws_logger"]["state_file"]) }
    not_if { File.exist?(node["aws_logger"]["state_file"]) }
  end
end

service "awslogs" do
  supports :status => true, :restart => true
##  action [:enable, :start]
  action [:enable, :restart]
end
