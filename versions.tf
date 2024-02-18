terraform {
  backend "s3" {
    bucket               = "mcauk-terraform-tfstate"
    key                  = "smart-av"
    encrypt              = "true"
    workspace_key_prefix = "smart-env"
    region               = "eu-west-2"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    awscc = {
      source = "hashicorp/awscc"
    }
  }
  required_version = ">= 1.6"
}

provider "aws" {
  region = var.aws_region
}

provider "awscc" {
  region = var.aws_region
}

