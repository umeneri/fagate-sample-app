resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = "${var.env}-${var.task_name}-cluster"
}

resource "aws_ecs_service" "app_ecs_frontend_service" {
  name = "${var.env}-frontend-service"
  cluster = "${aws_ecs_cluster.app_ecs_cluster.id}"
  task_definition = "${var.env}-frontend"
  desired_count = 1
  launch_type = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  health_check_grace_period_seconds = 100
  depends_on = [aws_lb.app_lb] // 依存の自動解決ができないため

  network_configuration {
    subnets = [
      "${aws_subnet.app_private_subnet_a.id}",
      "${aws_subnet.app_private_subnet_c.id}"]
    security_groups = [
      "${aws_security_group.app_sg.id}"
    ]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.app_target_group.arn}"
    container_name = "frontend"
    container_port = 80
  }
}

resource "aws_cloudwatch_log_group" "app_log" {
  name = "/ecs/fargate/task"
  retention_in_days = 14
}
