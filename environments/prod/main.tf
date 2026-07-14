# =============================================================================
# Prod Environment
# =============================================================================

module "iam" {
  source = "../../modules/iam"

  environment            = "prod"
  assume_role_principals = var.assume_role_principals
}

module "network" {
  source = "../../modules/network"

  environment         = "prod"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "storage" {
  source = "../../modules/storage"

  environment = "prod"
  project     = "globeleq"
}

module "compute" {
  source = "../../modules/compute"

  environment = "prod"
  vpc_id      = module.network.vpc_id
  subnet_id   = module.network.public_subnet_ids[0]
  key_name    = var.key_name
}
