variable "region" {}
variable "project_name" {}
variable "vpc_cidr" {
  type = string
  description = "The cidr block of the VPC"
}
variable "private_subnet" {
  type    = list(string)
  default = []
}
variable "public_subnet" {
  type    = list(string)
  default = []
}
variable "route_tables_name_list" {
  type    = list(string)
  default = ["public", "private-AZa", "private-AZb"]
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}
