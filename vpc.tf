resource "aws_vpc" "cgi_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}


# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id             = aws_vpc.cgi_vpc.id
#   service_name       = "com.amazonaws.${var.aws_region}.ecr.api"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = aws_subnet.CGI_challenge_priv_subnet[*].id # Your private subnets where Fargate runs
#   security_group_ids = [aws_security_group.endpoint_sg.id]
# }

# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id             = aws_vpc.cgi_vpc.id
#   service_name       = "com.amazonaws.${var.aws_region}.ecr.dkr"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = aws_subnet.CGI_challenge_priv_subnet[*].id
#   security_group_ids = [aws_security_group.endpoint_sg.id]
# }

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = aws_vpc.cgi_vpc.id
#   service_name      = "com.amazonaws.${var.aws_region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = aws_route_table.cgi_priv_rtb.*.id
# }

