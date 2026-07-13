terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Optional: lock to a specific provider version
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}