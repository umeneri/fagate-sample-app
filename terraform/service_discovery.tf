// VPC内部からしかDNSクエリを叩けません
resource "aws_service_discovery_private_dns_namespace" "app_namespace" {
  name        = "example.internal"
  description = "example"
  vpc         = "${aws_vpc.app_vpc.id}"
}

resource "aws_service_discovery_service" "api_service_discovery" {
  name = "api"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.app_namespace.id}"

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_service" "app_ecs_backend_service" {
  name = "${var.env}-backend-service"
  cluster = "${aws_ecs_cluster.app_ecs_cluster.id}"
  task_definition = "${var.env}-backend"
  desired_count = 1
  launch_type = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
//  health_check_grace_period_seconds = 100 // service_registries使用時は不要

  network_configuration {
    subnets = [
      "${aws_subnet.app_private_subnet_a.id}",
      "${aws_subnet.app_private_subnet_c.id}"]
    security_groups = [
      "${aws_security_group.app_sg.id}"
    ]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = "${aws_service_discovery_service.api_service_discovery.arn}"
  }
}
