#VPC outputs
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "VPC ARN"
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "default_security_group_id" {
  description = "The default VPC security group ID"
  value       = aws_vpc.main.default_security_group_id
}

#Securitygroup outputs
output "security_group_arn" {
  description = "EC2 Instance's Security Group ARN"
  value       = aws_security_group.ec2_instance_ec2.arn
}

output "security_group_id" {
  description = "EC2 Instance's Security Group ID"
  value       = aws_security_group.ec2_instance_ec2.id
}

#EC2 outputs
output "instance_id" {
  description = "Instance ID"
  value = aws_instance.instance.id
}

output "instance_type" {
  description = "Instance type"
  value = aws_instance.instance.instance_type
}

output "private_ip" {
  description = "Instance private IP"
  value = aws_instance.instance.private_ip
}

output "public_ip" {
  description = "Instance public IP"
  value = aws_instance.instance.public_ip
}

output "security_groups" {
  description = "Security group associated to EC2 Instance"
  value = aws_instance.instance.security_groups
}

#Cloudfront outputs
output "distribution_arn" {
  description = "Cloudfront Distribution ARN"
  value       = aws_cloudfront_distribution.cf.arn
}

output "distribution_id" {
  description = "Cloudfront Distribution ID"
  value       = aws_cloudfront_distribution.cf.id
}

output "domain_name" {
  description = "Cloudfront Distribution Domain Name"
  value       = aws_cloudfront_distribution.cf.domain_name
}