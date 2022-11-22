resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/delivery-tracker-${var.environment}"

  tags = {
    Project     = "delivery-tracker"
    Environment = var.environment
  }
}
