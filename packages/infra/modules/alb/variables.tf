variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
}
