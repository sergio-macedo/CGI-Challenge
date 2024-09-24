# resource "aws_alb" "cgi_load_balancer" {
#   name = "cgi-lb"
#   subnets         = aws_subnet.CGI_challenge_pub_subnet[*].id
#   security_groups = [aws_security_group.alb_sg.id]
#   internal = false
#   load_balancer_type = "application"
#   enable_deletion_protection = false

#   tags = merge(
#     local.tags,
#     {
#       Name = "${var.project_name}-alb"
#     }
#   )

# }


# resource "aws_lb_target_group" "cgi_target_group" {
#   name     = "${var.project_name}-tg"
#   port     = 3000                     # Port your application is running on
#   protocol = "HTTP"                   # Protocol used by the target group
#   vpc_id   = aws_vpc.cgi_vpc.id               # VPC ID where your EC2 instance is located
#   target_type = "instance"

# }

# resource "aws_lb_listener" "port_3000" {
#   load_balancer_arn = aws_alb.cgi_load_balancer.id
#   port              = 3000
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.cgi_target_group.arn
#   }

#   tags = merge(
#     local.tags,
#     {
#       Name = "${var.project_name}-vpc"
#     }
#   )

# }

# resource "aws_alb_listener" "http" {
#   load_balancer_arn = aws_alb.cgi_load_balancer.id
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.cgi_target_group.id
#   }

#   tags = merge(
#     local.tags,
#     {
#       Name = "${var.project_name}-vpc"
#     }
#   )

# }


# resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
#   count = length(var.azs)
#   target_group_arn = aws_lb_target_group.cgi_target_group.arn
#   target_id        = aws_instance.cgi_node_instance[count.index].id  
#   port             = 3000      
# }                        


