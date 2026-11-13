terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.25"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "postgresql" {
  host            = var.database_host
  port            = var.database_port
  username        = var.database_admin_username
  password        = var.database_admin_password
  database        = "postgres"
  sslmode         = "require"
  connect_timeout = 15
}
