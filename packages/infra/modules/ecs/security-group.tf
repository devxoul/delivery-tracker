resource "aws_security_group" "ecs" {
  name   = "delivery-tracker-${var.environment}-ecs"
  vpc_id = var.vpc_id

  tags = {
    Name = "sg-delivery-tracker-${var.environment}-ecs"
  }
}

resource "aws_security_group_rule" "ingress" {
  description              = "All Private Traffic"
  security_group_id        = aws_security_group.ecs.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "all"
  source_security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "egress" {
  description       = "All Traffic"
  security_group_id = aws_security_group.ecs.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}
