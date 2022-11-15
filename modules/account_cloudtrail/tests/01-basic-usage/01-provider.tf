terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }

}

provider "aws" {}
