output "alb_dns_address" {
  description = "The dns address of the alb"
  value       = module.alb.dns_name
}