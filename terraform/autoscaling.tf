resource "aws_launch_template" "app" {
  name_prefix   = "employee-mgmt-app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.app.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_profile.name
  }

  user_data = base64encode(templatefile("${path.module}/scripts/user-data.sh", {
    db_host   = aws_db_instance.mysql.address
    s3_bucket = aws_s3_bucket.uploads.bucket
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "employee-mgmt-app-server"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name             = "employee-mgmt-asg"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  vpc_zone_identifier = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id
  ]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "employee-mgmt-asg-instance"
    propagate_at_launch = true
  }
}