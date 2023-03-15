terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      version = "~> 4.6"
    }
    null = {
      version = ">= 3.2"
    }
    kubernetes = {
      version = ">= 2.5"
    }
  }
}
