# resource "aws_launch_template" "eks_worker" {
#   name_prefix   = "eks-worker-launch-template"
#   image_id      = "ami-0df0e7600ad0913a9" # Use a valid EKS optimized AMI
#   instance_type = "t3.small"

#   key_name = "wsl_key_pair" # Optional: for SSH access

#   iam_instance_profile {
#     name = aws_iam_instance_profile.eks_node_instance_profile.name
#   }

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [aws_security_group.allow_ec2.id]
#   }

#   tag_specifications {
#     resource_type = "instance"

#     tags = merge(
#       local.tags,
#       {
#         Name = "${var.project_name}-asg"
#       }
#     )
#   }
# }

# resource "aws_iam_instance_profile" "eks_node_instance_profile" {
#   name = "eks_node_instance_profile"
#   role = aws_iam_role.eks_unified_role.name
# }

# resource "aws_autoscaling_group" "eks_worker_asg" {
#   name                = "eks_auto_scaling"
#   desired_capacity    = 2
#   max_size            = 4
#   min_size            = 1
#   vpc_zone_identifier = aws_subnet.CGI_challenge_pub_subnet.*.id
#   launch_template {
#     id      = aws_launch_template.eks_worker.id
#     version = "$Latest"
#   }

#   tag {
#     key                 = "kubernetes.io/cluster/${aws_eks_cluster.example.name}"
#     value               = "owned"
#     propagate_at_launch = true
#   }
# }

# resource "aws_autoscaling_policy" "scale_up" {
#   name               = "scale-up"
#   scaling_adjustment = 1
#   adjustment_type    = "ChangeInCapacity"
#   cooldown           = 300

#   autoscaling_group_name = aws_autoscaling_group.eks_worker_asg.name
# }

# resource "aws_autoscaling_policy" "scale_down" {
#   name               = "scale-down"
#   scaling_adjustment = -1
#   adjustment_type    = "ChangeInCapacity"
#   cooldown           = 240

#   autoscaling_group_name = aws_autoscaling_group.eks_worker_asg.name
# }

# resource "aws_cloudwatch_metric_alarm" "cpu_high" {
#   alarm_name          = "cpu-high"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "60"

#   alarm_actions = [aws_autoscaling_policy.scale_up.arn]
#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.eks_worker_asg.name
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "cpu_low" {
#   alarm_name          = "cpu-low"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "30"

#   alarm_actions = [aws_autoscaling_policy.scale_down.arn]
#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.eks_worker_asg.name
#   }
# }