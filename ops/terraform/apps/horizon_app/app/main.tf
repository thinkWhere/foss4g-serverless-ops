######
# S3
######

resource "aws_s3_bucket" "horizon_app_bucket" {
  # This bucket used by the horizon app to write redered images to
  bucket = "horizon-viewer-test1"

  tags = {
    Owner       = "foss4g"
    Name        = "horizon-app-test1"
    Environment = "Production"
  }
}

#########
# ECR
#########

resource "aws_ecr_repository" "horizon_app_ecr" {
  # Create an Elastic Container Repo for the horizon app project
  name = "horizon-app"
}


##########
# ECS
##########

resource "aws_ecs_cluster" "horizon_app_cluster" {
  # Creates new ECS cluster
  name = "horizon-app-cluster"
}

#######################
# Cloud Watch
######################

resource "aws_cloudwatch_log_group" "horizon_app_cloudwatch_logs" {
  # Create log group for collection and analysis.  Logs that the container will generate will automatically
  # be pushed to this group
  name = "horizon-app-cluster"
  retention_in_days = 7

  tags = {
    Application = "horizon-app"
  }
}


#######################
# Fargate
######################

resource "aws_ecs_task_definition" "horizon_app_task" {
  # Task definition describes docker container, logging etc
  family                   = "horizon-app"

  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"  # allocates task a network interface

  execution_role_arn       = data.terraform_remote_state.iam_ecs.outputs.ecs_service_role
  task_role_arn            = data.terraform_remote_state.iam_ecs.outputs.ecs_task_role

  container_definitions    = templatefile("task_definitions/horizon_app.json",
                                { region = var.region
                                  repo_url =  aws_ecr_repository.horizon_app_ecr.repository_url
                                  cloud_watch_group = aws_cloudwatch_log_group.horizon_app_cloudwatch_logs.name})
}


#######################
# Security Group
######################
module "ecs_sg" {
  # Uses security group module from Terraform Module Registry
  # https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "horizon-app-ecs"
  description = "SG for horizon app"
  vpc_id      = data.terraform_remote_state.global_vpc.outputs.vpc_id

  egress_rules         = ["all-all"]

}


########################
# CloudWatch
########################

resource "aws_cloudwatch_event_rule" "fargate_every_five_mins" {
  # Create a new rule that will schedule container every 5 mins
  name                = "horizon-app-five-mins"
  description         = "Run fargate every 5 mins"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  # Wire scheduler to ecs container

  target_id = "run-scheduled-task-every-hour"
  arn       = aws_ecs_cluster.horizon_app_cluster.arn
  rule      = aws_cloudwatch_event_rule.fargate_every_five_mins.name
  role_arn  = data.terraform_remote_state.iam_ecs.outputs.ecs_events_role

  ecs_target {
    launch_type         = "FARGATE"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.horizon_app_task.arn
    platform_version    = "LATEST"

    network_configuration {
      # Note in my testing this won't work without a security group and public IP
      subnets = data.terraform_remote_state.global_vpc.outputs.public_subnet_ids
      security_groups = [module.ecs_sg.this_security_group_id]
      assign_public_ip = true
    }
  }
}