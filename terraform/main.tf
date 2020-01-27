terraform {
  required_version = ">= 0.12.8"
}

provider "aws" {}
provider "aws" {
  alias  = "oregon"
  region = "us-west-2"
}


locals {
  name = "${var.system_name}-${terraform.workspace}"
  common_tags = {
    SystemName = var.system_name
    Env        = terraform.workspace
  }
}

# modules
module "common" {
  source = "./modules/aws/common"

  name        = local.name
  common_tags = local.common_tags

  vpc                = module.network.vpc
  key_pair_file_path = var.key_pair_file_path[terraform.workspace]
}

module "network" {
  source = "./modules/aws/network"

  name        = local.name
  common_tags = local.common_tags

  vpc_cidr = var.vpc_cidr[terraform.workspace]
  azs      = var.azs
}

module "bastion" {
  source = "./modules/aws/bastion"

  name        = local.name
  common_tags = local.common_tags

  vpc            = module.network.vpc
  public_subnets = module.network.public_subnets
  ami            = var.bastion_ami
  instance_type  = var.bastion_instance_type
  key_pair       = module.common.key_pair_app
}

module "database" {
  source = "./modules/aws/database"

  name        = local.name
  common_tags = local.common_tags

  vpc                   = module.network.vpc
  private_subnets       = module.network.private_subnets
  db_name               = "${var.system_name}_${terraform.workspace}"
  username              = var.system_name
  password              = var.database_rds_password[terraform.workspace]
  instance_class        = var.database_instance_class[terraform.workspace]
  allocated_storage     = var.database_allocated_storage[terraform.workspace]
  max_allocated_storage = var.database_max_allocated_storage[terraform.workspace]
  multi_az              = var.database_multi_az[terraform.workspace]
}

module "domain" {
  source = "./modules/aws/domain"

  naked_domain = var.naked_domain
}

module "certificate" {
  source = "./modules/aws/certificate"

  name        = local.name
  common_tags = local.common_tags

  route53_zone = module.domain.route53_zone
  domain       = var.web_domain[terraform.workspace]
}

module "ses" {
  source = "./modules/aws/ses"
  providers = {
    aws.oregon = "aws.oregon"
  }

  name        = local.name
  common_tags = local.common_tags

  route53_zone = module.domain.route53_zone
  domain       = var.ses_domain[terraform.workspace]
}

module "storage" {
  source = "./modules/aws/storage"

  name        = local.name
  common_tags = local.common_tags

  bucket_name = var.web_domain[terraform.workspace]
}

module "ecs_cluster" {
  source = "./modules/aws/ecs_cluster"

  name        = local.name
  common_tags = local.common_tags
}

module "web" {
  source = "./modules/aws/web"

  name        = local.name
  common_tags = local.common_tags
  aws_id      = var.aws_id

  vpc             = module.network.vpc
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets
  bucket          = module.storage.bucket
  ses_domain      = var.ses_domain[terraform.workspace]

  route53_zone = module.domain.route53_zone
  domain       = var.web_domain[terraform.workspace]
  certificate  = module.certificate.web

  ecs_cluster              = module.ecs_cluster.cluster
  service_desired_count    = var.web_service_desired_count[terraform.workspace]
  autoscaling_min_capacity = var.web_autoscaling_min_capacity[terraform.workspace]
  autoscaling_max_capacity = var.web_autoscaling_max_capacity[terraform.workspace]

  cpu             = var.web_cpu[terraform.workspace]
  memory          = var.web_memory[terraform.workspace]
  rails_env       = var.web_rails_env[terraform.workspace]
  mail_host       = var.web_mail_host
  facebook_key    = var.web_facebook_key
  facebook_secret = var.web_facebook_secret
  bugsnag_api_key = var.web_bugsnag_api_key[terraform.workspace]
  db_endpoint     = module.database.db_instance.endpoint
  db_dbname       = module.database.ssm_parameter_db_dbname.value
  db_user         = module.database.ssm_parameter_db_user.value
  db_password     = module.database.ssm_parameter_db_password.value

  nginx_environment = var.web_nginx_environment[terraform.workspace]
}
