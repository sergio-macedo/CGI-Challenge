resource "aws_alb" "fargate_load_balancer" {

  subnets         = aws_subnet.CGI_challenge_pub_subnet[*].id
  security_groups = [aws_security_group.alb_sg.id]
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-alb"
    }
  )

}

resource "aws_alb_target_group" "cgi_tg" {
  vpc_id      = aws_vpc.cgi_vpc.id
  name        = "cgi-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"


  health_check {
    unhealthy_threshold = "2"
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/healthcheck"
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-tg"
    }
  )
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.fargate_load_balancer.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.cgi_tg.arn
  }
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )

}




resource "aws_security_group" "alb_sg" {
  name   = "cgi-alb-sg"
  vpc_id = aws_vpc.cgi_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-alb-sg"
    }
  )




}