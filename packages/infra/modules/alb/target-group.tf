resource "aws_alb_target_group" "default" {
  name        = "delivery-tracker-${var.environment}-${substr(uuid(), 0, 4)}"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/carriers"
    protocol = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "random_string" "alb_suffix" {
  length  = 4
  upper   = false
  special = false
}
