terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      version = ">= 4.50.0"
      source  = "hashicorp/aws"
    }
  }
}
