terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      version = ">= 6.18.0"
      source  = "hashicorp/aws"
    }
  }
}
