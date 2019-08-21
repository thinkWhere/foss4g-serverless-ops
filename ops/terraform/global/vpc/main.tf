locals {
  app_name = "foss4g-ops"
}


module "vpc" {
    # Use terraform vpc module from registry - https://github.com/terraform-aws-modules/terraform-aws-vpc
    source  = "terraform-aws-modules/vpc/aws"
    version = "~> 2.5"

    name = local.app_name
    cidr = "10.10.0.0/16"

    azs              = ["us-east-1a", "us-east-1b"]
    private_subnets  = ["10.10.11.0/24", "10.10.12.0/24"]
    public_subnets   = ["10.10.21.0/24", "10.10.22.0/24"]
    database_subnets = ["10.10.31.0/24", "10.10.32.0/24"]

    # NAT gateway enables instances in a private subnet to connect to the internet or other AWS services,
    # but prevent the internet from initiating a connection with those instances
    enable_nat_gateway = true
    single_nat_gateway = true  # All private subnets will route traffic through one NAT gateway

    # Indicates whether instances with public IP addresses get corresponding public DNS hostnames.
    enable_dns_hostnames = true
    enable_dns_support   = true

    # Options make db subnet public and allow external clients to connect to database
    # NOTE important to configure db security groups
    create_database_subnet_group           = true
    create_database_subnet_route_table     = true
    create_database_internet_gateway_route = true

    tags = {
        Name        = local.app_name
        Owner       = "thinkWhere"
        Environment = "staging"
    }

    database_subnet_group_tags = {
        Name = "${local.app_name}-db-group"
    }

    database_subnet_tags = {
        Name = "${local.app_name}-db"
    }

    private_subnet_tags = {
        Name = "${local.app_name}-private"
    }

    public_subnet_tags = {
        Name = "${local.app_name}-public"
    }

    private_route_table_tags = {
        Name = "${local.app_name}-private"
    }

    public_route_table_tags = {
        Name = "${local.app_name}-public"
    }
}
