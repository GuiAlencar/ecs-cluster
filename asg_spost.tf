resource "aws_autoscaling_group" "spots" {
  name_prefix = format("%s-spots", var.project_name)

  vpc_zone_identifier = [
    data.aws_ssm_parameter.private_subnet_1a.value,
    data.aws_ssm_parameter.private_subnet_1b.value,
    data.aws_ssm_parameter.private_subnet_1c.value
  ]

  desired_capacity = var.cluster_spot_desired_size
  max_size = var.cluster_spot_max_size
  min_size = var.cluster_spot_min_size

  ## CONECTANDO O LAUNCH TEMPLATE AO ASG
  launch_template {
    id      = aws_launch_template.spots.id
    version = aws.launch_template.spots.latest_version
  }

  tag {
    key = "AmazonECSManaged"
    value = "true"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "spots" {
    name = format("%s-spots", var.project_name)
    
    auto_scaling_group_provider {
      auto_scaling_group_arn = aws_autoscaling_group.spots.arn

        managed_scaling {
            maximum_scaling_step_size = 10
            minimum_scaling_step_size = 1
            status = "ENABLED"
            target_capacity = 90
        }
    }
}