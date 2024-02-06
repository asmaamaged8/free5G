
terraform {
  backend "s3" {
    bucket         = "asmproo"
    key            = "free_5g_infra.tfstate"
    region         = "us-east-1"
    dynamodb_table = "asmaa1"
  }

}
