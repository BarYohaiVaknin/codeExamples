provider "kubernetes" {
   host                    = module.eks.cluster_endpoint
   cluster_ca_certificate  = base64decode(module.eks.cluster_certificate_authority_data)
   token                   = data.aws_eks_cluster_auth.clusterAuth.token
}//EOF kubernetes provider

provider "aws" {
   region = "us-west-1"  

   default_tags {
      tags = {
         created_by = "baryvee"
         managed_by = "terraform"
      }//EOF tags
   }//EOF default_tags
}//EOF "aws" provider

data "aws_vpc" "randomName-VPC" {
   id = var.vpc_id
}//EOF randomName-VPC

module "eks" {
   source                           = "terraform-aws-modules/eks/aws"
   version                          = "19.15.1" 
   cluster_version                  = "1.25"
   cluster_name                     = var.clusterName
   vpc_id                           = data.randomName-VPC
   subnet_ids                       = var.subnetsIDs
   cluster_endpoint_public_access   = true 

   eks_managed_node_groups = [
      {
         name = "randomName-NodeGroup"
         timeouts = { create = "10m" }
         launch_template_name = "randomName-EKS"
         instance_types = tolist([var.instanceType])
         max_size = var.scalingMaxSize
         min_size = var.scalingMinSize
         disk_size = var.diskSize
         subnet_ids = ["subnet-id"]
      }
   ]//EOF worker_groups
}//EOF eks module

