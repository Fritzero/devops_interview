resource "aws_ecs_cluster" "cluster" {
  name = "devops-interview-cluster"
}

resource "aws_autoscaling_group" "cluster" {
  name                      = "devops-interview-webserver-asg"
  vpc_zone_identifier       = values(aws_subnet.public_subnets).*.id
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.cluster-lc.name
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]
}

resource "aws_autoscaling_policy" "cluster" {
  name                   = "devops-interview-webserver-auto-scaling"
  autoscaling_group_name = aws_autoscaling_group.cluster.name
}

resource "aws_launch_configuration" "cluster-lc" {
  name_prefix = "devops-interview-webserver-lc"
  security_groups = [
    aws_security_group.webserver.id,
    aws_security_group.icmp.id,
    aws_security_group.google.id,
    aws_security_group.internal.id
  ]

  image_id                    = data.aws_ami.latest_ecs.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.ecs-ec2-role.id
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
