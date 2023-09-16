# create launch template
resource "aws_launch_template" "app_lt" {
    name = "${var.project_name}-lt1"
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_name
    user_data = filebase64("../modules/asg/config.sh")

    vpc_security_group_ids = [var.client_sg]
    tags = {
      Name = "${var.project_name}-tpl"
    }
}

# create autoscalling group
resource "aws_autoscaling_group" "app_asg" {
    name = "${var.project_name}-asg"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_cap
    health_check_grace_period = 300
    health_check_type = var.asg_health_check_type
    vpc_zone_identifier = [var.pri_sub_3c_id,var.pri_sub_4d_id]
    target_group_arns = [var.tg_arn]

    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]
    metrics_granularity = "1Minute"

    launch_template {
      id = aws_launch_template.app_lt.id
      version = aws_launch_template.app_lt.latest_version
    }
}

# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
    name = "${var.project_name}-asg-scale-up"
    autoscaling_group_name = aws_autoscaling_group.app_asg.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "1"
    cooldown = "300"
    policy_type = "SimpleScaling"
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
    alarm_name = "${var.project_name}-asg-scale-up-alarm"
    alarm_description = "asg-scale-up-cpu-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "70"
    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.app_asg.name
    }
    actions_enabled = true
    alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
    name = "${var.project_name}-asg-scale-down"
    autoscaling_group_name = aws_autoscaling_group.app_asg.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "-1"
    cooldown = "300"
    policy_type = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
    alarm_name = "${var.project_name}-asg-scale-down-alarm"
    alarm_description = "asg-scale-down-cpu-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "5"
    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.app_asg.name
    }
    actions_enabled = true
    alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}
