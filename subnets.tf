resource "aws_subnet" "CGI_challenge_pub_subnet" {
  vpc_id                  = aws_vpc.cgi_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
  tags = {
    Name = "CGI-Public-Subnet"
  }

}

resource "aws_subnet" "CGI_challenge_priv_subnet" {
  vpc_id            = aws_vpc.cgi_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "CGI-Private-Subnet"
  }

}