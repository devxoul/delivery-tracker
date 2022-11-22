resource "aws_iam_role" "execution" {
  name               = "delivery-tracker-${var.environment}-ecs-execution"
  assume_role_policy = file("${path.module}/assume-role.json")
}

resource "aws_iam_role_policy_attachment" "managed" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name               = "delivery-tracker-${var.environment}-ecs-task"
  assume_role_policy = file("${path.module}/assume-role.json")
}
