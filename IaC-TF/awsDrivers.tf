resource "helm_release" "ebsCSIDriver" {
  name         = "aws-ebs-csi-driver"
  repository   = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart        = "aws-ebs-csi-driver"
  namespace    = "kube-system"

  depends_on   = [module.eks.eks_managed_node_groups]
}//End OF ebsCSIDriver