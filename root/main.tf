module "vpc" {
  source          = "../modules/vpc"
  region          = var.region
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pub_sub_2b_cidr = var.pub_sub_2b_cidr
  pri_sub_3c_cidr = var.pri_sub_3c_cidr
  pri_sub_4d_cidr = var.pri_sub_4d_cidr
  pri_sub_5e_cidr = var.pri_sub_5e_cidr
  pri_sub_6f_cidr = var.pri_sub_6f_cidr
}

module "nat" {
  source        = "../modules/nat"
  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  pri_sub_3c_id = module.vpc.pri_sub_3c_id
  pri_sub_4d_id = module.vpc.pri_sub_4d_id
  pri_sub_5e_id = module.vpc.pri_sub_5e_id
  pri_sub_6f_id = module.vpc.pri_sub_6f_id
  igw_id        = module.vpc.igw_id
  vpc_id        = module.vpc.vpc_id
}

module "security_groups" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}