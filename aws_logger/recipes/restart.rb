## use part of 'install.rb' code!

stack = search("aws_opsworks_stack").first
cur_region = stack['region']
stack_name = stack['name']
Chef::Log.info("********** The stack's name is '#{stack_name}', region = '#{cur_region}' **********")

instance = search("aws_opsworks_instance", "self:true").first
instance_hostname = instance['hostname']
Chef::Log.info("********** The instance's hostname is '#{instance_hostname}' **********")

default_aws_log = JSON.parse(JSON.generate(node['awslogs_conf_default']))

if default_aws_log['log_stream_name'].to_s.empty?
    default_aws_log['log_stream_name'] = instance_hostname
end

if node['awslogs_conf'].to_s.empty?
    Chef::Log.info("*** node['awslogs_conf'] is empty - set awslogs_conf_data to default ***")
    awslogs_conf_data = { 'default_aws_log': default_aws_log}
else
    Chef::Log.info("*** node['awslogs_conf'] defined and is '#{node['awslogs_conf']}' ***")
    awslogs_conf_data = JSON.parse(JSON.generate(node['awslogs_conf']))
    
    Chef::Log.info("*** check awslogs_conf_data = '#{awslogs_conf_data}' ***")
    awslogs_conf_data.each do |log_conf_name, cur_log|
        default_aws_log.each do |key, value|
            if not defined?(awslogs_conf_data[log_conf_name][key])
                Chef::Log.info("*** #{log_conf_name}[#{key}] is not defined, set to '#{value}' ***")
                awslogs_conf_data[log_conf_name][key] = value
            elsif awslogs_conf_data[log_conf_name][key].nil?
                Chef::Log.info("*** #{log_conf_name}[#{key}] is nil, set to '#{value}' ***")
                awslogs_conf_data[log_conf_name][key] = value
            end    
        end
    end
end
Chef::Log.info("*** awslogs_conf_data = '#{awslogs_conf_data}' ***")

template node['aws_logger']['config_file'] do
    source "awslogs.conf.erb"
    variables({
        :awslogs_conf_data => awslogs_conf_data,
        :state_file => node['aws_logger']['state_file'],
    })
    owner "root"
    group "root"
    mode 0644
end

service "awslogs" do
    action [:restart]
end
