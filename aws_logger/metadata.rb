name "aws_logger"
description "AWS Logger"
maintainer "AWS OpsWorks"
license "Apache 2.0"
version "1.0.0"

recipe "aws_logger::default", "Uses install or uninstall recipe"
recipe "aws_logger::install", "Install CloudWatch Logs agent."
recipe "aws_logger::uninstall", "Remove CloudWatch Logs agent and config files."
