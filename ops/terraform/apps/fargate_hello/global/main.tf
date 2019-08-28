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
