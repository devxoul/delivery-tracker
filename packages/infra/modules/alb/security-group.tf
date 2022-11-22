resource "aws_security_group" "alb" {
  name   = "delivery-tracker-${var.environment}-lb"
  vpc_id = var.vpc_id

  tags = {
    Name        = "sg-delivery-tracker-${var.environment}-lb"
    Project     = "delivery-tracker"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ingress_http" {
  description       = "All HTTP Traffic"
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_https" {
  description       = "All HTTPS Traffic"
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress" {
  description       = "All Traffic"
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}
