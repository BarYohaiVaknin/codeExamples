terraform {
    required_providers {
        aws = {
            version = "4.58.0"
            source = "hashicorp/aws"
        }//EOF aws

        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = ">= 2.10"
        }//EOF kubernetes
         helm = {
            source  = "hashicorp/helm"
            version = ">= 2.4.1"
         }//EOF helm
    }//EOF required_providers
}//EOF terraform