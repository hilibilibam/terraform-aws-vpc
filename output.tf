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

output "private_subnets_id" {
  value = aws_subnet.private_subnet.*.id
}
output "public_subnets_id" {
  value = aws_subnet.public_subnet.*.id
}

output "igw-public" {
  value = aws_internet_gateway.igw_public
}














#output "s3_bucket_arn" {
 # value       = aws_s3_bucket.terraform_state_file.arn
 # description = "The ARN of the S3 bucket"
#}