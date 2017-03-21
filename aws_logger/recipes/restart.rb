my_site = node['my']['site1']
Chef::Log.info("*** my_site = '#{my_site}' ***")

default_aws_log = node['awslogs_conf_default']

if defined?(node['awslogs_conf'])
    Chef::Log.info("*** node['awslogs_conf'] defined and is '#{node['awslogs_conf']}' ***")
    awslogs_conf_data = JSON.parse(JSON.generate(node['awslogs_conf']))
else
    Chef::Log.info("*** node['awslogs_conf'] is not defined - set awslogs_conf_data to default ***")
    awslogs_conf_data = { 'default_aws_log': default_aws_log}
end

if awslogs_conf_data.nil?
    Chef::Log.info("*** node['awslogs_conf'] is nil - set awslogs_conf_data to default ***")
    awslogs_conf_data = { 'default_aws_log': default_aws_log}
else
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
            if key == "log_stream_name" && !my_site.nil?
                Chef::Log.info("*** change log_stream_name to '#{my_site}' ***")
                awslogs_conf_data[log_conf_name][key] = my_site
            end
        end
    end
end

Chef::Log.info("*** awslogs_conf_data = '#{awslogs_conf_data}' ***")

template node["aws_logger"]["config_file"] do
    source "awslogs.conf.erb"
    variables({
        :awslogs_conf_data => awslogs_conf_data,
        :state_file => node["aws_logger"]["state_file"],
    })
    owner "root"
    group "root"
    mode 0644
end

service "awslogs" do
    action [:restart]
end
