variable "name" {}
variable "common_tags" {}

variable "vpc" {}
variable "private_subnets" {}

variable "db_name" {}
variable "username" {}
variable "password" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "max_allocated_storage" {}
variable "multi_az" {}

locals {
  engine         = "postgres"
  engine_version = "11.4"
  family         = "postgres11"
}
