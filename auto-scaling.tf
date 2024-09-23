resource "aws_appautoscaling_target" "cgi-auto-target" {
    min_capacity = var.auto_scaling.min_capacity
    max_capacity = var.auto_scaling.max_capacity
    resource_id = "service/${aws_ecs_cluster.cgi_cluster.name}/${aws_ecs_service.ecs-service.name}"
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace = "ecs"
    
}

resource "aws_appautoscaling_policy" "cgi_autoscaling_memory_policy" {
    
    policy_type = "TargetTrackingScaling"
    name = "memory-autoscaling"
    resource_id = aws_appautoscaling_target.cgi-auto-target.resource_id
    scalable_dimension = aws_appautoscaling_target.cgi-auto-target.scalable_dimension
    service_namespace = aws_appautoscaling_target.cgi-auto-target.service_namespace

    target_tracking_scaling_policy_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ECSServiceAverageMemoryUtilization"
      }
      target_value = var.auto_scaling.target_value
      scale_in_cooldown =  var.auto_scaling.scale_in_cooldown
      scale_out_cooldown =  var.auto_scaling.scale_out_cooldown
    }


}

resource "aws_appautoscaling_policy" "cgi_autoscaling_CPU_policy" {
    
    policy_type = "TargetTrackingScaling"
    name = "cpu-autoscaling"
    resource_id = aws_appautoscaling_target.cgi-auto-target.resource_id
    scalable_dimension = aws_appautoscaling_target.cgi-auto-target.scalable_dimension
    service_namespace = aws_appautoscaling_target.cgi-auto-target.service_namespace

    target_tracking_scaling_policy_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ECSServiceAverageCPUUtilization"
      }
      target_value = var.auto_scaling.target_value
      scale_in_cooldown =  var.auto_scaling.scale_in_cooldown
      scale_out_cooldown =  var.auto_scaling.scale_out_cooldown
    }


}

resource "aws_appautoscaling_policy" "cgi_autoscaling_alb_request_count" {
    
    policy_type = "TargetTrackingScaling"
    name = "alb-request-count-autoscaling"
    resource_id = aws_appautoscaling_target.cgi-auto-target.resource_id
    scalable_dimension = aws_appautoscaling_target.cgi-auto-target.scalable_dimension
    service_namespace = aws_appautoscaling_target.cgi-auto-target.service_namespace

    target_tracking_scaling_policy_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ALBRequestCountPerTarget"
        resource_label = "${aws_alb.fargate_load_balancer.arn_suffix}/${aws_alb_target_group.cgi_tg.arn_suffix}"
      }
      target_value = var.auto_scaling.target_value

    }


}