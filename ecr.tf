resource "aws_ecr_repository" "cgi_ecr_node" {
  name                 = "cgi-ecr-node"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true


}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle" {
  repository = aws_ecr_repository.cgi_ecr_node.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 5 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
    }]
  })
}

resource "null_resource" "login_to_ecr" {
  provisioner "local-exec" {
    command = <<EOT
     aws ecr get-login-password --region ${var.aws_region}\
      | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
      EOT
  }
}

resource "null_resource" "docker_build_and_push" {
  depends_on = [null_resource.login_to_ecr]

  provisioner "local-exec" {
    command = <<EOT
      docker build -t cgi-ecr-node .
      docker tag cgi-ecr-node ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/cgi-ecr-node:latest
      docker push ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/cgi-ecr-node:latest
    EOT
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.cgi_ecr_node.repository_url
}

