resource "aws_s3_bucket" "asma" {
  bucket = "asmaamagedpro"

}

terraform {
  backend "s3" {
    bucket         = "asmaamagedpro"
    key            = "project.tfstate"
    region         = "us-east-1"
    dynamodb_table = "asmaa"
  }
  
}
