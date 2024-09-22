
# resource "aws_ecs_cluster" "ecs_cluster" {
#   name = "my-ecs-cluster"
#       tags = merge(
#     local.tags,
#     {
#       Name = "${var.project_name}-ecs"
#     }
#   )
# }


# resource "aws_ecs_cluster_capacity_providers" "swiat-preprod-capacity-provider" {
#   cluster_name = aws_ecs_cluster.ecs_cluster.name

#   capacity_providers = ["FARGATE"]

#   default_capacity_provider_strategy {
#     base              = 0
#     weight            = 1
#     capacity_provider = "FARGATE"
#   }
# }


# resource "aws_ecs_service" "my_service" {
#   name            = "my-ecs-service"
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.my_task.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets = [aws_subnet.private1.id]
#     security_groups = [aws_security_group.ecs_container_security_group.id]
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.my_tg.arn
#     container_name   = "my-app"
#     container_port   = 80
#   }
#   depends_on = [aws_lb_listener.front_end]
#     tags = merge(
#    local.tags,
#     {
#       Name = "${var.project_name}-service"
#     }
#   )
# }




# # ECS Task Definition
# resource "aws_ecs_task_definition" "my_task" {
#   family                   = "my-task"
#   network_mode              = "awsvpc"
#   requires_compatibilities  = ["FARGATE"]
#   execution_role_arn        = aws_iam_role.ecsTaskExecutionRole.arn
#   task_role_arn             = aws_iam_role.ecsTaskExecutionRole.arn
#   cpu                       = "512"   # Change according to your needs
#   memory                    = "1024"   # Change according to your needs

#   container_definitions = jsonencode([
#     {
#       name      = "my-app"
#       image     = "${aws_ecr_repository.my_app_repo.repository_url}:latest"
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#           protocol      = "tcp"
#         }
#       ]
#     }
#   ])
# }

# # IAM Role for ECS Task Execution
# resource "aws_iam_role" "ecsTaskExecutionRole" {
#   name = "ecsTaskExecutionRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "ecs-tasks.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
#   role       = aws_iam_role.ecsTaskExecutionRole.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }