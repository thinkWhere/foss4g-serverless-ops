#########
# ECR
#########

resource "aws_ecr_repository" "fargate_hello" {
  # Create an Elastic Container Repo for the flask-bootstrap project
  name = "fargate-hello"
}


##########
# ECS
##########

resource "aws_ecs_cluster" "fargate_hello_cluster" {
  # Creates new ECS cluster
  name = "fargate-hello-cluster"
}

#######################
# Cloud Watch
######################

resource "aws_cloudwatch_log_group" "fargate_hello_cloudwatch_logs" {
  # Create log group for collection and analysis.  Logs that the container will generate will automatically
  # be pushed to this group
  name = "fargate-hello-cluster"
  retention_in_days = 7

  tags = {
    Application = "fargate-hello"
  }
}


#######################
# Fargate
######################

resource "aws_ecs_task_definition" "fargate-hello-task" {
  # Task definition describes docker container, logging etc
  family                   = "fargate-hello"

  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"  # allocates task a network interface

  execution_role_arn       = data.terraform_remote_state.iam_ecs.outputs.ecs_service_role
  task_role_arn            = data.terraform_remote_state.iam_ecs.outputs.ecs_task_role

  container_definitions    = templatefile("task_definitions/fargate_hello.json",
                                { region = var.region
                                  repo_url =  aws_ecr_repository.fargate_hello.repository_url
                                  cloud_watch_group = aws_cloudwatch_log_group.fargate_hello_cloudwatch_logs.name})
}


#######################
# Security Group
######################
module "ecs_sg" {
  # Uses security group module from Terraform Module Registry
  # https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "fargate-hello-ecs"
  description = "SG for fargate hello"
  vpc_id      = data.terraform_remote_state.global_vpc.outputs.vpc_id

  egress_rules         = ["all-all"]

}


########################
# CloudWatch
########################

resource "aws_cloudwatch_event_rule" "fargate_every_five_mins" {
  # Create a new rule that will schedule container every 5 mins
  name                = "fargate-hello-five-mins"
  description         = "Run fargate every 5 mins"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  target_id = "run-scheduled-task-every-hour"
  arn       = aws_ecs_cluster.fargate_hello_cluster.arn
  rule      = aws_cloudwatch_event_rule.fargate_every_five_mins.name
  role_arn  = data.terraform_remote_state.iam_ecs.outputs.ecs_events_role


  ecs_target {
    launch_type         = "FARGATE"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.fargate-hello-task.arn
    platform_version    = "LATEST"

    network_configuration {
      subnets = data.terraform_remote_state.global_vpc.outputs.public_subnet_ids
      security_groups = [module.ecs_sg.this_security_group_id]
      assign_public_ip = true
    }
  }




}