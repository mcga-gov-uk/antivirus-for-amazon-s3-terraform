data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnets" "private" {
    filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Role"
    values = ["public"]
  }
}

data "aws_ssm_parameter" "ui_alb_allow_ips" {
  name = "/${local.environment}/ui_alb/allowed_ips"
}

data "aws_nat_gateway" "vpc" {
  vpc_id = data.aws_vpc.vpc.id
}
