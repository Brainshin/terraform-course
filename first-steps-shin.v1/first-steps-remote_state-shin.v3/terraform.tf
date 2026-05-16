terraform {
  backend "s3" {
    bucket = "terraform-sh123456s-2026"
    key    = "first-steps/terraform.tfstate"
    region = "ap-northeast-2"
  
    dynamodb_table = "terraform-locking"
  }
}


# 이미 instance.tf에서 provider를 명시하였음. 
#provider "aws" {
#  region = "ap-northeast-2"
#}