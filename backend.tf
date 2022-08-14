terraform {
  backend "s3" {
   region = "eu-central-1"
   bucket = "files-test-terraform"
   key    = "main/terraform.tfstate"
  }
}

