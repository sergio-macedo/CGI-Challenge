# resource "aws_eip" "cgi_nat_eip" {
#   count = length(var.azs)
#   tags = merge(
#     local.tags,
#     {
#       Name = "${var.project_name}-eip"
#     }
#   )
# }

# resource "aws_nat_gateway" "cgi_ngw" {
#   count = length(var.azs)
#   allocation_id = aws_eip.cgi_nat_eip[count.index].id
#   subnet_id     = aws_subnet.CGI_challenge_pub_subnet[count.index].id
#   tags = merge(
#     local.tags,
#     {
#       Name = "${var.project_name}-ngw ${count.index + 1}"
#     }
#   )
# }