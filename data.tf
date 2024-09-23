data "aws_ecr_authorization_token" "ecr" {
  registry_id = aws_ecr_repository.cgi_ecr_node.id
}

data "aws_caller_identity" "current" {

}
