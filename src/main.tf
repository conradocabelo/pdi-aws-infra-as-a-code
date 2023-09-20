module "network" {
  source = "./modules/vpc"
}

module "security_groups" {
  source     = "./modules/secutiry_groups"
  vpc_id     = module.network.aws_vpc_pdi_id
  depends_on = [module.network]
}

module "rds" {
  source            = "./modules/rds"
  security_group_id = module.security_groups.postgres_sg_id
  subnet_ids        = module.network.aws_vpc_public_subntes_id
  depends_on        = [module.security_groups]
}