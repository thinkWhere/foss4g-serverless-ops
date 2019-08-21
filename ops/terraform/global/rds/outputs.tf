output "db_appsstaging_address" {
  description = "Address of apps staging db "
  value       = module.rds_apps_staging.this_db_instance_address
}
