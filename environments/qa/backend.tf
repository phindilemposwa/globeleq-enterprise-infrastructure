terraform {
  backend "s3" {
    bucket         = "globeleq-terraform-state"
    key            = "qa/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
