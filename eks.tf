provider "kubernetes" {
  host                   = aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}


resource "aws_eks_cluster" "example" {
  name     = "example-cluster"
  role_arn = aws_iam_role.eks_unified_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.CGI_challenge_pub_subnet[0].id,
    aws_subnet.CGI_challenge_pub_subnet[1].id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy]
}
resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_unified_role.name
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "example-node-group"
  node_role_arn   = aws_iam_role.eks_unified_role.arn

  subnet_ids = [aws_subnet.CGI_challenge_pub_subnet[0].id,
  aws_subnet.CGI_challenge_pub_subnet[1].id]
  instance_types = ["t3.small"]


  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [aws_eks_cluster.example]


  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-node-group"
    }
  )
}
