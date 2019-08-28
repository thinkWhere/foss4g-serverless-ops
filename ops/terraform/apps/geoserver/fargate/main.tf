
#######################
# Security Group
######################
module "ecs_sg" {
  # Uses security group module from Terraform Module Registry
  # https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "geoserver-ecs-sg"
  description = "SG for serverless geoserver"
  vpc_id      = data.terraform_remote_state.global_vpc.outputs.vpc_id

  ingress_cidr_blocks  = ["0.0.0.0/0"]
  ingress_rules        = ["all-all"]
  egress_rules         = ["all-all"]

}


#######################
# ALB
######################

module "alb" {
  # Use ALB module from terraform registry
  # https://registry.terraform.io/modules/terraform-aws-modules/alb/aws
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 4.0"

  load_balancer_name = "geoserver-ecs-alb"
  security_groups    = [module.ecs_sg.this_security_group_id]
  logging_enabled    = false  # TODO enable logs to see what we get
  subnets            = data.terraform_remote_state.global_vpc.outputs.public_subnet_ids
  vpc_id             = data.terraform_remote_state.global_vpc.outputs.vpc_id

  http_tcp_listeners_count = 1
  http_tcp_listeners  = [
    {
      port               = 80
      protocol           = "HTTP"
      type               = "forward"
      target_group_index = 0
    },
  ]

  target_groups_count = 1

  # Target group must specify container port, and be of type ip
  # For simplicity we're always creating two target groups, but if we're doing a standard deploy only blue
  # will ever be used.  Obviously for blue/green both target groups will be utilised.
  target_groups = [{
    name                  = "geoserver-ecs"
    backend_protocol      = "HTTP"
    backend_port          = 8080
    target_type           = "ip"
    health_check_interval = 30
    health_check_timeout  = 5
    slow_start            = 60
    health_check_path     = "/geoserver/web/"
  },
  ]
}


#######################
# Fargate
######################

resource "aws_ecs_service" "geoserver_ecs_service" {
  # Defines the ECS service geoserver will live in
  name             = "geoserver-fargate"
  cluster          = data.terraform_remote_state.global_geoserver_ecs.outputs.ecs_cluster_arn
  task_definition  = data.terraform_remote_state.global_geoserver_ecs.outputs.task_definition_arn
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0
  health_check_grace_period_seconds  = 10

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets          = data.terraform_remote_state.global_vpc.outputs.private_subnet_ids
    security_groups  = [module.ecs_sg.this_security_group_id]
    assign_public_ip = false   # We're on private subnet
  }

  load_balancer {
    container_name   = "geoserver-fargate"   # Taken from task definition
    container_port   = 8080  # Must map to port that container exposes
    target_group_arn = module.alb.target_group_arns[0]  # Can hardwire to first element as we know we only create one
  }
}
