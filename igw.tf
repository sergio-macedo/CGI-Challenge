resource "aws_internet_gateway" "cgi_igw" {
  vpc_id = aws_vpc.cgi_vpc.id
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-igw"
    }
  )
}
