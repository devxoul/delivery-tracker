resource "aws_ecs_cluster" "cluster" {
  name = "delivery-tracker-${var.environment}"

  tags = {
    Project     = "delivery-tracker"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "service" {
  name            = "delivery-tracker-${var.environment}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 3

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "apiserver"
    container_port   = 8080
  }

  network_configuration {
    subnets = var.subnets
    security_groups = [
      aws_security_group.ecs.id,
    ]
    assign_public_ip = true
  }

  tags = {
    Project     = "delivery-tracker"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "delivery-tracker"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.iam_execution_role_arn
  task_role_arn            = var.iam_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "apiserver"
      image     = "599087160579.dkr.ecr.ap-northeast-1.amazonaws.com/delivery-tracker:${var.image_tag}"
      essential = true

      cpu         = null
      environment = null
      mountPoints = null
      volumesFrom = null

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${aws_cloudwatch_log_group.ecs.name}"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
  }
}
