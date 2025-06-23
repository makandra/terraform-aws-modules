terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      version = ">= 4.51.0"
      source  = "hashicorp/aws"
    }
  }
}
