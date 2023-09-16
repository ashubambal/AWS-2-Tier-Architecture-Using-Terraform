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

# Creating Application Load balancer
module "alb" {
  source        = "../modules/alb"
  project_name  = module.vpc.project_name
  alb_sg        = module.security_groups.alb_sg
  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  vpc_id        = module.vpc.vpc_id
}

module "key" {
  source = "../modules/key"
}

module "asg" {
  source        = "../modules/asg"
  project_name  = module.vpc.project_name
  key_name      = module.key.key_name
  client_sg     = module.security_groups.client_sg
  pri_sub_3c_id = module.vpc.pri_sub_3c_id
  pri_sub_4d_id = module.vpc.pri_sub_4d_id
  tg_arn        = module.alb.tg_arn
}

module "cloudfront" {
  source = "../modules/cloudfront"
  # project_name            = module.vpc.project_name
  certificate_domain_name = var.certificate_domain_name
  additional_domain_name  = var.additional_domain_name
  alb_domain_name         = module.alb.alb_dns_name
}

module "route53" {
  source                    = "../modules/route53"
  cloudfront_domain_name    = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
}

module "rds" {
  source            = "../modules/rds"
  db_sg             = module.security_groups.db_sg
  pri_sub_5e_id = module.vpc.pri_sub_5e_id
  pri_sub_6f_id = module.vpc.pri_sub_6f_id
  db_username       = var.db_username
  db_password       = var.db_password
}