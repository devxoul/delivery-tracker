terraform {
  backend "remote" {
    organization = "indent"

    workspaces {
      prefix = "delivery-tracker-"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Project     = "delivery-tracker"
      Environment = local.config.environment
      Terraform   = true
    }
  }
}

locals {
  config = {
    prod = {
      environment = "prod"
      domain_name = "delivery-tracker.indentcorp.com"
      vpc_id      = "vpc-06346b61"
      public_subnets = [
        "subnet-5bfbe212",
        "subnet-09a9e252",
        "subnet-e110f0ca",
      ]
      private_subnets = [
        "subnet-5bfbe212",
        "subnet-09a9e252",
        "subnet-e110f0ca",
      ]
      ecs_desired_count = 4
    }
    dev = {
      environment = "dev"
      domain_name = "delivery-tracker-dev.indentcorp.com"
      vpc_id      = "vpc-0ec41569c4883b9ee"
      public_subnets = [
        "subnet-00c72d073f9ac1fd9",
        "subnet-07b8deed618ebd60c",
        "subnet-0d9df835d5db4a9bf",
      ]
      private_subnets = [
        "subnet-0b325c55227bc0e0f",
        "subnet-02e3f88277d180bd3",
        "subnet-045efcb67f6404af6",
      ]
      ecs_desired_count = 2
    }
  }[replace(terraform.workspace, "delivery-tracker-", "")]
}

module "iam" {
  source = "./modules/iam"

  environment = local.config.environment
}

module "route53" {
  source = "./modules/route53"

  environment            = local.config.environment
  domain_name            = local.config.domain_name
  cloudfront_zone_id     = module.cloudfront.zone_id
  cloudfront_domain_name = module.cloudfront.domain_name
}

module "cloudfront" {
  source = "./modules/cloudfront"

  environment     = local.config.environment
  domain_name     = local.config.domain_name
  alb_domain_name = module.alb.domain_name
}

module "alb" {
  source = "./modules/alb"

  environment           = local.config.environment
  vpc_id                = local.config.vpc_id
  subnets               = local.config.public_subnets
  ecs_security_group_id = module.ecs.security_group_id
}

module "ecs" {
  source = "./modules/ecs"

  environment            = local.config.environment
  vpc_id                 = local.config.vpc_id
  subnets                = local.config.private_subnets
  target_group_arn       = module.alb.target_group_arn
  iam_execution_role_arn = module.iam.ecs_execution_role.arn
  iam_task_role_arn      = module.iam.ecs_task_role.arn
  sha                    = var.sha
  desired_count          = local.config.ecs_desired_count
}
