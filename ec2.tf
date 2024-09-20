resource "aws_key_pair" "cgi_kind_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH and other necessary ports"
  vpc_id = aws_vpc.cgi_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "cgi_kind_instance" {
  subnet_id = aws_subnet.CGI_challenge_pub_subnet.id
  ami             = "ami-0df0e7600ad0913a9"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_ssh.id]
  key_name        = aws_key_pair.cgi_kind_key.key_name

  # Install Docker and KinD via user_data
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo service docker start
              sudo usermod -aG docker ec2-user
              curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
              chmod +x ./kind
              sudo mv ./kind /usr/local/bin/kind
              EOF

  tags = {
    Name = "KinD-EC2"
  }
}

# Output the instance public IP
output "instance_public_ip" {
  value = aws_instance.cgi_kind_instance.public_ip
}