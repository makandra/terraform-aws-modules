terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      version = ">= 5.83.0"
      source  = "hashicorp/aws"
    }
  }
}
