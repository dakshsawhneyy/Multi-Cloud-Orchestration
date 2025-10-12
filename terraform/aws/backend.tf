terraform {
  backend "s3" {
    bucket = "multi-cloud-orchestration-sf"
    region = "ap-south-1"
    key = "terraform.tfstate"
  }
}