resource "aws_ecs_service" "webserver" {
  name            = "webserver"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.webserver.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]

  load_balancer {
    target_group_arn = aws_lb_target_group.webserver.id
    container_name   = "webserver"
    container_port   = "80"
  }
}

resource "aws_ecs_task_definition" "webserver" {
  family = "webserver"

  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 256,
    "memory": 300,
    "image": "${aws_ecr_repository.repo.repository_url}/webserver:latest",
    "essential": true,
    "name": "webserver",
  }
]
EOF
}
