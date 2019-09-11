locals {
  # Define locals for shared vars
  create      = true
}

module "postgres_apps_staging_sg" {
  # Uses security group module from Terraform Module Registry
  # https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  create = local.create

  name        = "postgres_apps_staging"
  description = "SG for postgres_apps_staging db"
  vpc_id      = data.terraform_remote_state.staging_vpc.outputs.vpc_id

  # TODO to make this simple to demo we've allow all traffic to DB you NEVER WANT THIS IN PRODUCTION, LIMIT IP RANGE
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["postgresql-tcp" ]

  egress_rules      = ["all-all"]
}



module "rds_apps_staging" {
    # Use terraform rds module from registry - https://registry.terraform.io/modules/terraform-aws-modules/rds/aws
    source = "terraform-aws-modules/rds/aws"
    version = "~> 2.0"

    identifier        = "appsstaging"
    name              = "appsstaging"

    engine              = "postgres"
    engine_version      = "11.4"
    family              = "postgres11"
    instance_class      = "db.t3.micro"
    allocated_storage   = 20
    storage_encrypted   = "false"
    port                = "5432"
    publicly_accessible = "true"

    maintenance_window = "Mon:00:00-Mon:03:00"
    backup_window      = "03:00-06:00"

    vpc_security_group_ids = [module.postgres_apps_staging_sg.this_security_group_id]

    # AWS determines this from the db subnets you setup in your vpc.  Ensures rds instance setup in correct
    # subnet with appropriate internet access.
    db_subnet_group_name = data.terraform_remote_state.staging_vpc.outputs.database_subnet_group

    # Never skip final snapshot, ensures a backup is available if db is destroyed
    skip_final_snapshot  = "false"
    final_snapshot_identifier = "apps-staging-final-${uuid()}"

    # disable backups to create DB faster
    backup_retention_period = 0

    username = "pgadmin"
    password = var.db_appsstaging_pass

    create_db_instance = local.create
}