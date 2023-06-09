resource "aws_lb" "ALB" {
  name               = "ALB-TF"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet1_public.id, aws_subnet.subnet2_public.id]
  

  enable_deletion_protection = false
}

############# Load-balancer-listener

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

###### Load-balancer target-group

resource "aws_lb_target_group" "nginx" {
  name     = "nginx-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

######### Autoscaling-group  #######

resource "aws_autoscaling_group" "asg_to" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.subnet3_private.id, aws_subnet.subnet4_private.id]
  target_group_arns = [aws_lb_target_group.nginx.arn]
  launch_template {
    id      = aws_launch_template.first_template.id
    version = "$Latest"
  }
  tag {
    key = "Name"
    value = "instanciika"
    propagate_at_launch = true
  }
}

#### Create Auto Scale Policy ######

resource "aws_autoscaling_policy" "the_policy" {
  name                   = "auto-scale-policy-terraform-test"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg_to.name
}

##### Cloudwatch config ######
resource "aws_cloudwatch_metric_alarm" "alarm1" {
  alarm_name                = "terraform-alarm1234"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions = [aws_autoscaling_policy.the_policy.arn]
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg_to.name
  }
}

####### Attach Policy ########
resource "aws_autoscaling_attachment" "asg_attachment_lb" {
  autoscaling_group_name = aws_autoscaling_group.asg_to.id
  lb_target_group_arn = aws_lb_target_group.nginx.arn
}

