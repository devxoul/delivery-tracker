variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "iam_execution_role_arn" {
  type = string
}

variable "iam_task_role_arn" {
  type = string
}

variable "image_tag" {
  type = string
}
