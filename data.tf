data "aws_ecr_authorization_token" "ecr" {
  registry_id = aws_ecr_repository.cgi_ecr_node.id
}

data "aws_caller_identity" "current" {

}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = "token_eks"
}

#aws_eks_cluster_auth.eks_cluster_auth.token