terraform {
  backend "s3" {
    bucket       = "globeleq-terraform-state-574548986680"
    key          = "qa/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
