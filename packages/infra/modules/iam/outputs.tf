output "ecs_execution_role" {
  value = aws_iam_role.execution
}

output "ecs_task_role" {
  value = aws_iam_role.task
}
