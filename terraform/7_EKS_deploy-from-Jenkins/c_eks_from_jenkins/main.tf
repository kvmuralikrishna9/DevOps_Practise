# Calling VPC
module "VPC" {
  source                      = "./modules/VPC"
  vpc_cidr_block              = var.vpc_cidr_block # KEY = VALUE pair
  vpc_name                    = var.vpc_name       # KEY = copy each attribute from VPC module "variables.tf" as "KEY"
  vpc_igw                     = var.vpc_igw        # KEY = var.KEY map the key value with "dev-environment" variables.tf   
  env_name                    = var.env_name
  public_subnet_name          = var.public_subnet_name
  availability_zone_pub_sub   = var.availability_zone_pub_sub
  cidr_block_pub_subnet       = var.cidr_block_pub_subnet
  public_subnet_name-2        = var.public_subnet_name-2
  availability_zone_pub_sub-2 = var.availability_zone_pub_sub-2
  cidr_block_pub_subnet-2     = var.cidr_block_pub_subnet-2
  #private_subnet_name       = var.private_subnet_name
  #availability_zone_pvt_sub = var.availability_zone_pvt_sub
  #cidr_block_pvt_subnet     = var.cidr_block_pvt_subnet
  route_table_name = var.route_table_name

  sg_name     = var.sg_name
  sg_tag_name = var.sg_tag_name
}


#Calling EKS Module
# Root module

module "EKS" {
  source            = "./modules/EKS"
  vpc_id            = module.VPC.vpc_id # gets vpc_if from VPC output.tf 
  cidr_pub_subnet   = [var.cidr_pub_subnet]
  cidr_pub_subnet-2 = [var.cidr_pub_subnet-2]

  subnet_ids = [module.VPC.subnet_id_output_pub, module.VPC.subnet_id_output_pub-2] #last   # gets from VPC output.tf +

  cluster_name            = var.cluster_name
  cluster_role_arn        = var.cluster_role_arn
  instance_types          = var.instance_types
  public_access_cidrs     = var.public_access_cidrs
  env_name                = var.env_name
  node_group_name         = var.node_group_name
  node_group_role_arn     = var.node_group_role_arn
  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access
  scaling_desired_size    = var.scaling_desired_size
  scaling_min_size        = var.scaling_min_size
  scaling_max_size        = var.scaling_max_size
}

module "IAM" {
  source                   = "./modules/IAM"
  cluster_role_name        = var.cluster_role_name
  eks_node_group_role_name = var.eks_node_group_role_name
  env_name                 = var.env_name
}
