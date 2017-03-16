if node["opsworks"]["cloud_watch_logs_configurations"].any?
    include_recipe "aws_logger::install"
else
    include_recipe "aws_logger::uninstall"
end
