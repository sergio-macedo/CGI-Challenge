data "aws_ecr_authorization_token" "ecr" {
  registry_id = aws_ecr_repository.kind_nginx_kubectl_repo.id
}
