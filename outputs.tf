# output "vpc" {
#   value = {
#     id         = aws_vpc.cgi_vpc.id
#     arn        = aws_vpc.cgi_vpc.arn
#     cidr_block = aws_vpc.cgi_vpc.cidr_block
#   }

# }


# output "subnets" {
#   value = {
#     private = {
#       id         = aws_subnet.CGI_challenge_priv_subnet.*.id
#       cidr_block = aws_subnet.CGI_challenge_priv_subnet.*.cidr_block
#     }
#     public = {
#       id         = aws_subnet.CGI_challenge_pub_subnet.*.id
#       cidr_block = aws_subnet.CGI_challenge_pub_subnet.*.cidr_block
#     }
#   }

# }

# output "route_tables" {
#   value = {
#     private = {
#       id = aws_route_table.cgi_priv_rtb.*.id
#     }
#     public = {
#       id = aws_route_table.cgi_pub_rtb.*.id
#     }
#   }

# }

