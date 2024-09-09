module "ecr" {
  source = "./modules/ecr"
}

module "vpc" {
  source  = "./modules/vpc"
}