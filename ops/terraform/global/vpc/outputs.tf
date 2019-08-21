output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet ids"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "Public subnet ids"
  value       = module.vpc.public_subnets
}

output "database_subnet_group" {
  description = "Database subnet group"
  value       = module.vpc.database_subnet_group
}
