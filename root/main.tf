module "vpc" {
  source          = "../modules/vpc"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pub_sub_2b_cidr = var.pub_sub_2b_cidr
  pri_sub_3c_cidr = var.pri_sub_3c_cidr
  pri_sub_4d_cidr = var.pri_sub_4d_cidr
  pri_sub_5e_cidr = var.pri_sub_5e_cidr
  pri_sub_6f_cidr = var.pri_sub_6e_cidr
}