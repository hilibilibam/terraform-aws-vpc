output "region" {
  value = var.region
}
output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.project_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.project_vpc.cidr_block
}

output "private_subnets" {
  value = aws_subnet.private_subnet
}
output "public_subnets" {
  value = aws_subnet.public_subnet
}

output "igw-public" {
  value = aws_internet_gateway.igw_public
}
