provider "aws" {
  region = var.region
}

terraform {
  required_version = "~> 1.1.2"

  required_providers {
    aws = "~> 4.18.0"
  }
}