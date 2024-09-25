data "aws_caller_identity" "current" {

}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = "token_eks"
}
