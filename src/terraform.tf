provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-pdi-paulo"
    key    = "terraform-pdi.tfstate"
    region = "us-east-1"
  }
}
