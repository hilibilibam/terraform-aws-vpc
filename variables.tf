variable "region" {}
variable "project_name" {}
variable "vpc_cidr" {
  type = string
  description = "The cidr block of the VPC"
}
variable "private_subnets" {
  type    = list(string)
  default = []
}
variable "public_subnets" {
  type    = list(string)
  default = []
}
variable "route_tables_name_list" {
  type    = list(string)
  default = ["]
}