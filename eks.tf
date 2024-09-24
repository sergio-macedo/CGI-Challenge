# resource "aws_eks_cluster" "eks_cluster" {
#   name     = var.cluster_name
#   role_arn = aws_iam_role.eks_cluster_role.arn

#   vpc_config {
#     subnet_ids = aws_subnet.CGI_challenge_priv_subnet[*].id
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController
#   ]
# }



# resource "aws_eks_fargate_profile" "fargate_profile" {
#   cluster_name         = aws_eks_cluster.eks_cluster.name
#   fargate_profile_name = "fargate-profile"

#   pod_execution_role_arn = aws_iam_role.eks_fargate_execution_role.arn

#   subnet_ids = aws_subnet.CGI_challenge_priv_subnet[*].id

#   selector {
#     namespace = "default"
#   }
# }

# # IAM Role for Fargate Profile Execution
# resource "aws_iam_role" "eks_fargate_execution_role" {
#   name = "${var.cluster_name}-fargate-execution-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "eks-fargate-pods.amazonaws.com"
#       }
#     }]
#   })
# }

# # Attach necessary policies for EKS Fargate Execution Role
# resource "aws_iam_role_policy_attachment" "eks_fargate_execution_AmazonEKSFargatePodExecutionRolePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
#   role       = aws_iam_role.eks_fargate_execution_role.name
# }


provider "kubernetes" {
  host                   = aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

# resource "kubernetes_deployment" "app_deployment" {
#   metadata {
#     name      = "nodeapp"
#     namespace = "default"
#   }

#   spec {
#     replicas = 2
#     selector {
#       match_labels = {
#         app = "nodeapp"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "nodeapp"
#         }
#       }

#       spec {
#         container {
#           name  = "nodeapp-container"
#           image = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/cgi-ecr-node"
#           port {
#             container_port = 3000
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "app_service" {
#   metadata {
#     name      = "nodeapp-service"
#     namespace = "default"
#   }

#   spec {
#     type = "LoadBalancer"
#     selector = {
#       app = "nodeapp"
#     }

#     port {
#       port        = 80
#       target_port = 3000
#     }
#   }
# }
##
##
###
#####


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
# resource "aws_iam_role" "eks_role" {
#   name = "eks_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     "Statement": [
#         {
#             "Sid": "",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": [
#                     "ec2.amazonaws.com",
#                     "eks.amazonaws.com"
#                 ]
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
#   })
# }


# resource "aws_iam_role_policy_attachment" "node_policy_1" {
#   role       = aws_iam_role.eks_role_cgi.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# resource "aws_iam_role_policy_attachment" "cni_policy_1" {
#   role       = aws_iam_role.eks_role_cgi.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# resource "aws_iam_role_policy_attachment" "container_attachment_1" {
#     policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#     role       = aws_iam_role.eks_role_cgi.name

# }

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
}


# resource "aws_iam_role" "eks_node_role" {
#   name = "eks_node_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     "Statement": [
#         {
#             "Sid": "",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": [
#                     "ec2.amazonaws.com",
#                     "eks.amazonaws.com"
#                 ]
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "node_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# resource "aws_iam_role_policy_attachment" "cni_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# resource "aws_iam_role_policy_attachment" "container_attachment" {
#     policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#     role       = aws_iam_role.eks_node_role.name

# }

# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = <<EOF
# - rolearn: ${aws_iam_role.eks_unified_role.arn}
#   username: system:node:{{EC2PrivateDNSName}}
#   groups:
#     - system:bootstrappers
#     - system:nodes
# - rolearn: arn:aws:iam::767828742018:role/eks_unified_role  
#   username: terraform
#   groups:
#     - system:masters
# EOF
#   }

#   depends_on = [
#     aws_eks_node_group.example
#   ]
# }






# resource "kubernetes_deployment" "nginx" {
#   metadata {
#     name      = "nginx"
#     namespace = "default"
#   }

#   spec {
#     replicas = 2

#     selector {
#       match_labels = {
#         app = "nginx"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "nginx"
#         }
#       }

#       spec {
#         container {
#           name  = "nginx"
#           image = "nginx:latest"

#           port {
#             container_port = 80
#           }
#         }
#       }
#     }
#   }
# }


# resource "kubernetes_service" "nginx_service" {
#   metadata {
#     name      = "nginx-loadbalancer"
#     namespace = "default"
#   }

#   spec {
#     type = "LoadBalancer"

#     port {
#       port        = 80
#       target_port = 80
#     }

#     selector = {
#       app = "nginx"
#     }
#   }
# }