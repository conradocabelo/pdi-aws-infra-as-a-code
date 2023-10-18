resource "aws_security_group" "spring_api_sg" {
  name   = "spring_api_sg"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "hub_exchange_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "ecs_task" {
  for_each = tomap({ for t in var.ecs_tasks : "${t.family}" => t })

  family                   = each.value.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory

  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = file("./${path.module}/${each.value.enviroment_file}")
}

resource "aws_service_discovery_service" "service_port_8080" {
  for_each = tomap({ for t in var.ecs_tasks : "${t.family}" => t })

  name         = "ms-${each.key}"
  namespace_id = var.private_namespace.id
  dns_config {
    namespace_id   = var.private_namespace.id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 10
      type = "A"
    }

    dns_records {
      type = "SRV"
      ttl  = 10
    }
  }

  health_check_custom_config {
    failure_threshold = 5
  }
}

resource "aws_ecs_service" "service" {
  for_each = tomap({ for t in var.ecs_tasks : "${t.family}" => t })

  name            = "ms-${each.key}"
  cluster         = aws_ecs_cluster.hub_exchange_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task["${each.key}"].arn
  desired_count   = 1
  launch_type     = "FARGATE"

  service_registries {
    registry_arn = aws_service_discovery_service.service_port_8080["${each.key}"].arn
    port         = 8080
  }

  network_configuration {
    security_groups  = [aws_security_group.spring_api_sg.id]
    subnets          = var.public_subnets.*
    assign_public_ip = true
  }
}