resource "aws_lb" "public_load_balancer" {
  name               = "public-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webserver.id]
  subnets            = values(aws_subnet.public_subnets).*.id

  tags = {
    Name = "public-app-load-balancer"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.public_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.webserver.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "webserver" {
  name       = "webserver"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_lb.public_load_balancer]

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}
