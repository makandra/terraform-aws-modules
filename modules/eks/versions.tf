terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      version = "~> 4.6"
      source  = "hashicorp/aws"
    }
    null = {
      version = ">= 3.2"
      source  = "hashicorp/null"
    }
    kubernetes = {
      version = ">= 2.5"
      source  = "hashicorp/kubernetes"
    }
  }
}
