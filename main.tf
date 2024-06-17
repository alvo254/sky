module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "eks" {
  source = "./modules/eks"
  subnet_id1 = module.vpc.pub_sub1
  private_subent1 = module.vpc.private_subent1
  ssh_key_name = module.ec2.ec2_ssh_key
}

module "ec2" {
  source = "./modules/ec2"
  pub_subnet = module.vpc.pub_sub1
  security_group = module.sg.security_group
}