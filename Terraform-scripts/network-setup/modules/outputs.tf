# outputs.tf

output "vpc_id" {
  value = aws_vpc.k8s_vpc.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
  description = "IDs of public subnets"
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
  description = "IDs of private subnets"
}

output "internet_gateway_id" {
  value = aws_internet_gateway.k8s_igw.id
  description = "The ID of the Internet Gateway"
}
