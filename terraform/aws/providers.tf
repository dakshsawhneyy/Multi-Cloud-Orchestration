terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}


# AWS Provider
provider "aws" {
  region = "ap-south-1"
}