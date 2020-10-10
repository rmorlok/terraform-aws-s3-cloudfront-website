terraform {
  required_providers {
    aws = {
      version = ">= 2.6.0"
      source = "hashicorp/aws"
    }

    archive = {
      version = ">= 1.2.0"
      source = "hashicorp/archive"
    }
  }
}