data "aws_eks_cluster_auth" "clusterAuth" {
  name       = module.eks.cluster_name
}//EOF clusterAuth

provider "helm" {
    kubernetes {
      host                    = module.eks.cluster_endpoint
      cluster_ca_certificate  = base64decode(module.eks.cluster_certificate_authority_data)
      token                   = data.aws_eks_cluster_auth.clusterAuth.token
    }//EOF Kubernetes 
}//EOF helm provider

resource "helm_release" "argocd" {
    name        = "argo-cd"
    repository  = "https://argoproj.github.io/argo-helm"
    chart       = "argo-cd"
    namespace   = "default"
    version     = "5.34.5"

  values = [
    file("../values.yaml")
  ]//End OF values

  provisioner "local-exec" {
    command = "bash ../Bash/argoInit.sh"
  }//End OF local-exec
}//End OF argocd
