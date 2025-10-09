terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}


# AWS Provider
provider "aws" {
  region = "ap-south-1"
}

# Azure Provider
provider "azurerm" {
  features {}
}