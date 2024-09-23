# resource "aws_subnet" "CGI_challenge_priv_subnet" {
#   count             = length(var.azs)
#   vpc_id            = aws_vpc.cgi_vpc.id
#   cidr_block        = var.private_subnet_cidrs[count.index]
#   availability_zone = var.azs[count.index]
#   tags = merge(
#     local.tags,
#     {
#       Name = "${var.project_name}-private_sub${count.index + 1}"
#     }
#   )

# }

# resource "aws_route_table" "cgi_priv_rtb" {
#   count  = length(var.azs)
#   vpc_id = aws_vpc.cgi_vpc.id


   

#   tags = merge(
#     local.tags,
#     {
#       Name = "${var.project_name}-private_rtb${count.index + 1}"
#     }
#   )
# }

# resource "aws_route_table_association" "private_assoc" {
#   count          = length(var.azs)
#   subnet_id      = aws_subnet.CGI_challenge_priv_subnet[count.index].id
#   route_table_id = aws_route_table.cgi_priv_rtb[count.index].id
# }
