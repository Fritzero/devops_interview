output "lb_output" {
  value = aws_lb.public_load_balancer.dns_name
}
