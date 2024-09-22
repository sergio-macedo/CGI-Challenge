resource "aws_subnet" "CGI_challenge_pub_subnet" {
  count = length(var.azs)
  vpc_id                  = aws_vpc.cgi_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index]
  tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-public ${count.index +1}"
    }
  )
  }

resource "aws_route_table" "cgi_pub_rtb" {
  vpc_id = aws_vpc.cgi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cgi_igw.id
  }

    tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-rtb-public"
    }
  )
}


resource "aws_route_table_association" "public_assoc" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.CGI_challenge_pub_subnet.*.id[count.index]
  route_table_id = aws_route_table.cgi_pub_rtb.id
}

