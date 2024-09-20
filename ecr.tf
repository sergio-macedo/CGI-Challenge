resource "aws_ecr_repository" "kind_nginx_kubectl_repo" {
  name = "cgi-ecr-kind"
  
}

resource "null_resource" "login_to_ecr" {
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 767828742018.dkr.ecr.eu-central-1.amazonaws.com"
  }
}

resource "null_resource" "docker_build_and_push" {
  depends_on = [null_resource.login_to_ecr]

  provisioner "local-exec" {
    command = <<EOT
      docker build -t cgi-ecr-kind .
      docker tag cgi-ecr-kind:latest 767828742018.dkr.ecr.eu-central-1.amazonaws.com/cgi-ecr-kind:latest
      docker push 767828742018.dkr.ecr.eu-central-1.amazonaws.com/cgi-ecr-kind:latest
    EOT
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.kind_nginx_kubectl_repo.repository_url
}


# resource "docker_registry_image" "helloworld" {
#   name          = docker_image.image.name
#   keep_remotely = true
# }

# resource "docker_image" "image" {
#   name = "${aws_ecr_repository.kind_nginx_kubectl_repo.repository_url}:1.0.0"

#   build {
#     dockerfile = "Dockerfile"
#   }
# }