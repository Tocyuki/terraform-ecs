variable "name" {}
variable "common_tags" {}
variable "aws_id" {}

variable "vpc" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "bucket" {}
variable "ses_domain" {}

variable "route53_zone" {}
variable "domain" {}
variable "certificate" {}

variable "ecs_cluster" {}
variable "service_desired_count" {}
variable "autoscaling_min_capacity" {}
variable "autoscaling_max_capacity" {}

variable "cpu" {}
variable "memory" {}

variable "rails_env" {}
variable "mail_host" {}
variable "facebook_key" {}
variable "facebook_secret" {}
variable "bugsnag_api_key" {}
variable "db_endpoint" {}
variable "db_dbname" {}
variable "db_user" {}
variable "db_password" {}

variable "nginx_environment" {}
