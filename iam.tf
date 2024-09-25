resource "aws_iam_role" "eks_unified_role" {
  name = "${var.project_name}-eks-unified-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com" #control plane
        },
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com" # nodes
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_unified_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_unified_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_unified_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_unified_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_unified_role.name
}

resource "aws_iam_policy" "custom_eks_access_policy" {
  name        = "${var.project_name}-eks-custom-access"
  description = "Custom EKS access policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:CreateCluster",
          "eks:DeleteCluster",
          "eks:UpdateClusterConfig",
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "eks:GetToken"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "custom_eks_access_policy_attachment" {
  policy_arn = aws_iam_policy.custom_eks_access_policy.arn
  role       = aws_iam_role.eks_unified_role.name
}
