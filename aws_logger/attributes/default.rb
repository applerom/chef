if node["platform"] == "amazon"
  default["aws_logger"]["config_file"] = "/etc/awslogs/awslogs.conf" # Configures the logs for the agent to ship
  default["aws_logger"]["home_dir"] = "/etc/awslogs" # Contains configuration files
  default["aws_logger"]["state_file"] = "/var/lib/awslogs/agent-state" # See http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/QuickStartChef.html
else
  default["aws_logger"]["config_file"] = "/opt/aws/cloudwatch/cwlogs.cfg" # Configures the logs to ship, used by installation script
  default["aws_logger"]["home_dir"] = "/var/awslogs" # Contains the awslogs package
  default["aws_logger"]["state_file"] = "/var/awslogs/state/agent-state" # See http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/QuickStartChef.html
end

default["aws_logger"]["AGENT_LOGS"] = "/var/log/aws/opsworks/*.log"
default["aws_logger"]["CHEF_LOGS"] = "/var/lib/aws/opsworks/chef/*.log"

syslog =
    case node['platform_family']
        when 'debian'
            'syslog'
        when 'suse'
            'syslog'
        when 'rhel'
            'messages'
        else
            'syslog'
    end
default['aws_logger']['syslog'] = "/var/log/#{syslog}"

