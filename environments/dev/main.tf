# calling modules
module "iam_role" {
  source                  = "../../modules/iam_role"
  environment             = "dev"
  assume_role_principals  = var.assume_role_principals
}