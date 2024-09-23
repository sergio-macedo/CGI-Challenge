resource "aws_ecs_cluster" "cgi_cluster" {
  name = "cgi_cluster"

  # setting {
  #   name  = "containerInsights"
  #   value = "enabled"
  # }
}

resource "aws_ecs_task_definition" "cgi_task_definitions" {
  family                   = "nodeapp"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs.fargate_cpu
  memory                   = var.ecs.fargate_memory

  container_definitions = jsonencode([
    {
      name      = var.ecs.container_name,
      image     = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/cgi-ecr-node",
      essential = true,
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/nodeapp"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      },
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ],

    }
  ])
}

resource "aws_ecs_service" "ecs-service" {
  name                              = "ecs-cgi-service"
  cluster                           = aws_ecs_cluster.cgi_cluster.id
  task_definition                   = aws_ecs_task_definition.cgi_task_definitions.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 30



  network_configuration {
    subnets          = aws_subnet.CGI_challenge_pub_subnet.*.id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true


  }
  load_balancer {
    target_group_arn = aws_alb_target_group.cgi_tg.id
    container_name   = var.ecs.container_name
    container_port   = 3000
  }

}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/nodeapp"
  retention_in_days = 7 # Adjust retention period as needed
}