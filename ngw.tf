resource "aws_eip" "cgi_nat_eip" {
  # Elastic IP for the NAT Gateway (public IP for outbound internet access)
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-eip"
    }
  )
}

resource "aws_nat_gateway" "cgi_ngw" {
  allocation_id = aws_eip.cgi_nat_eip.id
  subnet_id     = aws_subnet.CGI_challenge_pub_subnet[0].id # NAT Gateway in the first public subnet
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-ngw"
    }
  )
}