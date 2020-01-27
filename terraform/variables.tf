variable "system_name" {
  default = "system-name"
}

variable "aws_id" {
  default = ""
}

variable "naked_domain" {
  default = "example.com"
}

variable "web_domain" {
  default = {
    prod = "www.example.com"
    stg  = "stg.example.com"
    dev  = "dev.example.com"
  }
}

variable "ses_domain" {
  default = {
    prod = "example.com"
    stg  = "stg.example.com"
    dev  = "dev.example.com"
  }
}

# common
variable "key_pair_file_path" {
  default = {
    prod = "./user_files/.ssh/prod_rsa.pub"
    stg  = "./user_files/.ssh/stg_rsa.pub"
    dev  = "./user_files/.ssh/dev_rsa.pub"
  }
}

# network
variable "vpc_cidr" {
  default = {
    prod = "10.1.0.0/16"
    stg  = "10.2.0.0/16"
    dev  = "10.3.0.0/16"
  }
}

variable "azs" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

# bastion
variable "bastion_ami" {
  # Amazon Linux2 (The latest of 2019/09/06)
  default = "ami-0ff21806645c5e492"
}

variable "bastion_instance_type" {
  default = "t2.nano"
}

# database
variable "database_instance_class" {
  default = {
    prod = "db.m4.large"
    stg  = "db.t2.micro"
    dev  = "db.t2.micro"
  }
}

variable "database_allocated_storage" {
  default = {
    prod = 100
    stg  = 30
    dev  = 30
  }
}

variable "database_max_allocated_storage" {
  default = {
    prod = 1000
    stg  = 100
    dev  = 100
  }
}

variable "database_multi_az" {
  default = {
    prod = true
    stg  = false
    dev  = false
  }
}

variable "database_rds_password" {
  default = {
    prod = "password"
    stg  = "password"
    dev  = "password"
  }
}

# web
variable "web_cpu" {
  default = {
    prod = 1024
    stg  = 1024
    dev  = 512
  }
}

variable "web_memory" {
  default = {
    prod = 2048
    stg  = 2048
    dev  = 1024
  }
}

variable "web_rails_env" {
  default = {
    prod = "production"
    stg  = "production"
    dev  = "production"
  }
}

variable "web_mail_host" {
  default = "email-smtp.us-west-2.amazonaws.com"
}

variable "web_facebook_key" {
  default = ""
}

variable "web_facebook_secret" {
  default = ""
}

variable "web_bugsnag_api_key" {
  default = {
    prod = ""
    stg  = ""
    dev  = ""
  }
}

variable "web_service_desired_count" {
  default = {
    prod = 2
    stg  = 1
    dev  = 1
  }
}

variable "web_nginx_environment" {
  default = {
    prod = "production"
    stg  = "staging"
    dev  = "development"
  }
}

variable "web_autoscaling_min_capacity" {
  default = {
    prod = 2
    stg  = 1
    dev  = 1
  }
}

variable "web_autoscaling_max_capacity" {
  default = {
    prod = 3
    stg  = 1
    dev  = 1
  }
}
