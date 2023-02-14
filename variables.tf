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