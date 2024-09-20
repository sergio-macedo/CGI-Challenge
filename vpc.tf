resource "aws_vpc" "cgi_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CGI-Challenge"
  }

}

resource "aws_internet_gateway" "cgi_igw" {
  vpc_id = aws_vpc.cgi_vpc.id
  tags = {
    Name = "cgi-IGW"
  }
}

resource "aws_route_table" "cgi_pub_rtb" {
  vpc_id = aws_vpc.cgi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cgi_igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.CGI_challenge_pub_subnet.id
  route_table_id = aws_route_table.cgi_pub_rtb.id
}