provider "aws" {
  region  = "eu-central-1"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

provider "http" {}

terraform {
  backend "s3" {
   region = "eu-central-1"
   bucket = "files-test-terraform"
   key    = "main/terraform.tfstate"
  }
}