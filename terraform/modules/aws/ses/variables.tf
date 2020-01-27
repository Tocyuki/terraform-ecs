provider "aws" {}
provider "aws" {
  alias  = "oregon"
  region = "us-west-2"
}

variable "name" {}
variable "common_tags" {}

variable "route53_zone" {}
variable "domain" {}
